import 'package:flutter/material.dart';
import 'package:hooked_bloc/hooked_bloc.dart';
import 'package:logger/logger.dart';

abstract class SafeActionCubit<State extends Object, Action> extends ActionCubit<State, Action> {
  SafeActionCubit(super.initialState);

  @protected
  @visibleForTesting
  @override
  void emit(State state) {
    if (isClosed) {
      Logger().w(
        '$runtimeType - ignore emitting $state after calling close',
      );
    } else {
      super.emit(state);
    }
  }

  @protected
  @override
  void dispatch(Action action) {
    if (isClosed) {
      Logger().w(
        '$runtimeType - ignore $action dispatch after calling close',
      );
    } else {
      super.dispatch(action);
    }
  }
}
