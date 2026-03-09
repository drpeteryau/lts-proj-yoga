// Stub implementation for non-web platforms.
// This is used to avoid importing dart:html on mobile/desktop.

class WebNotificationHelper {
  static bool get supported => false;
  static String get permission => 'denied';
  static Future<String> requestPermission() async => 'denied';
  static Future<bool> show({String? title, String? body, String? icon}) async => false;
}
