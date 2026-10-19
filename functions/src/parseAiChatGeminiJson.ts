import {
  decodeJsonStringLiteral,
  skipWhitespace,
} from "./latexSafeJsonString";

export interface ExtractedQuickReply {
  label: string;
  sendText?: string;
  actionId?: string;
}

export interface ExtractedGeminiJson {
  text: string;
  quickReplies: ExtractedQuickReply[];
}

export function parseAiChatGeminiJson(raw: string): ExtractedGeminiJson | null {
  const trimmed = raw.trim();
  if (trimmed.length === 0) return null;

  let index = skipWhitespace(trimmed, 0);
  if (trimmed[index] !== "{") return null;
  index++;

  let text = "";
  const quickReplies: ExtractedQuickReply[] = [];

  while (index < trimmed.length) {
    index = skipWhitespace(trimmed, index);
    if (trimmed[index] === "}") {
      break;
    }
    if (trimmed[index] === ",") {
      index++;
      continue;
    }

    const key = decodeJsonStringLiteral(trimmed, index, "standard");
    if (key == null) return null;
    index = key.endIndex;

    index = skipWhitespace(trimmed, index);
    if (trimmed[index] !== ":") return null;
    index++;

    index = skipWhitespace(trimmed, index);

    if (key.value === "text") {
      const decoded = decodeJsonStringLiteral(trimmed, index, "latex");
      if (decoded == null) return null;
      text = decoded.value.trim();
      index = decoded.endIndex;
      continue;
    }

    if (key.value === "quickReplies") {
      const parsed = parseQuickRepliesArray(trimmed, index);
      if (parsed == null) return null;
      quickReplies.push(...parsed.replies);
      index = parsed.endIndex;
      continue;
    }

    const skipped = skipJsonValue(trimmed, index);
    if (skipped == null) return null;
    index = skipped;
  }

  if (text.length === 0 && quickReplies.length === 0) return null;
  return {text, quickReplies};
}

function parseQuickRepliesArray(
  source: string,
  startIndex: number,
): {replies: ExtractedQuickReply[]; endIndex: number} | null {
  if (source[startIndex] !== "[") return null;

  let index = startIndex + 1;
  const replies: ExtractedQuickReply[] = [];

  while (index < source.length) {
    index = skipWhitespace(source, index);
    if (source[index] === "]") {
      return {replies, endIndex: index + 1};
    }
    if (source[index] === ",") {
      index++;
      continue;
    }

    const item = parseQuickReplyObject(source, index);
    if (item == null) return null;
    replies.push(item.reply);
    index = item.endIndex;
  }

  return null;
}

function parseQuickReplyObject(
  source: string,
  startIndex: number,
): {reply: ExtractedQuickReply; endIndex: number} | null {
  if (source[startIndex] !== "{") return null;

  let index = startIndex + 1;
  let label: string | undefined;
  let sendText: string | undefined;
  let actionId: string | undefined;

  while (index < source.length) {
    index = skipWhitespace(source, index);
    if (source[index] === "}") {
      if (label == null || label.length === 0) return null;
      return {
        reply: {
          label,
          ...(sendText != null && sendText.length > 0 ? {sendText} : {}),
          ...(actionId != null && actionId.length > 0 ? {actionId} : {}),
        },
        endIndex: index + 1,
      };
    }
    if (source[index] === ",") {
      index++;
      continue;
    }

    const key = decodeJsonStringLiteral(source, index, "standard");
    if (key == null) return null;
    index = key.endIndex;

    index = skipWhitespace(source, index);
    if (source[index] !== ":") return null;
    index++;

    index = skipWhitespace(source, index);

    if (key.value === "label") {
      const decoded = decodeJsonStringLiteral(source, index, "latex");
      if (decoded == null) return null;
      label = decoded.value.trim();
      index = decoded.endIndex;
      continue;
    }

    if (key.value === "sendText") {
      const decoded = decodeJsonStringLiteral(source, index, "latex");
      if (decoded == null) return null;
      sendText = decoded.value.trim();
      index = decoded.endIndex;
      continue;
    }

    if (key.value === "actionId") {
      const decoded = decodeJsonStringLiteral(source, index, "standard");
      if (decoded == null) return null;
      actionId = decoded.value.trim();
      index = decoded.endIndex;
      continue;
    }

    const skipped = skipJsonValue(source, index);
    if (skipped == null) return null;
    index = skipped;
  }

  return null;
}

function skipJsonValue(source: string, startIndex: number): number | null {
  const index = skipWhitespace(source, startIndex);
  if (index >= source.length) return null;

  const ch = source[index];
  if (ch === "\"") {
    const decoded = decodeJsonStringLiteral(source, index, "standard");
    return decoded?.endIndex ?? null;
  }
  if (ch === "{") return skipObject(source, index);
  if (ch === "[") return skipArray(source, index);
  if (ch === "t" && source.startsWith("true", index)) return index + 4;
  if (ch === "f" && source.startsWith("false", index)) return index + 5;
  if (ch === "n" && source.startsWith("null", index)) return index + 4;
  if (ch === "-" || (ch >= "0" && ch <= "9")) return skipNumber(source, index);

  return null;
}

function skipObject(source: string, startIndex: number): number | null {
  if (source[startIndex] !== "{") return null;

  let index = startIndex + 1;
  while (index < source.length) {
    index = skipWhitespace(source, index);
    if (source[index] === "}") return index + 1;
    if (source[index] === ",") {
      index++;
      continue;
    }

    const key = decodeJsonStringLiteral(source, index, "standard");
    if (key == null) return null;
    index = key.endIndex;

    index = skipWhitespace(source, index);
    if (source[index] !== ":") return null;
    index++;

    index = skipWhitespace(source, index);
    const skipped = skipJsonValue(source, index);
    if (skipped == null) return null;
    index = skipped;
  }

  return null;
}

function skipArray(source: string, startIndex: number): number | null {
  if (source[startIndex] !== "[") return null;

  let index = startIndex + 1;
  while (index < source.length) {
    index = skipWhitespace(source, index);
    if (source[index] === "]") return index + 1;
    if (source[index] === ",") {
      index++;
      continue;
    }

    const skipped = skipJsonValue(source, index);
    if (skipped == null) return null;
    index = skipped;
  }

  return null;
}

function skipNumber(source: string, startIndex: number): number | null {
  let index = startIndex;
  if (source[index] === "-") index++;

  while (index < source.length && source[index] >= "0" && source[index] <= "9") {
    index++;
  }
  if (source[index] === ".") {
    index++;
    while (index < source.length && source[index] >= "0" && source[index] <= "9") {
      index++;
    }
  }
  if (source[index] === "e" || source[index] === "E") {
    index++;
    if (source[index] === "+" || source[index] === "-") index++;
    while (index < source.length && source[index] >= "0" && source[index] <= "9") {
      index++;
    }
  }

  return index > startIndex ? index : null;
}
