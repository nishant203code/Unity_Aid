import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth_service.dart';

/// Called when a notification is tapped (background/terminated).
/// [route] is the deep-link path (e.g. "/news", "/donate").
/// [args] is extra data (e.g. {"postId": "abc123"}).
typedef NotificationTapCallback = void Function(
  String route,
  Map<String, dynamic> args,
);

/// Called when a foreground notification arrives.
/// Use this to show an in-app banner, snackbar, or dialog.
typedef ForegroundMessageCallback = void Function(RemoteMessage message);

// ═══════════════════════════════════════════════════════
//  NOTIFICATION SERVICE
// ═══════════════════════════════════════════════════════

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Callbacks set during initialization.
  static NotificationTapCallback? _onNotificationTap;
  static ForegroundMessageCallback? _onForegroundMessage;

  // ─────────────────────────────────────────────
  //  INITIALIZATION
  // ─────────────────────────────────────────────

  /// Initialize FCM. Call this once after Firebase.initializeApp() in main().
  ///
  /// [onNotificationTap] — called when user taps a notification
  ///   (from background or terminated state).
  /// [onForegroundMessage] — called when a message arrives while
  ///   the app is in the foreground. Use this to show an in-app alert.
  static Future<void> initialize({
    NotificationTapCallback? onNotificationTap,
    ForegroundMessageCallback? onForegroundMessage,
  }) async {
    _onNotificationTap = onNotificationTap;
    _onForegroundMessage = onForegroundMessage;

    // ── Request permission (iOS / Web) ──
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    debugPrint(
      'NotificationService: permission ${settings.authorizationStatus}',
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('NotificationService: notifications denied by user');
      return;
    }

    // ── Foreground messages ──
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // ── Background tap (app was in background) ──
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

    // ── Terminated tap (app was killed, opened via notification) ──
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage);
    }

    // ── Subscribe to default topics ──
    await subscribeToTopic('new_posts');
    await subscribeToTopic('daily_digest');

    debugPrint('NotificationService: initialized');
  }

  // ─────────────────────────────────────────────
  //  TOKEN MANAGEMENT
  // ─────────────────────────────────────────────

  /// Get the current FCM token.
  static Future<String?> getToken() async {
    try {
      return await _messaging.getToken();
    } catch (e) {
      debugPrint('NotificationService.getToken error: $e');
      return null;
    }
  }

  /// Save the FCM token to the current user's Firestore profile.
  /// Call this after login/signup.
  static Future<void> saveTokenToProfile() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    try {
      final token = await getToken();
      if (token == null || token.isEmpty) return;

      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': token,
        'notificationsEnabled': true,
      });

      debugPrint('NotificationService: token saved for ${user.uid}');
    } catch (e) {
      debugPrint('NotificationService.saveTokenToProfile error: $e');
    }

    // ── Listen for token refresh ──
    _messaging.onTokenRefresh.listen((newToken) async {
      final currentUser = AuthService.currentUser;
      if (currentUser == null) return;

      try {
        await _firestore.collection('users').doc(currentUser.uid).update({
          'fcmToken': newToken,
        });
        debugPrint('NotificationService: token refreshed');
      } catch (e) {
        debugPrint('NotificationService: token refresh save error: $e');
      }
    });
  }

  /// Clear the FCM token from the user's profile.
  /// Call this on logout.
  static Future<void> clearToken() async {
    final user = AuthService.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'fcmToken': '',
      });
      debugPrint('NotificationService: token cleared');
    } catch (e) {
      debugPrint('NotificationService.clearToken error: $e');
    }
  }

  // ─────────────────────────────────────────────
  //  NOTIFICATION PREFERENCES
  // ─────────────────────────────────────────────

  /// Enable or disable push notifications for the current user.
  static Future<void> setNotificationsEnabled(bool enabled) async {
    final user = AuthService.currentUser;
    if (user == null) return;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'notificationsEnabled': enabled,
      });

      if (enabled) {
        await saveTokenToProfile();
      } else {
        await clearToken();
      }
    } catch (e) {
      debugPrint('NotificationService.setNotificationsEnabled error: $e');
    }
  }

  /// Check if the current user has notifications enabled in Firestore.
  static Future<bool> isNotificationsEnabled() async {
    final user = AuthService.currentUser;
    if (user == null) return false;

    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      return (doc.data()?['notificationsEnabled'] as bool?) ?? true;
    } catch (e) {
      return true; // default enabled
    }
  }

  // ─────────────────────────────────────────────
  //  TOPIC MANAGEMENT
  // ─────────────────────────────────────────────

  /// Subscribe to an FCM topic.
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('NotificationService: subscribed to "$topic"');
    } catch (e) {
      debugPrint('NotificationService.subscribeToTopic error: $e');
    }
  }

  /// Unsubscribe from an FCM topic.
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('NotificationService: unsubscribed from "$topic"');
    } catch (e) {
      debugPrint('NotificationService.unsubscribeFromTopic error: $e');
    }
  }

  // ─────────────────────────────────────────────
  //  MESSAGE HANDLERS
  // ─────────────────────────────────────────────

  /// Handle foreground messages — forward to the app's callback.
  static void _handleForegroundMessage(RemoteMessage message) {
    debugPrint(
      'NotificationService: foreground message: '
      '${message.notification?.title}',
    );

    if (_onForegroundMessage != null) {
      _onForegroundMessage!(message);
    }
  }

  /// Handle notification taps (background + terminated).
  /// Extracts deep-link data and forwards to the app's callback.
  static void _handleNotificationTap(RemoteMessage message) {
    final data = message.data;

    final route = data['route'] as String? ?? '';
    Map<String, dynamic> args = {};

    try {
      final rawArgs = data['routeArgs'] as String? ?? '{}';
      args = Map<String, dynamic>.from(
        json.decode(rawArgs) as Map<String, dynamic>,
      );
    } catch (_) {
      // Malformed routeArgs — ignore
    }

    debugPrint(
      'NotificationService: notification tap → route="$route", args=$args',
    );

    if (_onNotificationTap != null && route.isNotEmpty) {
      _onNotificationTap!(route, args);
    }
  }

  // ─────────────────────────────────────────────
  //  DEEP LINK HELPERS
  // ─────────────────────────────────────────────

  /// Extract the notification type from a RemoteMessage.
  static String? getNotificationType(RemoteMessage message) {
    return message.data['type'] as String?;
  }

  /// Extract the deep-link route from a RemoteMessage.
  static String? getRoute(RemoteMessage message) {
    final route = message.data['route'] as String?;
    return (route != null && route.isNotEmpty) ? route : null;
  }

  /// Extract the deep-link arguments from a RemoteMessage.
  static Map<String, dynamic> getRouteArgs(RemoteMessage message) {
    try {
      final raw = message.data['routeArgs'] as String? ?? '{}';
      return Map<String, dynamic>.from(
        json.decode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return {};
    }
  }
}
