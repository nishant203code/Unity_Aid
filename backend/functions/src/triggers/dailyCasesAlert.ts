/**
 * Scheduled Function: dailyCasesNotification
 * Runs every day at 9:00 AM IST (03:30 UTC).
 * Sends a summary notification with today's active case count.
 */

import {onSchedule} from "firebase-functions/v2/scheduler";
import * as logger from "firebase-functions/logger";
import {db} from "../config.js";
import {getActiveTokens, sendToTokens, sendToTopic}
  from "../utils/notifications.js";
import type {NotificationPayload} from "../types/index.js";

export const dailyCasesNotification = onSchedule(
  {
    schedule: "30 3 * * *", // 03:30 UTC = 09:00 AM IST
    timeZone: "Asia/Kolkata",
    region: "asia-south1",
    maxInstances: 1,
    retryCount: 2,
  },
  async () => {
    logger.info("dailyCasesNotification: starting");

    try {
      // ── Count today's active posts ──
      const now = new Date();
      const startOfDay = new Date(
        now.getFullYear(),
        now.getMonth(),
        now.getDate()
      );

      const postsSnap = await db
        .collection("posts")
        .where("status", "==", "active")
        .where("createdAt", ">=", startOfDay)
        .get();

      const todayCount = postsSnap.size;

      // ── Count total active posts ──
      const totalActiveSnap = await db
        .collection("posts")
        .where("status", "==", "active")
        .count()
        .get();

      const totalActive = totalActiveSnap.data().count;

      logger.info(
        `Daily stats: ${todayCount} new today, ${totalActive} total active`
      );

      // ── Build notification ──
      const payload: NotificationPayload = {
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
      const topicSent = await sendToTopic("daily_digest", payload);

      if (!topicSent) {
        // Fallback to direct tokens
        const tokens = await getActiveTokens();
        const sent = await sendToTokens(tokens, payload);
        logger.info(`Daily digest sent to ${sent} users via direct tokens`);
      } else {
        logger.info("Daily digest sent via topic 'daily_digest'");
      }
    } catch (err) {
      logger.error("dailyCasesNotification failed", err);
      throw err; // Rethrow so Cloud Functions can retry
    }
  }
);
