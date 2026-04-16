"use strict";
/**
 * Scheduled Function: dailyCasesNotification
 * Runs every day at 9:00 AM IST (03:30 UTC).
 * Sends a summary notification with today's active case count.
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
exports.dailyCasesNotification = void 0;
const scheduler_1 = require("firebase-functions/v2/scheduler");
const logger = __importStar(require("firebase-functions/logger"));
const config_js_1 = require("../config.js");
const notifications_js_1 = require("../utils/notifications.js");
exports.dailyCasesNotification = (0, scheduler_1.onSchedule)({
    schedule: "30 3 * * *", // 03:30 UTC = 09:00 AM IST
    timeZone: "Asia/Kolkata",
    region: "asia-south1",
    maxInstances: 1,
    retryCount: 2,
}, async () => {
    logger.info("dailyCasesNotification: starting");
    try {
        // ── Count today's active posts ──
        const now = new Date();
        const startOfDay = new Date(now.getFullYear(), now.getMonth(), now.getDate());
        const postsSnap = await config_js_1.db
            .collection("posts")
            .where("status", "==", "active")
            .where("createdAt", ">=", startOfDay)
            .get();
        const todayCount = postsSnap.size;
        // ── Count total active posts ──
        const totalActiveSnap = await config_js_1.db
            .collection("posts")
            .where("status", "==", "active")
            .count()
            .get();
        const totalActive = totalActiveSnap.data().count;
        logger.info(`Daily stats: ${todayCount} new today, ${totalActive} total active`);
        // ── Build notification ──
        const payload = {
            title: "📊 Today's Cases",
            body: todayCount > 0
                ? `${todayCount} new case${todayCount > 1 ? "s" : ""} posted today. ` +
                    `${totalActive} active case${totalActive !== 1 ? "s" : ""} need support.`
                : `${totalActive} active case${totalActive !== 1 ? "s" : ""} ` +
                    "still need your support. Check them out!",
            type: "daily_cases",
            route: "/news",
            routeArgs: {
                filter: "recent",
                todayCount: todayCount.toString(),
            },
        };
        // ── Send via topic first ──
        const topicSent = await (0, notifications_js_1.sendToTopic)("daily_digest", payload);
        if (!topicSent) {
            // Fallback to direct tokens
            const tokens = await (0, notifications_js_1.getActiveTokens)();
            const sent = await (0, notifications_js_1.sendToTokens)(tokens, payload);
            logger.info(`Daily digest sent to ${sent} users via direct tokens`);
        }
        else {
            logger.info("Daily digest sent via topic 'daily_digest'");
        }
    }
    catch (err) {
        logger.error("dailyCasesNotification failed", err);
        throw err; // Rethrow so Cloud Functions can retry
    }
});
//# sourceMappingURL=dailyCasesAlert.js.map