import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsly/features/auth/domain/entities/user_entity.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;

  FirebaseAuthDataSource(this._auth);

  Future<UserEntity> signIn({
    required String email,
    required String password,
  }) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return _userFromCredential(credential.user!);
  }

  Future<UserEntity> register({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user!.updateDisplayName(displayName);
    return _userFromCredential(credential.user!);
  }

  Future<void> signOut() => _auth.signOut();

  UserEntity? getCurrentUser() {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _userFromCredential(user);
  }

  UserEntity _userFromCredential(User user) {
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName ?? user.email ?? '',
    );
  }
}
