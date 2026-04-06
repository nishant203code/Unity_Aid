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

import {setGlobalOptions} from "firebase-functions";

// ─── Global Config ───
setGlobalOptions({maxInstances: 10});

// ─── Export all Cloud Functions ───
export {onNewPostCreated} from "./triggers/onPostCreated.js";
export {onCaseVerified} from "./triggers/onCaseVerified.js";
export {dailyCasesNotification} from "./triggers/dailyCasesAlert.js";
