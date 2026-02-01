import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  // Singleton pattern
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  // Flutter local notifications plugin instance
  final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize the notification service
  Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
    );

    await notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (details) {
        debugPrint('Notification tapped: ${details.payload}');
      },
    );

    await _requestPermissions();
    await _createNotificationChannels();

    debugPrint('✅ Notification service initialized');
  }

  // Request necessary permissions for Android
  Future<void> _requestPermissions() async {
    final androidPlugin =
        notificationsPlugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.requestNotificationsPermission();

    try {
      await androidPlugin?.requestExactAlarmsPermission();
    } catch (_) {
      debugPrint(
        'requestExactAlarmsPermission not available — '
        'update flutter_local_notifications.',
      );
    }
  }

  // Create notification channels for Android
  Future<void> _createNotificationChannels() async {
    const AndroidNotificationChannel dailyChannel = AndroidNotificationChannel(
      'daily_yoga_reminder_channel',
      'Daily Yoga Exercise Reminders',
      description: 'Daily reminders for yoga practice',
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    final androidPlugin = notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(dailyChannel);

    debugPrint('✅ Notification channels created');
  }

  // Returns the default [NotificationDetails] used across all notifications
  NotificationDetails _notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_yoga_reminder_channel',
        'Daily Yoga Exercise Reminders',
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true,
      ),
    );
  }

  // Show an immediate notification
  Future<void> showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    await notificationsPlugin.show(
      id,
      title,
      body,
      _notificationDetails(),
      payload: payload,
    );
  }

  // Schedule a daily recurring notification at a specific time
  Future<void> scheduleDailyNotification({
    required int id,
    required String title,
    required String body,
    required int hour, // in 24-hour format (0-23)
    required int minute, // minute (0-59)
  }) async {
    try {
      final scheduledTime = _nextInstanceOfTime(hour, minute);

      await notificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledTime,
        _notificationDetails(),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );

      debugPrint('🔔 Daily notification scheduled for: $scheduledTime');
    } catch (e) {
      debugPrint('❌ Error scheduling notification: $e');
      rethrow;
    }
  }

  // If the time has passed today, returns tomorrow's time
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

  // Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    await notificationsPlugin.cancel(id);
    debugPrint('✅ Notification $id cancelled');
  }

  // Cancel all scheduled notifications
  Future<void> cancelAllNotifications() async {
    await notificationsPlugin.cancelAll();
    debugPrint('✅ All notifications cancelled');
  }
}