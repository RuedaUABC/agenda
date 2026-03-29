// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/data/latest.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;

class NotificationScheduler {
  // final FlutterLocalNotificationsPlugin _plugin =
  //     FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // tz.initializeTimeZones();

    // const androidSettings = AndroidInitializationSettings(
    //   '@mipmap/ic_launcher',
    // );
    // const initSettings = InitializationSettings(android: androidSettings);

    // await _plugin.initialize(settings: initSettings);
    print("NotificationScheduler: Initialized (Mock)");
  }

  Future<void> scheduleNotification({
    required String id,
    required DateTime when,
    required String title,
    required String body,
  }) async {
    // final androidDetails = AndroidNotificationDetails(
    //   'agenda_channel',
    //   'Agenda Notificaciones',
    //   channelDescription: 'Recordatorios de tareas y clases',
    //   importance: Importance.max,
    //   priority: Priority.high,
    // );

    // final details = NotificationDetails(android: androidDetails);

    // await _plugin.zonedSchedule(
    //   id: id.hashCode,
    //   title: title,
    //   body: body,
    //   scheduledDate: tz.TZDateTime.from(when, tz.local),
    //   notificationDetails: details,
    //   androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    // );
    print("NotificationScheduler: Scheduled notification '$id' at $when: $title - $body");
  }

  Future<void> cancelNotification(String id) async {
    // await _plugin.cancel(id: id.hashCode);
    print("NotificationScheduler: Cancelled notification '$id'");
  }
}
