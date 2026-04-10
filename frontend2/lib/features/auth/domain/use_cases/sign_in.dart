import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/auth/domain/entities/user_entity.dart';
import 'package:newsly/features/auth/domain/repository/auth_repository.dart';

class SignInParams {
  final String email;
  final String password;

  const SignInParams({required this.email, required this.password});
}

class SignIn implements UseCase<UserEntity, SignInParams> {
  final AuthRepository _repository;

  SignIn(this._repository);

  @override
  Future<UserEntity> call(SignInParams params) {
    return _repository.signIn(email: params.email, password: params.password);
  }
}
