// import 'dart:async';

// import 'package:neartalk/domain/bluetooth/bluetooth_error.dart';
// import 'package:neartalk/domain/shared/result.dart';
// import 'package:injecteo/injecteo.dart';
// import 'package:logger/logger.dart';

// @inject
// class ErrorHandler {
//   Future<Result<S, E>> call<S, E>(
//     FutureOr<dynamic> Function() function,
//   ) async {
//     try {
//       final res = await function();

//       if (res is S) return Success(res);

//       return Success(unit as S);
//     } catch (e) {
//       Logger().d('Error: $e');
//       final error = ();

//       return Failure(error as E);
//     }
//   }
// }
