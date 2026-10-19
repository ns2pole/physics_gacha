import * as admin from "firebase-admin";
import {hashValue} from "./auth";
import {AiTutorPassRecord, PassUsageDetail, UsageIdentity} from "./types";

// Legacy non-renewing subscription (deprecated):
// export const AI_TUTOR_LEGACY_ENTITLEMENT_ID = "ai_tutor_subsc";
// export const AI_TUTOR_LEGACY_PRODUCT_ID = "ai_tutor_subsc_500yen";

export const AI_TUTOR_ENTITLEMENT_ID = "ai_tutor_one_year_consumable";
export const AI_TUTOR_PRODUCT_ID = "ai_tutor_one_year_500yen_consumable";
export const AI_TUTOR_LEGACY_ENTITLEMENT_ID = "ai_tutor_subsc";
export const AI_TUTOR_LEGACY_PRODUCT_ID = "ai_tutor_subsc_500yen";
export const PASS_LIMIT = 500;
export const PASS_VALIDITY_MS = 365 * 24 * 60 * 60 * 1000;

const purchaseEventTypes = new Set([
  "INITIAL_PURCHASE",
  "NON_RENEWING_PURCHASE",
  "NON_SUBSCRIPTION_PURCHASE",
  "RENEWAL",
  "UNCANCELLATION",
]);

export interface PassPurchaseEvent {
  id: string;
  type: string;
  productId: string | null;
  expirationAtMs: number | null;
  purchasedAtMs: number | null;
  transactionId: string | null;
}

export function isAiTutorProductId(productId: string | null): boolean {
  return productId === AI_TUTOR_PRODUCT_ID ||
    productId === AI_TUTOR_LEGACY_PRODUCT_ID;
}

export function isAiTutorEntitlementId(entitlementId: string): boolean {
  return entitlementId === AI_TUTOR_ENTITLEMENT_ID ||
    entitlementId === AI_TUTOR_LEGACY_ENTITLEMENT_ID;
}

export function isLegacyAiTutorProductId(productId: string | null): boolean {
  return productId === AI_TUTOR_LEGACY_PRODUCT_ID;
}

export function isLegacyAiTutorEntitlementEvent(event: {
  productId: string | null;
  entitlementIds: string[];
}): boolean {
  return isLegacyAiTutorProductId(event.productId) ||
    event.entitlementIds.includes(AI_TUTOR_LEGACY_ENTITLEMENT_ID);
}

const inactiveLegacyEventTypes = new Set([
  "EXPIRATION",
  "BILLING_ISSUE",
  "PRODUCT_CHANGE",
]);

export function isLegacyEntitlementActive(event: {
  type: string;
  expirationAtMs: number | null;
}): boolean {
  if (inactiveLegacyEventTypes.has(event.type)) return false;
  if (event.expirationAtMs == null) return true;
  return event.expirationAtMs > Date.now();
}

export function passesCollectionRef(
  db: FirebaseFirestore.Firestore,
  userId: string,
) {
  return db.collection("users").doc(userId).collection("ai_tutor_passes");
}

export function legacyEntitlementRef(
  db: FirebaseFirestore.Firestore,
  userId: string,
) {
  return db
    .collection("users")
    .doc(userId)
    .collection("entitlements")
    .doc(AI_TUTOR_LEGACY_ENTITLEMENT_ID);
}

export function passDocIdFromEvent(event: PassPurchaseEvent): string {
  const transactionId = event.transactionId?.trim();
  if (transactionId != null && transactionId.length > 0) {
    return sanitizeFirebaseDocId(transactionId);
  }
  if (event.purchasedAtMs != null) {
    const productId = event.productId ?? AI_TUTOR_PRODUCT_ID;
    return sanitizeFirebaseDocId(`purchase-${productId}-${event.purchasedAtMs}`);
  }
  return sanitizeFirebaseDocId(event.id.trim());
}

export function dedupePassPurchaseEvents(
  events: PassPurchaseEvent[],
): PassPurchaseEvent[] {
  const seen = new Set<string>();
  const deduped: PassPurchaseEvent[] = [];

  for (const event of events) {
    const key = passDocIdFromEvent(event);
    if (key.length === 0 || seen.has(key)) continue;
    seen.add(key);
    deduped.push(event);
  }

  return deduped;
}

const purchaseFingerprintWindowMs = 5000;

export async function hasPassMatchingPurchase(
  db: FirebaseFirestore.Firestore,
  userId: string,
  event: PassPurchaseEvent,
): Promise<boolean> {
  if (event.purchasedAtMs == null) return false;

  const productId = event.productId ?? AI_TUTOR_PRODUCT_ID;
  const snapshot = await passesCollectionRef(db, userId).get();
  for (const doc of snapshot.docs) {
    const purchasedAtMs = readFirestoreTimestampMs(doc.get("purchasedAt"));
    if (purchasedAtMs == null) continue;

    const existingProductId = String(doc.get("productId") ?? AI_TUTOR_PRODUCT_ID);
    if (existingProductId !== productId) continue;
    if (Math.abs(purchasedAtMs - event.purchasedAtMs) <= purchaseFingerprintWindowMs) {
      return true;
    }
  }
  return false;
}

