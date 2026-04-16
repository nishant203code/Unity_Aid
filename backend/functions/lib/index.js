"use strict";
/**
 * UnityAid Cloud Functions — Entry Point
 *
 * All functions are defined in their own modules under /triggers
 * and re-exported here. Firebase CLI discovers exports from this file.
 *
 * Structure:
 *   src/
 *   ├── index.ts              ← you are here
 *   ├── config.ts             ← Firebase Admin init
 *   ├── types/index.ts        ← shared interfaces
 *   ├── utils/notifications.ts← FCM send + retry logic
 *   └── triggers/
 *       ├── onPostCreated.ts  ← Firestore onCreate for posts
 *       ├── onCaseVerified.ts ← Firestore onUpdate for ngo_verifications
 *       └── dailyCasesAlert.ts← Scheduled daily digest
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.dailyCasesNotification = exports.onCaseVerified = exports.onNewPostCreated = void 0;
const firebase_functions_1 = require("firebase-functions");
// ─── Global Config ───
(0, firebase_functions_1.setGlobalOptions)({ maxInstances: 10 });
// ─── Export all Cloud Functions ───
var onPostCreated_js_1 = require("./triggers/onPostCreated.js");
Object.defineProperty(exports, "onNewPostCreated", { enumerable: true, get: function () { return onPostCreated_js_1.onNewPostCreated; } });
var onCaseVerified_js_1 = require("./triggers/onCaseVerified.js");
Object.defineProperty(exports, "onCaseVerified", { enumerable: true, get: function () { return onCaseVerified_js_1.onCaseVerified; } });
var dailyCasesAlert_js_1 = require("./triggers/dailyCasesAlert.js");
Object.defineProperty(exports, "dailyCasesNotification", { enumerable: true, get: function () { return dailyCasesAlert_js_1.dailyCasesNotification; } });
//# sourceMappingURL=index.js.map