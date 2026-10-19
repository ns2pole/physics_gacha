import * as admin from "firebase-admin";

import {hashValue} from "./auth";
import {
  AI_TUTOR_LEGACY_PRODUCT_ID,
  buildPassUsageDocId,
  legacyEntitlementRef,
  listPassRecords,
  PASS_LIMIT,
  PASS_VALIDITY_MS,
  passesCollectionRef,
} from "./aiTutorPasses";
import {UsageIdentity} from "./types";

interface LegacyEntitlementSnapshot {
  active: boolean;
  purchasedAtMs: number | null;
  expiresAtMs: number | null;
  productId?: string;
}

function sanitizeFirebaseDocId(value: string): string {
  return value.replace(/\//g, "_").slice(0, 128);
}

export function legacyMigrationPassId(userId: string): string {
  return sanitizeFirebaseDocId(`legacy-migrate-${userId}`);
}

function formatJstMonth(date: Date): string {
  return new Intl.DateTimeFormat("sv-SE", {
    year: "numeric",
    month: "2-digit",
    timeZone: "Asia/Tokyo",
  }).format(date);
}

function readFirestoreTimestampMs(value: unknown): number | null {
  if (value instanceof admin.firestore.Timestamp) {
    return value.toMillis();
  }
  return null;
}

export async function readLegacyMonthlyUsageCount(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
  date = new Date(),
): Promise<number> {
  const periodKey = formatJstMonth(date);
  const key = hashValue(`${identity.source}:${identity.id}:${periodKey}`);
  const snapshot = await db.collection("ai_chat_usage").doc(key).get();
  if (!snapshot.exists) return 0;

  const tier = snapshot.get("tier");
  if (tier !== "paid") return 0;

  return Number(snapshot.get("count") ?? 0);
}

async function readLegacyEntitlement(
  db: FirebaseFirestore.Firestore,
  userId: string,
): Promise<LegacyEntitlementSnapshot | null> {
  const snapshot = await legacyEntitlementRef(db, userId).get();
  if (!snapshot.exists) return null;

  return {
    active: snapshot.get("active") === true,
    purchasedAtMs: readFirestoreTimestampMs(snapshot.get("purchasedAt")),
    expiresAtMs: readFirestoreTimestampMs(snapshot.get("expiresAt")),
    productId: typeof snapshot.get("productId") === "string" ?
      snapshot.get("productId") as string :
      undefined,
  };
}

function isLegacyEntitlementActive(snapshot: LegacyEntitlementSnapshot): boolean {
  if (!snapshot.active) return false;
  if (snapshot.expiresAtMs == null) return true;
  return snapshot.expiresAtMs > Date.now();
}

async function deactivateLegacyEntitlement(
  db: FirebaseFirestore.Firestore,
  userId: string,
  migratedToPassId: string,
): Promise<void> {
  await legacyEntitlementRef(db, userId).set({
    active: false,
    migratedToPassId,
    migratedAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  }, {merge: true});
}

async function seedPassUsageCount(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
  passId: string,
  count: number,
): Promise<void> {
  const usageRef = db.collection("ai_chat_usage").doc(
    buildPassUsageDocId(identity, passId),
  );
  await usageRef.set({
    count,
    identitySource: identity.source,
    tier: "paid",
    period: "pass",
    periodKey: `pass:${passId}`,
    passId,
    limit: PASS_LIMIT,
  });
}

export async function migrateLegacyEntitlementToPassIfNeeded(
  db: FirebaseFirestore.Firestore,
  userId: string,
): Promise<boolean> {
  const entitlement = await readLegacyEntitlement(db, userId);
  if (entitlement == null || !isLegacyEntitlementActive(entitlement)) {
    return false;
  }

  const passId = legacyMigrationPassId(userId);
  const passRef = passesCollectionRef(db, userId).doc(passId);
  const existingPass = await passRef.get();

  if (existingPass.exists) {
    await deactivateLegacyEntitlement(db, userId, passId);
    return false;
  }

  const purchasedAtMs = entitlement.purchasedAtMs ?? Date.now();
  const expiresAtMs = entitlement.expiresAtMs ??
    purchasedAtMs + PASS_VALIDITY_MS;

  await passRef.set({
    passId,
    purchasedAt: admin.firestore.Timestamp.fromMillis(purchasedAtMs),
    expiresAt: admin.firestore.Timestamp.fromMillis(expiresAtMs),
    limit: PASS_LIMIT,
    productId: entitlement.productId ?? AI_TUTOR_LEGACY_PRODUCT_ID,
    migratedFromLegacy: true,
    revenueCatEventId: null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  const identity: UsageIdentity = {id: userId, source: "firebase"};
  const legacyUsed = await readLegacyMonthlyUsageCount(db, identity);
  if (legacyUsed > 0) {
    await seedPassUsageCount(
      db,
      identity,
      passId,
      Math.min(legacyUsed, PASS_LIMIT),
    );
  }

  await deactivateLegacyEntitlement(db, userId, passId);
  return true;
}

export async function ensureLegacyMigratedForFirebaseUser(
  db: FirebaseFirestore.Firestore,
  userId: string,
): Promise<void> {
  const passes = await listPassRecords(db, userId);
  const entitlement = await readLegacyEntitlement(db, userId);
  if (entitlement == null || !entitlement.active) return;
  if (passes.some((pass) => pass.passId === legacyMigrationPassId(userId))) {
    await deactivateLegacyEntitlement(db, userId, legacyMigrationPassId(userId));
    return;
  }
  await migrateLegacyEntitlementToPassIfNeeded(db, userId);
}
