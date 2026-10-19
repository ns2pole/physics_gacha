import {Request} from "firebase-functions/v2/https";
import {Response} from "express";

export function sendJson(
  response: Response,
  status: number,
  body: unknown,
): void {
  response.status(status).json(body);
}

export function assertPost(request: Request): void {
  if (request.method !== "POST") {
    throw new HttpError(405, "method_not_allowed", "POSTのみ対応しています。");
  }
}

export function readBearerToken(request: Request): string | null {
  const header = request.header("authorization") ?? "";
  const match = header.match(/^Bearer\s+(.+)$/i);
  return match?.[1] ?? null;
}

export class HttpError extends Error {
  constructor(
    readonly status: number,
    readonly code: string,
    message: string,
  ) {
    super(message);
  }
}
