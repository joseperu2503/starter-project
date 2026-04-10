abstract class AuthEvent {
  const AuthEvent();
}

class SignInEvent extends AuthEvent {
  final String email;
  final String password;
  const SignInEvent({required this.email, required this.password});
}

class RegisterEvent extends AuthEvent {
  final String email;
  final String password;
  final String displayName;
  const RegisterEvent({
    required this.email,
    required this.password,
    required this.displayName,
  });
}

class SignOutEvent extends AuthEvent {
  const SignOutEvent();
}

class CheckAuthEvent extends AuthEvent {
  const CheckAuthEvent();
}
