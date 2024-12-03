import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/general/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failures, User>> signUpWithEmailPassword(
      {required String name, required String email, required String password});
  // with out implementation

// with out implemntation
  Future<Either<Failures, User>> loginWithEmailPassword(
      {required String email, required String password});

  Future<Either<Failures, User>> currentUser();
}
