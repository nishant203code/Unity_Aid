"use strict";
/**
 * Notification utility — send FCM messages with retry + dead token cleanup.
 */
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
Object.defineProperty(exports, "__esModule", { value: true });
exports.sendToToken = sendToToken;
exports.sendToTokens = sendToTokens;
exports.sendToTopic = sendToTopic;
exports.getActiveTokens = getActiveTokens;
const logger = __importStar(require("firebase-functions/logger"));
const config_js_1 = require("../config.js");
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
async function sendToToken(token, payload, attempt = 1) {
    var _a, _b;
    try {
        await config_js_1.messaging.send({
            token,
            notification: {
                title: payload.title,
                body: payload.body,
            },
            data: {
                type: payload.type,
                route: (_a = payload.route) !== null && _a !== void 0 ? _a : "",
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
    }
    catch (err) {
        const error = err;
        const code = (_b = error.code) !== null && _b !== void 0 ? _b : "";
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
            logger.warn(`FCM retry ${attempt}/${MAX_RETRIES} in ${delay}ms for token ...${token.slice(-6)}`, { code });
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
async function sendToTokens(tokens, payload) {
    if (tokens.length === 0)
        return 0;
    // Deduplicate tokens
    const unique = [...new Set(tokens)];
    const results = await Promise.allSettled(unique.map((token) => sendToToken(token, payload)));
    const successCount = results.filter((r) => r.status === "fulfilled" && r.value === true).length;
    logger.info(`FCM batch: ${successCount}/${unique.length} delivered`, { type: payload.type });
    return successCount;
}
// ─────────────────────────────────────────────
//  SEND TO TOPIC
// ─────────────────────────────────────────────
/**
 * Send a notification to an FCM topic (e.g. "all_users", "ngo_users").
 */
async function sendToTopic(topic, payload) {
    var _a;
    try {
        await config_js_1.messaging.send({
            topic,
            notification: {
                title: payload.title,
                body: payload.body,
            },
            data: {
                type: payload.type,
                route: (_a = payload.route) !== null && _a !== void 0 ? _a : "",
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
        logger.info(`FCM sent to topic "${topic}"`, { type: payload.type });
        return true;
    }
    catch (err) {
        const error = err;
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
async function getActiveTokens(role) {
    let query = config_js_1.db
        .collection("users")
        .where("notificationsEnabled", "==", true)
        .where("fcmToken", "!=", "");
    if (role) {
        query = query.where("role", "==", role);
    }
    const snapshot = await query.get();
    const tokens = [];
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
async function removeStaleToken(token) {
    try {
        const snapshot = await config_js_1.db
            .collection("users")
            .where("fcmToken", "==", token)
            .get();
        const batch = config_js_1.db.batch();
        for (const doc of snapshot.docs) {
            batch.update(doc.ref, { fcmToken: "" });
        }
        await batch.commit();
        logger.info(`Cleaned stale token from ${snapshot.size} user(s)`);
    }
    catch (err) {
        logger.error("Failed to clean stale token", err);
    }
}
/** Promise-based sleep for retry delays. */
function sleep(ms) {
    return new Promise((resolve) => setTimeout(resolve, ms));
}
//# sourceMappingURL=notifications.js.map