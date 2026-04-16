/**
 * Trigger: onNewPostCreated
 * Fires when a new document is created in the `posts` collection.
 * Sends a push notification to all users with notifications enabled.
 */

import {onDocumentCreated} from "firebase-functions/v2/firestore";
import * as logger from "firebase-functions/logger";
import {getActiveTokens, sendToTokens, sendToTopic}
  from "../utils/notifications.js";
import type {NotificationPayload, PostDoc} from "../types/index.js";

export const onNewPostCreated = onDocumentCreated(
  {
    document: "posts/{postId}",
    region: "asia-south1",
    maxInstances: 10,
  },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) {
      logger.warn("onNewPostCreated: no data in event");
      return;
    }

    const post = snapshot.data() as PostDoc;
    const postId = event.params.postId;

    logger.info(`New post created: "${post.title}" [${postId}]`, {
      createdBy: post.createdBy,
    });

    const payload: NotificationPayload = {
      title: "New Case Posted",
      body: `${post.creatorName || "Someone"} posted: "${post.title}"`,
      type: "new_post",
      route: "/news",
      routeArgs: {postId},
    };

    // Strategy: send to topic first (fast), then direct-send to
    // users who may not be subscribed to the topic.
    const topicSent = await sendToTopic("new_posts", payload);

    if (!topicSent) {
      // Fallback: send directly to all active tokens
      logger.info("Topic send failed, falling back to direct tokens");
      const tokens = await getActiveTokens();
      await sendToTokens(tokens, payload);
    }

    logger.info(`onNewPostCreated completed for post ${postId}`);
  }
);
