import {
  normalizeDoubleEscapedLatex,
  repairTabCorruptedLatex,
} from "./latexSafeJsonString";
import {parseAiChatGeminiJson} from "./parseAiChatGeminiJson";
import {AiChatRequest} from "./types";

export interface AiChatQuickReply {
  label: string;
  sendText?: string;
  actionId?: string;
}

export interface AiChatStructuredReply {
  /** Display / storage text after double-backslash normalization. */
  text: string;
  /** LaTeX-safe decoded `text` before [normalizeDoubleEscapedLatex] (assistant only). */
  textRaw?: string;
  quickReplies: AiChatQuickReply[];
}

const maxQuickReplies = 5;
const maxLabelLength = 60;
const maxSendTextLength = 200;

const jaAnswerSeekingPattern =
  /答え|最終結果|答えだけ|答えを教|解を全部|全部教え|フルソリューション|完全な解/;
const enAnswerSeekingPattern =
  /\b(final\s+answer|give\s+me\s+the\s+answer|just\s+the\s+answer|full\s+solution|complete\s+solution|tell\s+me\s+the\s+answer)\b/i;

export function parseAiChatStructuredResponse(
  raw: string,
  request: AiChatRequest,
): AiChatStructuredReply {
  const trimmed = repairTabCorruptedLatex(raw.trim());
  if (trimmed.length === 0) {
    return {text: "", quickReplies: []};
  }

  const extracted = parseAiChatGeminiJson(trimmed);
  if (extracted != null) {
    const quickReplies = sanitizeQuickReplies(extracted.quickReplies, request);
    if (extracted.text.length > 0) {
      const textRaw = extracted.text;
      const text = normalizeDoubleEscapedLatex(textRaw);
      return {text, textRaw, quickReplies};
    }
    if (quickReplies.length > 0) {
      return {text: "", quickReplies};
    }
  }

  return {text: trimmed, textRaw: trimmed, quickReplies: []};
}

export function sanitizeQuickReplies(
  value: unknown,
  request: AiChatRequest,
): AiChatQuickReply[] {
  if (!Array.isArray(value)) return [];

  const answerShown = request.context.answerShown === true;
  const results: AiChatQuickReply[] = [];

  for (const item of value) {
    if (results.length >= maxQuickReplies) break;
    if (item == null || typeof item !== "object") continue;

    const record = item as Record<string, unknown>;
    const labelRaw = readOptionalString(record.label);
    if (labelRaw == null) continue;
    const label = truncate(labelRaw, maxLabelLength);

    const sendTextRaw = readOptionalString(record.sendText);
    const sendText = sendTextRaw != null
      ? truncate(sendTextRaw, maxSendTextLength)
      : undefined;
    const actionId = readOptionalString(record.actionId);

    const combined = `${label} ${sendText ?? ""}`;
    if (!answerShown && isAnswerSeekingQuickReply(combined, request.locale)) {
      continue;
    }

    results.push({
      label,
      ...(sendText != null && sendText.length > 0 ? {sendText} : {}),
      ...(actionId != null && actionId.length > 0 ? {actionId} : {}),
    });
  }

  return results;
}

function isAnswerSeekingQuickReply(text: string, locale: AiChatRequest["locale"]): boolean {
  if (locale === "en") {
    return enAnswerSeekingPattern.test(text);
  }
  return jaAnswerSeekingPattern.test(text);
}

function readOptionalString(value: unknown): string | undefined {
  if (typeof value !== "string") return undefined;
  const trimmed = value.trim();
  return trimmed.length > 0 ? trimmed : undefined;
}

function truncate(value: string, maxLength: number): string {
  if (value.length <= maxLength) return value;
  return value.slice(0, maxLength);
}
