import 'package:newsly/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> signIn({required String email, required String password});
  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  });
  Future<UserEntity> signInWithGoogle();
  Future<void> signOut();
  UserEntity? getCurrentUser();
}
