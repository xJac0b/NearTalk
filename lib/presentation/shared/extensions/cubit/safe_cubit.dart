import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

abstract class SafeCubit<State> extends Cubit<State> {
  SafeCubit(super.initialState);

  @protected
  @visibleForTesting
  @override
  void emit(State state) {
    if (isClosed) {
      Logger().w(
        '$runtimeType - ignore emitting state after calling close',
      );
    } else {
      super.emit(state);
    }
  }

  @override
  Future<void> close() async {
    await super.close();
  }
}
