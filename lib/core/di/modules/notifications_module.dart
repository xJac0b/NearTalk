import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/domain/notifications/notifications_controller.dart';

@externalModule
abstract class NotificationsModule {
  @preResolve
  @singleton
  Future<NotificationsController> notificationsController() =>
      NotificationsController.create(FlutterLocalNotificationsPlugin());
}
