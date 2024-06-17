import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SnackbarType { successful, error, warning, info, notification }

enum SnackbarPosition { top, bottom }

class SnackbarMessage {
  const SnackbarMessage({
    required this.message,
    required this.type,
    required this.icon,
    this.force = true,
    this.dismissible = true,
    this.duration = const Duration(seconds: 5),
    this.position = SnackbarPosition.bottom,
  });

  factory SnackbarMessage.successful({
    required String message,
    bool force = true,
    bool dismissible = true,
    Duration duration = const Duration(seconds: 5),
    SnackbarPosition position = SnackbarPosition.bottom,
    IconData icon = FontAwesomeIcons.circleCheck,
  }) =>
      SnackbarMessage(
        message: message,
        type: SnackbarType.successful,
        force: force,
        dismissible: dismissible,
        duration: duration,
        position: position,
        icon: icon,
      );

  factory SnackbarMessage.error({
    required String message,
    bool force = true,
    bool dismissible = true,
    Duration duration = const Duration(seconds: 5),
    SnackbarPosition position = SnackbarPosition.bottom,
    IconData icon = FontAwesomeIcons.exclamation,
  }) =>
      SnackbarMessage(
        message: message,
        type: SnackbarType.error,
        force: force,
        dismissible: dismissible,
        duration: duration,
        position: position,
        icon: icon,
      );

  factory SnackbarMessage.warning({
    required String message,
    bool force = true,
    bool dismissible = true,
    Duration duration = const Duration(seconds: 5),
    SnackbarPosition position = SnackbarPosition.bottom,
    IconData icon = FontAwesomeIcons.triangleExclamation,
  }) =>
      SnackbarMessage(
        message: message,
        type: SnackbarType.warning,
        force: force,
        dismissible: dismissible,
        duration: duration,
        position: position,
        icon: icon,
      );

  factory SnackbarMessage.info({
    required String message,
    bool force = true,
    bool dismissible = true,
    Duration duration = const Duration(seconds: 5),
    SnackbarPosition position = SnackbarPosition.bottom,
    IconData icon = FontAwesomeIcons.circleInfo,
  }) =>
      SnackbarMessage(
        message: message,
        type: SnackbarType.info,
        force: force,
        dismissible: dismissible,
        duration: duration,
        position: position,
        icon: icon,
      );

  factory SnackbarMessage.notification({
    required String message,
    bool force = false,
    bool dismissible = true,
    Duration duration = const Duration(seconds: 5),
    SnackbarPosition position = SnackbarPosition.bottom,
    IconData icon = FontAwesomeIcons.bell,
  }) =>
      SnackbarMessage(
        message: message,
        type: SnackbarType.notification,
        force: force,
        dismissible: dismissible,
        duration: duration,
        position: position,
        icon: icon,
      );

  final String message;
  final IconData icon;
  final SnackbarType type;
  final SnackbarPosition position;
  final bool force;
  final bool dismissible;
  final Duration duration;
}
