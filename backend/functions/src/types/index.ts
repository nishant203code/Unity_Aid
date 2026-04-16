/**
 * Shared TypeScript interfaces for UnityAid Cloud Functions.
 */

// ─── Firestore Document Types ───

export interface UserDoc {
  id: string;
  name: string;
  email: string;
  phone: string;
  role: "user" | "ngo";
  fcmToken?: string;
  notificationsEnabled?: boolean;
  totalDonated?: number;
  [key: string]: unknown;
}

export interface PostDoc {
  title: string;
  description: string;
  location: string;
  fundGoal: number;
  raised: number;
  status: "active" | "completed";
  createdBy: string;
  creatorName: string;
  creatorEmail: string;
  mediaUrls: string[];
  createdAt: FirebaseFirestore.Timestamp;
  [key: string]: unknown;
}

export interface CaseDoc {
  title: string;
  description: string;
  status: "pending" | "verified" | "rejected";
  createdBy: string;
  verifiedBy?: string;
  verifiedAt?: FirebaseFirestore.Timestamp;
  createdAt: FirebaseFirestore.Timestamp;
  [key: string]: unknown;
}

// ─── Notification Types ───

export type NotificationType =
  | "new_post"
  | "case_verified"
  | "daily_cases";

export interface NotificationPayload {
  title: string;
  body: string;
  type: NotificationType;
  /** Deep-link route path (e.g. "/news", "/donate") */
  route?: string;
  /** Extra data for the deep-link (e.g. postId, caseId) */
  routeArgs?: Record<string, string>;
}

// ─── Cloud Function Response ───

export interface FunctionResponse {
  success: boolean;
  message: string;
  data?: Record<string, unknown>;
}
