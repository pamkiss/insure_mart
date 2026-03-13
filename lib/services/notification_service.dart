import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Initialize FCM: request permissions, get token, and set up listeners.
  Future<void> initialize(String? userId) async {
    // Request permission (iOS & web)
    final settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      return;
    }

    // Get FCM token and save to Firestore
    final token = await _messaging.getToken();
    if (token != null && userId != null) {
      await _saveToken(userId, token);
    }

    // Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      if (userId != null) {
        _saveToken(userId, newToken);
      }
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background/terminated tap
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Check if app was opened from a terminated state via notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleMessageOpenedApp(initialMessage);
    }
  }

  Future<void> _saveToken(String userId, String token) async {
    await _db.collection('users').doc(userId).update({
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    });
  }

  void _handleForegroundMessage(RemoteMessage message) {
    // Foreground notification received — could show an in-app banner
    // For now we just log it. A real implementation would use
    // flutter_local_notifications to show a notification.
  }

  void _handleMessageOpenedApp(RemoteMessage message) {
    // User tapped a notification — could navigate to a specific screen
    // based on message.data['type'], message.data['id'], etc.
  }

  /// Subscribe to a topic (e.g., 'policy_reminders', 'promotions')
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
  }

  /// Unsubscribe from a topic
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
  }
}
