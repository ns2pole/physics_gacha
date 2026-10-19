import * as admin from "firebase-admin";
import {hashValue} from "./auth";
import {
  attachPassUsage,
  buildPassUsageDocId,
  listPassRecords,
  selectFifoPass,
  summarizePassUsage,
} from "./aiTutorPasses";
import {ensureLegacyMigratedForFirebaseUser} from "./legacyPassMigration";
import {
  AiTutorPassRecord,
  FreeUsageDetail,
  UsageIdentity,
  UsageLimit,
  UsageSummary,
} from "./types";

const defaultPolicy = {
  freeMonthlyLimit: 15,
};

export class RateLimitExceededError extends Error {
  constructor(readonly limit: UsageLimit) {
    super(resolveRateLimitMessage(limit));
  }
}

function resolveRateLimitMessage(limit: UsageLimit): string {
  if (limit.period === "pass") {
    return `AIチューター Pass の利用上限 (${limit.limit}回) に達しました。`;
  }
  if (limit.tier === "paid") {
    return `今月のAIチャット利用上限 (${limit.limit}回) に達しました。`;
  }
  return `今月の無料AIチャット利用上限 (${limit.limit}回) に達しました。`;
}

export async function getUsageSummary(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
): Promise<UsageSummary> {
  if (identity.source === "firebase") {
    return getCompositeUsageSummary(db, identity);
  }

  return getFreeUsageSummary(db, identity);
}

async function getCompositeUsageSummary(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
): Promise<UsageSummary> {
  await ensureLegacyMigratedForFirebaseUser(db, identity.id);

  const free = await getFreeUsageSummary(db, identity);
  const passes = await listPassRecords(db, identity.id);

  if (passes.length > 0) {
    const passDetails = await attachPassUsage(db, identity, passes);
    const totals = summarizePassUsage(passDetails);
    const freeDetail = toFreeUsageDetail(free);
    const totalRemaining = freeDetail.remaining + totals.totalRemaining;

    return {
      tier: freeDetail.remaining > 0 ? "free" : "paid",
      period: freeDetail.remaining > 0 ? "monthly" : "pass",
      count: freeDetail.count + totals.totalUsed,
      limit: freeDetail.limit + totals.totalCapacity,
      remaining: totalRemaining,
      periodKey: freeDetail.remaining > 0 ? free.periodKey : "pass:aggregate",
      free: freeDetail,
      passes: passDetails,
    };
  }

  return free;
}

function toFreeUsageDetail(summary: UsageSummary): FreeUsageDetail {
  return {
    count: summary.count,
    limit: summary.limit,
    remaining: summary.remaining,
    periodKey: summary.periodKey,
  };
}

async function getFreeUsageSummary(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
): Promise<UsageSummary> {
  const periodKey = formatJstMonth(new Date());
  const key = hashValue(`${identity.source}:${identity.id}:${periodKey}`);
  const ref = db.collection("ai_chat_usage").doc(key);
  const snapshot = await ref.get();
  const count = readFreeTierUsageCount(snapshot);
  const limit = defaultPolicy.freeMonthlyLimit;

  return {
    tier: "free",
    period: "monthly",
    count,
    limit,
    remaining: Math.max(0, limit - count),
    periodKey,
  };
}

function readFreeTierUsageCount(
  snapshot: FirebaseFirestore.DocumentSnapshot,
): number {
  if (!snapshot.exists) return 0;
  const tier = snapshot.get("tier");
  if (tier != null && tier !== "free") return 0;
  return Number(snapshot.get("count") ?? 0);
}

export async function consumeUsage(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
): Promise<UsageSummary> {
  if (identity.source === "firebase") {
    await ensureLegacyMigratedForFirebaseUser(db, identity.id);

    const free = await getFreeUsageSummary(db, identity);
    if (free.remaining > 0) {
      await incrementFreeUsage(db, identity);
      return getCompositeUsageSummary(db, identity);
    }

    const passes = await listPassRecords(db, identity.id);
    if (passes.length > 0) {
      return consumePaidPassUsage(db, identity, passes);
    }
  }

  await incrementFreeUsage(db, identity);
  if (identity.source === "firebase") {
    return getCompositeUsageSummary(db, identity);
  }
  return getFreeUsageSummary(db, identity);
}

async function consumePaidPassUsage(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
  passes: AiTutorPassRecord[],
): Promise<UsageSummary> {
  const passDetails = await attachPassUsage(db, identity, passes);
  const target = selectFifoPass(passDetails);
  if (target == null) {
    const totals = summarizePassUsage(passDetails);
    throw new RateLimitExceededError({
      tier: "paid",
      period: "pass",
      limit: totals.totalCapacity,
      periodKey: "pass:aggregate",
    });
  }

  const usageRef = db.collection("ai_chat_usage").doc(
    buildPassUsageDocId(identity, target.passId),
  );
  const periodKey = `pass:${target.passId}`;

  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(usageRef);
    const current = snapshot.exists ? Number(snapshot.get("count") ?? 0) : 0;
    if (current >= target.limit) {
      throw new RateLimitExceededError({
        tier: "paid",
        period: "pass",
        limit: target.limit,
        periodKey,
      });
    }

    const next = current + 1;
    transaction.set(usageRef, {
      count: next,
      identitySource: identity.source,
      tier: "paid",
      period: "pass",
      periodKey,
      passId: target.passId,
      limit: target.limit,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: snapshot.exists ?
        snapshot.get("createdAt") :
        admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});
  });

  return getCompositeUsageSummary(db, identity);
}

async function incrementFreeUsage(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
): Promise<void> {
  const periodKey = formatJstMonth(new Date());
  const limit = defaultPolicy.freeMonthlyLimit;
  const key = hashValue(`${identity.source}:${identity.id}:${periodKey}`);
  const ref = db.collection("ai_chat_usage").doc(key);

  await db.runTransaction(async (transaction) => {
    const snapshot = await transaction.get(ref);
    const current = readFreeTierUsageCount(snapshot);
    if (current >= limit) {
      throw new RateLimitExceededError({
        tier: "free",
        period: "monthly",
        limit,
        periodKey,
      });
    }

    const next = current + 1;
    transaction.set(ref, {
      count: next,
      identitySource: identity.source,
      tier: "free",
      period: "monthly",
      periodKey,
      limit,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
      createdAt: snapshot.exists ?
        snapshot.get("createdAt") :
        admin.firestore.FieldValue.serverTimestamp(),
    }, {merge: true});
  });
}

function formatJstMonth(date: Date): string {
  return formatJst(date, {
    year: "numeric",
    month: "2-digit",
  });
}

function formatJst(date: Date, options: Intl.DateTimeFormatOptions): string {
  return new Intl.DateTimeFormat("sv-SE", {
    ...options,
    timeZone: "Asia/Tokyo",
  }).format(date);
}
