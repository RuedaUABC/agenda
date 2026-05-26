import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

  NotificationScheduler({FlutterLocalNotificationsPlugin? plugin})
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const initSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(),
      macOS: DarwinInitializationSettings(),
      linux: LinuxInitializationSettings(defaultActionName: 'Abrir Agenda'),
      windows: WindowsInitializationSettings(
        appName: 'Agenda',
        appUserModelId: 'Agenda.Local.SVVP',
        guid: '3f4b54bd-2bc1-4f4f-9d88-4d4f3f2a0f6b',
      ),
    );

    try {
      await _plugin.initialize(settings: initSettings);
    } on MissingPluginException catch (error) {
      debugPrint('NotificationScheduler: plugin not available ($error)');
    }
    _initialized = true;
    debugPrint('NotificationScheduler: Initialized');
  }

  Future<void> scheduleNotification({
    required String id,
    required DateTime when,
    required String title,
    required String body,
  }) async {
    if (!_initialized) {
      await init();
    }

    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'agenda_channel',
        'Agenda Notificaciones',
        channelDescription: 'Recordatorios de tareas, clases y eventos',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
      macOS: DarwinNotificationDetails(),
      linux: LinuxNotificationDetails(),
      windows: WindowsNotificationDetails(),
    );

    try {
      await _plugin.zonedSchedule(
        id: id.hashCode,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(when, tz.local),
        notificationDetails: details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on MissingPluginException catch (error) {
      debugPrint('NotificationScheduler: plugin not available ($error)');
    } on UnimplementedError catch (error) {
      debugPrint('NotificationScheduler: scheduling not available ($error)');
    }
    debugPrint(
      "NotificationScheduler: Scheduled notification '$id' at $when: $title - $body",
    );
  }

  Future<void> cancelNotification(String id) async {
    if (!_initialized) {
      await init();
    }

    try {
      await _plugin.cancel(id: id.hashCode);
    } on MissingPluginException catch (error) {
      debugPrint('NotificationScheduler: plugin not available ($error)');
    }
    debugPrint("NotificationScheduler: Cancelled notification '$id'");
  }
}
