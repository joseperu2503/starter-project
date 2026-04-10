import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _messaging;

  NotificationService(this._messaging);

  Future<void> initialize() async {
    // Request permission (iOS + Android 13+)
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((message) {
      // Messages are handled by the OS when app is in background/terminated.
      // In foreground you'd show an in-app snackbar — handled at UI layer.
    });
  }

  Future<String?> getToken() => _messaging.getToken();
}
