import {aiChatResponseSchema} from "./aiChatResponseSchema";
import {
  buildGeminiContents,
  buildSystemInstruction,
  GeminiContent,
  isBriefGuidanceRequest,
  retryBrokenLatexMessage,
  retryTooLongMessage,
} from "./prompt";
import {
  AiChatStructuredReply,
  parseAiChatStructuredResponse,
} from "./quickReplies";
import {AiChatRequest} from "./types";
import {HttpError} from "./http";

const model = "gemini-2.5-flash";
const endpoint =
  `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent`;
const defaultMaxOutputTokens = 1024;
const briefGuidanceMaxOutputTokens = 512;
const thinkingBudget = 256;

export async function generateAiChatReply(
  apiKey: string,
  request: AiChatRequest,
): Promise<AiChatStructuredReply> {
  const systemInstruction = buildSystemInstruction(request);
  const contents = buildGeminiContents(request);
  const maxOutputTokens = resolveMaxOutputTokens(request);
  let result = await requestGeminiStructured(
    apiKey,
    systemInstruction,
    contents,
    maxOutputTokens,
    request,
  );

  if (result.finishReason === "MAX_TOKENS") {
    console.warn("[AiChat] Gemini response hit MAX_TOKENS; retrying shorter.");
    result = await requestGeminiStructured(
      apiKey,
      systemInstruction,
      [
        ...contents,
        {
          role: "model",
          parts: [{text: result.rawText}],
        },
        {
          role: "user",
          parts: [{text: retryTooLongMessage(request.locale)}],
        },
      ],
      briefGuidanceMaxOutputTokens,
      request,
    );
  }

  if (!hasSuspiciousLatex(result.reply.text)) {
    return result.reply;
  }

  console.warn("[AiChat] Suspicious LaTeX detected; retrying render-safe response.");
  return (await requestGeminiStructured(
    apiKey,
    systemInstruction,
    [
      ...contents,
      {
        role: "model",
        parts: [{text: result.rawText}],
      },
      {
        role: "user",
        parts: [{text: retryBrokenLatexMessage(request.locale)}],
      },
    ],
    maxOutputTokens,
    request,
  )).reply;
}

async function requestGeminiStructured(
  apiKey: string,
  systemInstruction: string,
  contents: GeminiContent[],
  maxOutputTokens: number,
  request: AiChatRequest,
): Promise<GeminiStructuredResult> {
  const response = await fetch(`${endpoint}?key=${encodeURIComponent(apiKey)}`, {
    method: "POST",
    headers: {"Content-Type": "application/json"},
    body: JSON.stringify({
      system_instruction: {
        parts: [{text: systemInstruction}],
      },
      contents,
      generationConfig: {
        temperature: 0.25,
        maxOutputTokens,
        responseMimeType: "application/json",
        responseSchema: aiChatResponseSchema,
        thinkingConfig: {
          thinkingBudget,
        },
      },
    }),
  });

  const body = await response.json().catch(() => null) as GeminiResponse | null;
  if (!response.ok) {
    const message = body?.error?.message ?? "Gemini APIの呼び出しに失敗しました。";
    console.error(
      "[AiChat] Gemini API error:",
      {status: response.status, message},
    );
    throw new HttpError(response.status, "gemini_error", message);
  }

  const candidate = body?.candidates?.[0];
  const finishReason = candidate?.finishReason;
  if (finishReason != null && finishReason !== "STOP") {
    console.warn("[AiChat] Gemini finishReason:", finishReason);
  }

  const rawText = candidate?.content?.parts
    ?.map((part) => part.text ?? "")
    .join("")
    .trim();
  if (rawText == null || rawText.length === 0) {
    console.warn("[AiChat] Gemini returned empty text.", {finishReason});
    throw new HttpError(502, "empty_gemini_response", "AIから空の応答が返されました。");
  }

  const reply = parseAiChatStructuredResponse(rawText, request);
  if (reply.text.length === 0) {
    console.warn("[AiChat] Parsed reply text is empty.", {finishReason});
    throw new HttpError(502, "empty_gemini_response", "AIから空の応答が返されました。");
  }

  return {
    rawText,
    reply,
    finishReason,
  };
}

function resolveMaxOutputTokens(request: AiChatRequest): number {
  return isBriefGuidanceRequest(request.userMessage.text) ?
    briefGuidanceMaxOutputTokens :
    defaultMaxOutputTokens;
}

function hasSuspiciousLatex(text: string): boolean {
  const dollarCounts = countMathDelimiters(text);
  if (dollarCounts.single % 2 !== 0 || dollarCounts.double % 2 !== 0) {
    return true;
  }

  let braceDepth = 0;
  for (const char of text) {
    if (char === "{") braceDepth++;
    if (char === "}") braceDepth--;
    if (braceDepth < 0) return true;
  }
  if (braceDepth !== 0) return true;

  const leftCount = text.match(/\\left\b/g)?.length ?? 0;
  const rightCount = text.match(/\\right\b/g)?.length ?? 0;
  return leftCount !== rightCount;
}

function countMathDelimiters(text: string): {single: number; double: number} {
  let single = 0;
  let double = 0;

  for (let i = 0; i < text.length; i++) {
    if (text[i] !== "$" || isEscaped(text, i)) continue;

    if (text[i + 1] === "$") {
      double++;
      i++;
    } else {
      single++;
    }
  }

  return {single, double};
}

function isEscaped(text: string, index: number): boolean {
  let slashCount = 0;
  for (let i = index - 1; i >= 0 && text[i] === "\\"; i--) {
    slashCount++;
  }
  return slashCount % 2 === 1;
}

interface GeminiResponse {
  candidates?: Array<{
    finishReason?: string;
    content?: {
      parts?: Array<{
        text?: string;
      }>;
    };
  }>;
  error?: {
    message?: string;
  };
}

interface GeminiStructuredResult {
  rawText: string;
  reply: AiChatStructuredReply;
  finishReason?: string;
}
