import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SimplePinService {
  static const String _defaultPin = '8288';
  static const String _backdoorPin = '9999';
  static const String _customPinKey = 'custom_video_pin';

  // In-memory flag - resets when app closes
  static bool _isPinVerified = false;

  // Get current PIN (default or custom)
  static Future<String> getCurrentPin() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_customPinKey) ?? _defaultPin;
    } catch (e) {
      if (kDebugMode) print('Error getting PIN: $e');
      return _defaultPin;
    }
  }

  // Update PIN (only via backdoor)
  static Future<bool> updatePin(String newPin) async {
    if (newPin.length != 4 || !RegExp(r'^\d{4}$').hasMatch(newPin)) {
      return false; // Must be 4 digits
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_customPinKey, newPin);
      return true;
    } catch (e) {
      if (kDebugMode) print('Error updating PIN: $e');
      return false;
    }
  }

  // Verify PIN
  static Future<bool> verifyPin(String inputPin) async {
    final currentPin = await getCurrentPin();
    final isCorrect = inputPin == currentPin;

    if (isCorrect) {
      _isPinVerified = true; // Set flag for this session
    }

    return isCorrect;
  }

  // Check if backdoor PIN
  static bool isBackdoorPin(String inputPin) {
    return inputPin == _backdoorPin;
  }

  // Check if PIN already verified this session
  static bool isPinVerifiedThisSession() {
    return _isPinVerified;
  }

  // Reset verification (optional - for logout/security)
  static void resetVerification() {
    _isPinVerified = false;
  }

  // Reset to default PIN
  static Future<void> resetToDefault() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_customPinKey);
    _isPinVerified = false;
  }
}