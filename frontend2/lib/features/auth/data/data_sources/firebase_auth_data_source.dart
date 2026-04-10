import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:newsly/features/auth/domain/entities/user_entity.dart';

class FirebaseAuthDataSource {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  FirebaseAuthDataSource(this._auth)
      : _googleSignIn = GoogleSignIn();

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

  Future<UserEntity> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw Exception('Google sign-in cancelled');
    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final userCredential = await _auth.signInWithCredential(credential);
    return _userFromCredential(userCredential.user!);
  }

  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
    ]);
  }

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
