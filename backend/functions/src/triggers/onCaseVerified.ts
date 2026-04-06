/**
 * Trigger: onCaseVerified
 * Fires when a document in `ngo_verifications` is updated
 * and the status changes to "verified" or "rejected".
 * Notifies the NGO user who submitted the verification.
 */

import {onDocumentUpdated} from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import {db} from "../config.js";
import {sendToToken} from "../utils/notifications.js";
import type {NotificationPayload} from "../types/index.js";

export const onCaseVerified = onDocumentUpdated(
  {
    document: "ngo_verifications/{verificationId}",
    region: "asia-south1",
    maxInstances: 5,
  },
  async (event) => {
    const before = event.data?.before?.data();
    const after = event.data?.after?.data();

    if (!before || !after) {
      logger.warn("onCaseVerified: missing before/after data");
      return;
    }

    // Only fire when status actually changed
    if (before.status === after.status) {
      return;
    }

    const newStatus = after.status as string;
    const uid = after.uid as string;
    const ngoName = (after.ngoName as string) || "Your NGO";
    const verificationId = event.params.verificationId;

    // We only notify on "verified" or "rejected"
    if (newStatus !== "verified" && newStatus !== "rejected") {
      return;
    }

    logger.info(
      `Verification ${verificationId} status: ${before.status} → ${newStatus}`,
      {uid}
    );

    // ── Get the user's FCM token ──
    const userDoc = await db.collection("users").doc(uid).get();
    if (!userDoc.exists) {
      logger.warn(`User ${uid} not found, skipping notification`);
      return;
    }

    const userData = userDoc.data();
    const fcmToken = userData?.fcmToken as string | undefined;
    const notificationsEnabled =
      userData?.notificationsEnabled !== false; // default true

    if (!fcmToken || !notificationsEnabled) {
      logger.info(`User ${uid}: no token or notifications disabled`);
      return;
    }

    // ── Build payload ──
    const isVerified = newStatus === "verified";
    const payload: NotificationPayload = {
      title: isVerified
        ? "🎉 NGO Verified!"
        : "❌ Verification Update",
      body: isVerified
        ? `${ngoName} has been successfully verified. Welcome aboard!`
        : `${ngoName} verification was not approved. Please review and resubmit.`,
      type: "case_verified",
      route: "/dashboard",
      routeArgs: {verificationId, status: newStatus},
    };

    const sent = await sendToToken(fcmToken, payload);
    logger.info(
      `onCaseVerified notification ${sent ? "sent" : "failed"} for ${uid}`
    );
  }
);
