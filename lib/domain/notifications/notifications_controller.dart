import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injecteo/injecteo.dart';

class NotificationsController {
  NotificationsController._(this._notificationsPlugin);

  @factoryMethod
  static Future<NotificationsController> create(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    final instance =
        NotificationsController._(FlutterLocalNotificationsPlugin());
    await instance._initialize();
    return instance;
  }

  final FlutterLocalNotificationsPlugin _notificationsPlugin;
  bool _enabled = false;

  Future<void> _initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('icon');

    final initializationSettingsIOS = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification:
            (int id, String? title, String? body, String? payload) async {});

    final initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await _notificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse:
            (NotificationResponse notificationResponse) async {});
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
        android: AndroidNotificationDetails('channelId', 'channelName',
            importance: Importance.max),
        iOS: DarwinNotificationDetails());
  }

  Future<void> showNotification(
      {int id = 0, String? title, String? body, String? payload}) async {
    if (!_enabled) return;
    return _notificationsPlugin.show(id, title, body, notificationDetails());
  }

  void enable() {
    _enabled = true;
  }

  void disable() {
    _enabled = false;
  }
}
