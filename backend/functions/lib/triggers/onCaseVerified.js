"use strict";
/**
 * Trigger: onCaseVerified
 * Fires when a document in `ngo_verifications` is updated
 * and the status changes to "verified" or "rejected".
 * Notifies the NGO user who submitted the verification.
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
exports.onCaseVerified = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const logger = __importStar(require("firebase-functions/logger"));
const config_js_1 = require("../config.js");
const notifications_js_1 = require("../utils/notifications.js");
exports.onCaseVerified = (0, firestore_1.onDocumentUpdated)({
    document: "ngo_verifications/{verificationId}",
    region: "asia-south1",
    maxInstances: 5,
}, async (event) => {
    var _a, _b, _c, _d;
    const before = (_b = (_a = event.data) === null || _a === void 0 ? void 0 : _a.before) === null || _b === void 0 ? void 0 : _b.data();
    const after = (_d = (_c = event.data) === null || _c === void 0 ? void 0 : _c.after) === null || _d === void 0 ? void 0 : _d.data();
    if (!before || !after) {
        logger.warn("onCaseVerified: missing before/after data");
        return;
    }
    // Only fire when status actually changed
    if (before.status === after.status) {
        return;
    }
    const newStatus = after.status;
    const uid = after.uid;
    const ngoName = after.ngoName || "Your NGO";
    const verificationId = event.params.verificationId;
    // We only notify on "verified" or "rejected"
    if (newStatus !== "verified" && newStatus !== "rejected") {
        return;
    }
    logger.info(`Verification ${verificationId} status: ${before.status} → ${newStatus}`, { uid });
    // ── Get the user's FCM token ──
    const userDoc = await config_js_1.db.collection("users").doc(uid).get();
    if (!userDoc.exists) {
        logger.warn(`User ${uid} not found, skipping notification`);
        return;
    }
    const userData = userDoc.data();
    const fcmToken = userData === null || userData === void 0 ? void 0 : userData.fcmToken;
    const notificationsEnabled = (userData === null || userData === void 0 ? void 0 : userData.notificationsEnabled) !== false; // default true
    if (!fcmToken || !notificationsEnabled) {
        logger.info(`User ${uid}: no token or notifications disabled`);
        return;
    }
    // ── Build payload ──
    const isVerified = newStatus === "verified";
    const payload = {
        title: isVerified
            ? "🎉 NGO Verified!"
            : "❌ Verification Update",
        body: isVerified
            ? `${ngoName} has been successfully verified. Welcome aboard!`
            : `${ngoName} verification was not approved. Please review and resubmit.`,
        type: "case_verified",
        route: "/dashboard",
        routeArgs: { verificationId, status: newStatus },
    };
    const sent = await (0, notifications_js_1.sendToToken)(fcmToken, payload);
    logger.info(`onCaseVerified notification ${sent ? "sent" : "failed"} for ${uid}`);
});
//# sourceMappingURL=onCaseVerified.js.map