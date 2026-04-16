/**
 * Notification utility — send FCM messages with retry + dead token cleanup.
 */

import * as logger from "firebase-functions/logger";
import {messaging, db} from "../config.js";
import type {NotificationPayload} from "../types/index.js";

// ─── Constants ───

const MAX_RETRIES = 3;
const BASE_DELAY_MS = 1000; // 1 second, doubles each retry

// FCM error codes that indicate the token is permanently invalid
const INVALID_TOKEN_CODES = [
  "messaging/invalid-registration-token",
  "messaging/registration-token-not-registered",
  "messaging/invalid-argument",
];

// ─────────────────────────────────────────────
//  SEND TO SINGLE TOKEN
// ─────────────────────────────────────────────

/**
 * Send a push notification to a single FCM token with retry logic.
 *
 * @returns true if sent successfully, false otherwise.
 */
export async function sendToToken(
  token: string,
  payload: NotificationPayload,
  attempt = 1
): Promise<boolean> {
  try {
    await messaging.send({
      token,
      notification: {
        title: payload.title,
        body: payload.body,
      },
      data: {
        type: payload.type,
        route: payload.route ?? "",
        routeArgs: payload.routeArgs
          ? JSON.stringify(payload.routeArgs)
          : "{}",
        // Timestamp for client-side dedup
        sentAt: Date.now().toString(),
      },
      android: {
        priority: "high",
        notification: {
          channelId: "unityaid_default",
          priority: "high",
          defaultSound: true,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      },
      apns: {
        payload: {
          aps: {
            sound: "default",
            badge: 1,
          },
        },
      },
    });

    logger.info(`FCM sent to token ...${token.slice(-6)}`, {
      type: payload.type,
    });
    return true;
  } catch (err: unknown) {
    const error = err as {code?: string; message?: string};
    const code = error.code ?? "";

    // ── INVALID TOKEN → remove from Firestore ──
    if (INVALID_TOKEN_CODES.includes(code)) {
      logger.warn(`Invalid FCM token ...${token.slice(-6)}, cleaning up`, {
        code,
      });
      await removeStaleToken(token);
      return false;
    }

    // ── RETRY with exponential backoff ──
    if (attempt < MAX_RETRIES) {
      const delay = BASE_DELAY_MS * Math.pow(2, attempt - 1);
      logger.warn(
        `FCM retry ${attempt}/${MAX_RETRIES} in ${delay}ms for token ...${token.slice(-6)}`,
        {code}
      );
      await sleep(delay);
      return sendToToken(token, payload, attempt + 1);
    }

    logger.error(`FCM failed after ${MAX_RETRIES} retries`, {
      code,
      message: error.message,
    });
    return false;
  }
}

// ─────────────────────────────────────────────
//  SEND TO MULTIPLE TOKENS
// ─────────────────────────────────────────────

/**
 * Send a notification to a list of tokens in parallel.
 * Returns the count of successful deliveries.
 */
export async function sendToTokens(
  tokens: string[],
  payload: NotificationPayload
): Promise<number> {
  if (tokens.length === 0) return 0;

  // Deduplicate tokens
  const unique = [...new Set(tokens)];

  const results = await Promise.allSettled(
    unique.map((token) => sendToToken(token, payload))
  );

  const successCount = results.filter(
    (r) => r.status === "fulfilled" && r.value === true
  ).length;

  logger.info(
    `FCM batch: ${successCount}/${unique.length} delivered`,
    {type: payload.type}
  );

  return successCount;
}

// ─────────────────────────────────────────────
//  SEND TO TOPIC
// ─────────────────────────────────────────────

/**
 * Send a notification to an FCM topic (e.g. "all_users", "ngo_users").
 */
export async function sendToTopic(
  topic: string,
  payload: NotificationPayload
): Promise<boolean> {
  try {
    await messaging.send({
      topic,
      notification: {
        title: payload.title,
        body: payload.body,
      },
      data: {
        type: payload.type,
        route: payload.route ?? "",
        routeArgs: payload.routeArgs
          ? JSON.stringify(payload.routeArgs)
          : "{}",
        sentAt: Date.now().toString(),
      },
      android: {
        priority: "high",
        notification: {
          channelId: "unityaid_default",
          priority: "high",
          defaultSound: true,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
      },
    });

    logger.info(`FCM sent to topic "${topic}"`, {type: payload.type});
    return true;
  } catch (err: unknown) {
    const error = err as {message?: string};
    logger.error(`FCM topic send failed for "${topic}"`, {
      message: error.message,
    });
    return false;
  }
}

// ─────────────────────────────────────────────
//  HELPERS
// ─────────────────────────────────────────────

/**
 * Get all FCM tokens for users who have notifications enabled.
 * Optionally filter by role.
 */
export async function getActiveTokens(
  role?: "user" | "ngo"
): Promise<string[]> {
  let query: FirebaseFirestore.Query = db
    .collection("users")
    .where("notificationsEnabled", "==", true)
    .where("fcmToken", "!=", "");

  if (role) {
    query = query.where("role", "==", role);
  }

  const snapshot = await query.get();
  const tokens: string[] = [];

  for (const doc of snapshot.docs) {
    const token = doc.data().fcmToken;
    if (typeof token === "string" && token.length > 0) {
      tokens.push(token);
    }
  }

  return tokens;
}

/**
 * Remove a stale FCM token from any user document that references it.
 */
async function removeStaleToken(token: string): Promise<void> {
  try {
    const snapshot = await db
      .collection("users")
      .where("fcmToken", "==", token)
      .get();

    const batch = db.batch();
    for (const doc of snapshot.docs) {
      batch.update(doc.ref, {fcmToken: ""});
    }
    await batch.commit();

    logger.info(`Cleaned stale token from ${snapshot.size} user(s)`);
  } catch (err) {
    logger.error("Failed to clean stale token", err);
  }
}

/** Promise-based sleep for retry delays. */
function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
