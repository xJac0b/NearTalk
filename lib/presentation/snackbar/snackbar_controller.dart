import 'dart:async';
import 'dart:ui';

import 'package:injecteo/injecteo.dart';
import 'package:neartalk/presentation/snackbar/snackbar_message.dart';

@singleton
class SnackbarController {
  static final StreamController<SnackbarMessage> _snackbarSubject =
      StreamController.broadcast();

  static Stream<SnackbarMessage> get onMessage => _snackbarSubject.stream;

  static VoidCallback? onClearAll;

  static void clearAll() => onClearAll?.call();

  static void show(SnackbarMessage snackbar) {
    _snackbarSubject.add(snackbar);
  }

  static void showError(String message) {
    final snackbar = SnackbarMessage.error(message: message);
    show(snackbar);
  }

  static void showSuccessful(String message) {
    final snackbar = SnackbarMessage.successful(message: message);
    show(snackbar);
  }

  static void showWarning(String message) {
    final snackbar = SnackbarMessage.warning(message: message);
    show(snackbar);
  }

  static void showInfo(String message) {
    final snackbar = SnackbarMessage.info(message: message);
    show(snackbar);
  }

  static void showNoticiation(String message) {
    final snackbar = SnackbarMessage.notification(message: message);
    show(snackbar);
  }
}
