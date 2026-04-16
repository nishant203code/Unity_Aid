"use strict";
/**
 * Trigger: onNewPostCreated
 * Fires when a new document is created in the `posts` collection.
 * Sends a push notification to all users with notifications enabled.
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
exports.onNewPostCreated = void 0;
const firestore_1 = require("firebase-functions/v2/firestore");
const logger = __importStar(require("firebase-functions/logger"));
const notifications_js_1 = require("../utils/notifications.js");
exports.onNewPostCreated = (0, firestore_1.onDocumentCreated)({
    document: "posts/{postId}",
    region: "asia-south1",
    maxInstances: 10,
}, async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
        logger.warn("onNewPostCreated: no data in event");
        return;
    }
    const post = snapshot.data();
    const postId = event.params.postId;
    logger.info(`New post created: "${post.title}" [${postId}]`, {
        createdBy: post.createdBy,
    });
    const payload = {
        title: "New Case Posted",
        body: `${post.creatorName || "Someone"} posted: "${post.title}"`,
        type: "new_post",
        route: "/news",
        routeArgs: { postId },
    };
    // Strategy: send to topic first (fast), then direct-send to
    // users who may not be subscribed to the topic.
    const topicSent = await (0, notifications_js_1.sendToTopic)("new_posts", payload);
    if (!topicSent) {
        // Fallback: send directly to all active tokens
        logger.info("Topic send failed, falling back to direct tokens");
        const tokens = await (0, notifications_js_1.getActiveTokens)();
        await (0, notifications_js_1.sendToTokens)(tokens, payload);
    }
    logger.info(`onNewPostCreated completed for post ${postId}`);
});
//# sourceMappingURL=onPostCreated.js.map