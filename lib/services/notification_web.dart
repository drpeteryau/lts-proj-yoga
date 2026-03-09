// Use the modern package:web for Flutter 3.x+
import 'package:web/web.dart' as web;

class WebNotificationHelper {
  static Future<bool> show({
    required String title,
    required String body,
    String? icon,
  }) async {
    // Ask for permission if we haven't already.
    // If the user has already granted, this resolves immediately.
    final currentPermission = web.Notification.permission;
    print('WebNotification: current permission=$currentPermission');
    if (currentPermission != 'granted') {
      final result = web.Notification.requestPermission();
      print('WebNotification: permission request result=$result');
      if (result != 'granted') {
        print('WebNotification: permission not granted ($result)');
        return false;
      }
    }

    try {
      web.Notification(
        title,
        web.NotificationOptions(body: body, icon: icon ?? ''),
      );
      return true;
    } catch (e) {
      print('WebNotification: failed to show notification: $e');
      return false;
    }
  }
}
