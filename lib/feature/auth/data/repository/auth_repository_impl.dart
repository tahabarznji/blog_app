import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/exceptions/server_exceptions.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/feature/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/core/general/entities/user.dart';
import 'package:blog_app/feature/auth/data/models/user_model.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource authRemoteDataSource;
  final ConnectionChecker connectionChecker;
  AuthRepositoryImpl(
      {required this.authRemoteDataSource, required this.connectionChecker});

  @override
  Future<Either<Failures, User>> currentUser() async {
    try {
      if (!await connectionChecker.isConnected) {
        final session = authRemoteDataSource.currentUserSession;
        if (session == null) {
          return left(Failures('Usernot logged in!'));
        }
        return right(
          UserModel(id: session.user.id, name: '', email: session.user.email!),
        );
      }
      final user = await authRemoteDataSource.getCurrentUserData();
      if (user == null) {
        return left(Failures('User not logged in'));
      }
      return right(user);
    } on ServerExceptions catch (e) {
      return left(Failures(e.massage));
    }
  }

  @override
  Future<Either<Failures, User>> loginWithEmailPassword(
      {required String email, required String password}) async {
    return await _getUser(
      () async => await authRemoteDataSource.loginWithEmailPassWord(
          email: email, password: password),
    );
  }

  @override
  Future<Either<Failures, User>> signUpWithEmailPassword(
      {required String name,
      required String email,
      required String password}) async {
    return await _getUser(
      () async => await authRemoteDataSource.signUpWithEmailPassWord(
          name: name, email: email, password: password),
    );
  }

  Future<Either<Failures, User>> _getUser(
    Future<User> Function() fn,
  ) async {
    if (!await connectionChecker.isConnected) {
      return left(Failures('no internet connection'));
    }
    try {
      final userId = await fn();
      print('user created thats the user id: $userId');

      return right(userId);
    } on ServerExceptions catch (e) {
      print('user not created thats the user thats the error: ${e.massage}');
      return left(Failures(e.massage));
    }
  }
}
