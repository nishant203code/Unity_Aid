/**
 * Firebase Admin SDK initialization.
 * Single source of truth — import db/messaging from here.
 */

import {initializeApp} from "firebase-admin/app";
import {getFirestore} from "firebase-admin/firestore";
import {getMessaging} from "firebase-admin/messaging";

const app = initializeApp();

/** Firestore instance */
export const db = getFirestore(app);

/** FCM messaging instance */
export const messaging = getMessaging(app);
