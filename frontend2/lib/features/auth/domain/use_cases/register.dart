import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/auth/domain/entities/user_entity.dart';
import 'package:newsly/features/auth/domain/repository/auth_repository.dart';

class RegisterParams {
  final String email;
  final String password;
  final String displayName;

  const RegisterParams({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

class Register implements UseCase<UserEntity, RegisterParams> {
  final AuthRepository _repository;

  Register(this._repository);

  @override
  Future<UserEntity> call(RegisterParams params) {
    return _repository.register(
      email: params.email,
      password: params.password,
      displayName: params.displayName,
    );
  }
}
