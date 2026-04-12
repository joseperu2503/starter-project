import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  final FirebaseMessaging _messaging;

  NotificationService(this._messaging);

  Future<void> initialize() async {
    // Firebase Messaging / APNs requires an Apple Developer account on iOS.
    // Notifications are Android-only until APNs is configured.
    if (defaultTargetPlatform == TargetPlatform.iOS) return;

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((message) {
      // In-app handling (e.g. snackbar) can be added here.
    });
  }

  Future<String?> getToken() async {
    if (defaultTargetPlatform == TargetPlatform.iOS) return null;
    return _messaging.getToken();
  }
}
