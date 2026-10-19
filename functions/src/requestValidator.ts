import {AiChatContext, AiChatLocale, AiChatMessage, AiChatRequest} from "./types";
import {HttpError} from "./http";

const supportedLocales: ReadonlySet<string> = new Set(["ja", "en"]);

export function parseAiChatRequest(body: unknown): AiChatRequest {
  if (!isRecord(body)) {
    throw new HttpError(400, "invalid_request", "リクエスト形式が不正です。");
  }

  const context = body.context;
  const userMessage = body.userMessage;
  const history = body.history;

  if (!isRecord(context) || !isNonEmptyString(context.questionText)) {
    throw new HttpError(400, "invalid_context", "問題情報が不足しています。");
  }
  if (!isRecord(userMessage) || !isNonEmptyString(userMessage.text)) {
    throw new HttpError(400, "invalid_message", "メッセージが空です。");
  }
  if (!Array.isArray(history)) {
    throw new HttpError(400, "invalid_history", "会話履歴が不正です。");
  }

  return {
    context: parseContext(context),
    history: history.filter(isRecord).map((message): AiChatMessage => ({
      role: message.role === "assistant" ? "assistant" : "user",
      text: readString(message.text) ?? "",
      choiceId: readString(message.choiceId),
    })).filter((message) => message.text.trim().length > 0),
    userMessage: {
      role: "user",
      text: userMessage.text,
      choiceId: readString(userMessage.choiceId),
    },
    clientInstallationId: sanitizeIdentifier(
      readString(body.clientInstallationId) ?? "",
    ),
    locale: parseLocale(readString(body.locale)),
  };
}

function parseContext(context: Record<string, unknown>): AiChatContext {
  return {
    title: readString(context.title) ?? "",
    questionText: context.questionText as string,
    category: readString(context.category),
    level: readString(context.level),
    referenceAnswer: readString(context.referenceAnswer),
    referenceSolution: readString(context.referenceSolution),
    hintShown: Boolean(context.hintShown),
    answerShown: Boolean(context.answerShown),
    attachmentsEnabled: Boolean(context.attachmentsEnabled),
  };
}

function isRecord(value: unknown): value is Record<string, unknown> {
  return typeof value === "object" && value !== null;
}

function isNonEmptyString(value: unknown): value is string {
  return typeof value === "string" && value.trim().length > 0;
}

function readString(value: unknown): string | null {
  return typeof value === "string" ? value : null;
}

function sanitizeIdentifier(value: string): string {
  return value.replace(/[^a-zA-Z0-9_-]/g, "").slice(0, 80);
}

function parseLocale(value: string | null): AiChatLocale {
  if (value && supportedLocales.has(value)) return value as AiChatLocale;
  return "ja";
}
