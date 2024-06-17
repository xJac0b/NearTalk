import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injecteo/injecteo.dart';
import 'package:neartalk/presentation/shared/cubit/safe_action_cubit.dart';
import 'package:neartalk/presentation/snackbar/snackbar_controller.dart';
import 'package:neartalk/presentation/snackbar/snackbar_message.dart';

part 'snackbar_action.dart';
part 'snackbar_cubit.freezed.dart';
part 'snackbar_state.dart';

@inject
class SnackbarCubit extends SafeActionCubit<SnackbarState, SnackbarAction> {
  SnackbarCubit() : super(const SnackbarState.initial());

  final List<SnackbarMessage> queue = [];

  StreamSubscription<SnackbarMessage>? _messagesSubscription;

  Timer? timer;

  void init() {
    _messagesSubscription = SnackbarController.onMessage.listen((event) {
      if (state is SnackbarStateMessage &&
          (state as SnackbarStateMessage).message.message == event.message) {
        return;
      }

      if (event.force) {
        queue.clear();
        dispatch(const SnackbarAction.dismissed());
      }

      queue.add(event);
      dispatch(const SnackbarAction.show());
    });

    SnackbarController.onClearAll = () {
      queue.clear();
      dispatch(const SnackbarAction.dismissed());
    };
  }

  void next() {
    if (queue.isEmpty) return emit(const SnackbarState.initial());

    emit(SnackbarState.message(message: queue.first));
  }

  void countdown() {
    timer?.cancel();

    final message = queue.first;
    queue.removeAt(0);

    timer = Timer(message.duration, () {
      dispatch(const SnackbarAction.dismissed());
    });
  }

  @override
  Future<void> close() async {
    await _messagesSubscription?.cancel();
    return super.close();
  }
}
