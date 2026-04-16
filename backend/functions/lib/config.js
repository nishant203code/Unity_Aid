"use strict";
/**
 * Firebase Admin SDK initialization.
 * Single source of truth — import db/messaging from here.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.messaging = exports.db = void 0;
const app_1 = require("firebase-admin/app");
const firestore_1 = require("firebase-admin/firestore");
const messaging_1 = require("firebase-admin/messaging");
const app = (0, app_1.initializeApp)();
/** Firestore instance */
exports.db = (0, firestore_1.getFirestore)(app);
/** FCM messaging instance */
exports.messaging = (0, messaging_1.getMessaging)(app);
//# sourceMappingURL=config.js.map