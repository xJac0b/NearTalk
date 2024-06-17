// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:story/domain/errors/app_general_error.dart';

// import 'package:story/generated/local_keys.g.dart';

// class DatabaseError extends AppGeneralError {
//   DatabaseError(this.error, super.message);

//   factory DatabaseError.fromFirebaseException(FirebaseException error) => switch (error.code) {
//         _ => DatabaseErrorUnknown(),
//       };

//   final FirebaseException? error;
// }

// class DatabaseErrorUnknown extends DatabaseError {
//   DatabaseErrorUnknown() : super(null, LocaleKeys.error_auth_unknown);
// }

// class DatabaseErrorUsernameAlreadyTaken extends DatabaseError {
//   DatabaseErrorUsernameAlreadyTaken() : super(null, LocaleKeys.error_database_user_already_taken);
// }
