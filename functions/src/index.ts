import * as admin from "firebase-admin";
import {defineSecret} from "firebase-functions/params";
import {onRequest, Request} from "firebase-functions/v2/https";
import {deleteFirebaseUserAccount} from "./accountDeletion";
import {resolveUsageIdentity} from "./auth";
import {generateAiChatReply} from "./geminiClient";
import {assertPost, HttpError, readBearerToken, sendJson} from "./http";
import {
  consumeUsage,
  RateLimitExceededError,
} from "./rateLimiter";
import {parseAiChatRequest} from "./requestValidator";
import {UsageSummary} from "./types";

admin.initializeApp();

const geminiApiKey = defineSecret("GEMINI_API_KEY");

export const aiChat = onRequest({
  cors: true,
  region: "asia-northeast1",
  secrets: [geminiApiKey],
}, async (request, response) => {
  try {
    assertPost(request);
    await assertAppCheckAuthorized(request);

    const chatRequest = parseAiChatRequest(request.body);
    const identity = await resolveUsageIdentity(request, chatRequest);
    const usage = await consumeUsage(admin.firestore(), identity);
    const reply = await generateAiChatReply(geminiApiKey.value(), chatRequest);

    sendJson(response, 200, {
      message: {
        role: "assistant",
        text: reply.text,
        ...(reply.textRaw != null ? {textRaw: reply.textRaw} : {}),
      },
      quickReplies: reply.quickReplies,
      usage: serializeUsageSummary(usage),
    });
  } catch (error) {
    if (error instanceof RateLimitExceededError) {
      sendJson(response, 429, {
        error: {
          code: "rate_limited",
          message: error.message,
          tier: error.limit.tier,
          limit: error.limit.limit,
        },
      });
      return;
    }

    if (error instanceof HttpError) {
      sendJson(response, error.status, {
        error: {
          code: error.code,
          message: error.message,
        },
      });
      return;
    }

    console.error(error);
    sendJson(response, 500, {
      error: {
        code: "internal",
        message: "AIチャットの処理中にエラーが発生しました。",
      },
    });
  }
});

export const deleteMyAccount = onRequest({
  cors: true,
  region: "asia-northeast1",
}, async (request, response) => {
  try {
    assertPost(request);
    await assertAppCheckAuthorized(request);

    const uid = await requireFirebaseUid(request);
    await deleteFirebaseUserAccount(admin.firestore(), uid);

    sendJson(response, 200, {ok: true});
  } catch (error) {
    if (error instanceof HttpError) {
      sendJson(response, error.status, {
        error: {
          code: error.code,
          message: error.message,
        },
      });
      return;
    }

    console.error(error);
    sendJson(response, 500, {
      error: {
        code: "internal",
        message: "Account deletion failed.",
      },
    });
  }
});

async function assertAppCheckAuthorized(request: Request): Promise<void> {
  const token = request.header("X-Firebase-AppCheck");
  if (token == null || token.length === 0) {
    throw new HttpError(401, "app_check_required", "App Check token is required.");
  }

  try {
    await admin.appCheck().verifyToken(token);
  } catch {
    throw new HttpError(401, "app_check_failed", "App Check verification failed.");
  }
}

async function requireFirebaseUid(request: Request): Promise<string> {
  const token = readBearerToken(request);
  if (token == null) {
    throw new HttpError(401, "auth_required", "Firebase authentication is required.");
  }

  try {
    const decoded = await admin.auth().verifyIdToken(token);
    return decoded.uid;
  } catch {
    throw new HttpError(401, "auth_failed", "Firebase authentication failed.");
  }
}

function serializeUsageSummary(usage: UsageSummary) {
  return {
    count: usage.count,
    limit: usage.limit,
    remaining: usage.remaining,
    totalRemaining: usage.remaining,
    tier: usage.tier,
    period: usage.period,
    periodKey: usage.periodKey,
    ...(usage.free != null ? {free: usage.free} : {}),
    ...(usage.passes != null
      ? {
        totalCapacity: usage.passes.reduce((sum, pass) => sum + pass.limit, 0),
        passes: usage.passes,
      }
      : {}),
  };
}
