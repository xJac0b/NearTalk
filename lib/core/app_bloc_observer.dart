import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    Logger().d('onChange(${bloc.runtimeType}, $change)');
  }

  @override
  void onEvent(Bloc<dynamic, dynamic> bloc, Object? event) {
    Logger().d('onEvent(${bloc.runtimeType}, $event)');
    super.onEvent(bloc, event);
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    Logger().e('onError(${bloc.runtimeType})', error: error, stackTrace: stackTrace);
    super.onError(bloc, error, stackTrace);
  }
}
