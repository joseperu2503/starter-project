import 'package:newsly/features/auth/data/data_sources/firebase_auth_data_source.dart';
import 'package:newsly/features/auth/domain/entities/user_entity.dart';
import 'package:newsly/features/auth/domain/repository/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuthDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<UserEntity> signIn({required String email, required String password}) {
    return _dataSource.signIn(email: email, password: password);
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  }) {
    return _dataSource.register(
      email: email,
      password: password,
      displayName: displayName,
    );
  }

  @override
  Future<UserEntity> signInWithGoogle() => _dataSource.signInWithGoogle();

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  UserEntity? getCurrentUser() => _dataSource.getCurrentUser();
}
