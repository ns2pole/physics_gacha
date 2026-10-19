export type AiChatRole = "user" | "assistant";

export interface AiChatContext {
  title: string;
  questionText: string;
  category?: string | null;
  level?: string | null;
  referenceAnswer?: string | null;
  referenceSolution?: string | null;
  hintShown?: boolean;
  answerShown?: boolean;
  attachmentsEnabled?: boolean;
}

export interface AiChatMessage {
  role: AiChatRole;
  text: string;
  choiceId?: string | null;
}

export type AiChatLocale = "ja" | "en";

export interface UsageIdentifiable {
  clientInstallationId: string;
}

export interface AiChatRequest extends UsageIdentifiable {
  context: AiChatContext;
  history: AiChatMessage[];
  userMessage: AiChatMessage;
  locale: AiChatLocale;
}

export interface AiChatStarterRequest extends UsageIdentifiable {
  context: AiChatContext;
  locale: AiChatLocale;
}

export interface UsageIdentity {
  id: string;
  source: "firebase" | "installation" | "ip";
}

export interface UsageLimit {
  tier: "free" | "paid";
  period: "daily" | "monthly" | "pass";
  limit: number;
  periodKey: string;
}

export interface AiTutorPassRecord {
  passId: string;
  purchasedAtMs: number;
  expiresAtMs: number;
  limit: number;
  productId: string;
  revenueCatEventId: string | null;
}

export interface PassUsageDetail {
  passId: string;
  purchasedAtMs: number;
  expiresAtMs: number;
  used: number;
  limit: number;
  remaining: number;
}

export interface FreeUsageDetail {
  count: number;
  limit: number;
  remaining: number;
  periodKey: string;
}

export interface UsageSummary {
  tier: "free" | "paid";
  period: "monthly" | "pass";
  count: number;
  limit: number;
  remaining: number;
  periodKey: string;
  passes?: PassUsageDetail[];
  free?: FreeUsageDetail;
}
