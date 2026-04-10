import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/auth/domain/repository/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository _repository;

  SignOut(this._repository);

  @override
  Future<void> call(NoParams params) {
    return _repository.signOut();
  }
}
