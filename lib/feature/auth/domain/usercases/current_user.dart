import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/core/general/entities/user.dart';
import 'package:blog_app/feature/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/src/either.dart';

class CurrentUser implements Usecase<User, NoParams> {
  final AuthRepository authRepository;

  CurrentUser({required this.authRepository});

  @override
  Future<Either<Failures, User>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