export function shouldCreatePassFromEvent(event: PassPurchaseEvent): boolean {
  if (event.purchasedAtMs == null) return false;
  if (event.type === "EXPIRATION" ||
    event.type === "BILLING_ISSUE" ||
    event.type === "CANCELLATION") {
    return false;
  }
  if (event.type === "CLIENT_SYNC") return true;
  return purchaseEventTypes.has(event.type);
}

export function resolvePassExpiresAtMs(event: PassPurchaseEvent): number {
  if (event.expirationAtMs != null) return event.expirationAtMs;
  if (event.purchasedAtMs == null) return Date.now() + PASS_VALIDITY_MS;
  return event.purchasedAtMs + PASS_VALIDITY_MS;
}

export async function upsertPassFromPurchaseEvent(
  db: FirebaseFirestore.Firestore,
  userId: string,
  event: PassPurchaseEvent,
): Promise<boolean> {
  if (!shouldCreatePassFromEvent(event)) return false;
  if (event.purchasedAtMs == null) return false;

  const passId = passDocIdFromEvent(event);
  if (passId.length === 0) return false;

  if (await hasPassMatchingPurchase(db, userId, event)) return false;

  const ref = passesCollectionRef(db, userId).doc(passId);
  const existing = await ref.get();
  if (existing.exists) return false;

  const purchasedAtMs = event.purchasedAtMs;
  const expiresAtMs = resolvePassExpiresAtMs(event);

  await ref.set({
    passId,
    purchasedAt: admin.firestore.Timestamp.fromMillis(purchasedAtMs),
    expiresAt: admin.firestore.Timestamp.fromMillis(expiresAtMs),
    limit: PASS_LIMIT,
    productId: event.productId ?? AI_TUTOR_PRODUCT_ID,
    revenueCatEventId: event.id.length > 0 ? event.id : null,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });
  return true;
}

export async function listPassRecords(
  db: FirebaseFirestore.Firestore,
  userId: string,
): Promise<AiTutorPassRecord[]> {
  const snapshot = await passesCollectionRef(db, userId).get();
  const now = Date.now();
  const passes: AiTutorPassRecord[] = [];

  for (const doc of snapshot.docs) {
    const purchasedAtMs = readFirestoreTimestampMs(doc.get("purchasedAt"));
    const expiresAtMs = readFirestoreTimestampMs(doc.get("expiresAt"));
    if (purchasedAtMs == null || expiresAtMs == null) continue;
    if (expiresAtMs <= now) continue;

    passes.push({
      passId: doc.id,
      purchasedAtMs,
      expiresAtMs,
      limit: Number(doc.get("limit") ?? PASS_LIMIT),
      productId: String(doc.get("productId") ?? AI_TUTOR_PRODUCT_ID),
      revenueCatEventId: readNullableString(doc.get("revenueCatEventId")),
    });
  }

  return passes.sort((a, b) => a.purchasedAtMs - b.purchasedAtMs);
}

export function buildPassUsageDocId(
  identity: UsageIdentity,
  passId: string,
): string {
  return hashValue(`${identity.source}:${identity.id}:pass:${passId}`);
}

export async function readPassUsageCount(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
  passId: string,
): Promise<number> {
  const ref = db.collection("ai_chat_usage").doc(buildPassUsageDocId(identity, passId));
  const snapshot = await ref.get();
  if (!snapshot.exists) return 0;
  return Number(snapshot.get("count") ?? 0);
}

export async function attachPassUsage(
  db: FirebaseFirestore.Firestore,
  identity: UsageIdentity,
  passes: AiTutorPassRecord[],
): Promise<PassUsageDetail[]> {
  const details = await Promise.all(passes.map(async (pass) => {
    const used = await readPassUsageCount(db, identity, pass.passId);
    const remaining = Math.max(0, pass.limit - used);
    return {
      passId: pass.passId,
      purchasedAtMs: pass.purchasedAtMs,
      expiresAtMs: pass.expiresAtMs,
      used,
      limit: pass.limit,
      remaining,
    };
  }));
  return details.sort((a, b) => a.purchasedAtMs - b.purchasedAtMs);
}

export function selectFifoPass(
  passes: PassUsageDetail[],
): PassUsageDetail | null {
  const available = passes
    .filter((pass) => pass.remaining > 0)
    .sort((a, b) => a.purchasedAtMs - b.purchasedAtMs);
  return available[0] ?? null;
}

export function summarizePassUsage(passes: PassUsageDetail[]): {
  totalUsed: number;
  totalCapacity: number;
  totalRemaining: number;
} {
  let totalUsed = 0;
  let totalCapacity = 0;
  for (const pass of passes) {
    totalUsed += pass.used;
    totalCapacity += pass.limit;
  }
  return {
    totalUsed,
    totalCapacity,
    totalRemaining: Math.max(0, totalCapacity - totalUsed),
  };
}

function readFirestoreTimestampMs(value: unknown): number | null {
  if (value instanceof admin.firestore.Timestamp) {
    return value.toMillis();
  }
  return null;
}

function readNullableString(value: unknown): string | null {
  return typeof value === "string" && value.length > 0 ? value : null;
}

function sanitizeFirebaseDocId(value: string): string {
  return value.replace(/\//g, "_").slice(0, 128);
}
