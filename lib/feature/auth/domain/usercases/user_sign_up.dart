import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/general/entities/user.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class UserSignUp implements Usecase<User, UserSignupParams> {
  final AuthRepository authRepository;
  // dabe data layar nabi u interface betn
  UserSignUp({required this.authRepository});
  @override
  Future<Either<Failures, User>> call(UserSignupParams params) async {
    return await authRepository.signUpWithEmailPassword(
        name: params.name, email: params.email, password: params.password);
  }
}

class UserSignupParams {
  final String name;
  final String email;
  final String password;
  UserSignupParams(
      {required this.name, required this.email, required this.password});
}
