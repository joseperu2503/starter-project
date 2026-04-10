import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/core/usecase/usecase.dart';
import 'package:newsly/features/auth/domain/use_cases/register.dart';
import 'package:newsly/features/auth/domain/use_cases/sign_in.dart';
import 'package:newsly/features/auth/domain/use_cases/sign_out.dart';
import 'package:newsly/features/auth/domain/repository/auth_repository.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_event.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final Register _register;
  final SignOut _signOut;
  final AuthRepository _authRepository;

  AuthBloc({
    required SignIn signIn,
    required Register register,
    required SignOut signOut,
    required AuthRepository authRepository,
  })  : _signIn = signIn,
        _register = register,
        _signOut = signOut,
        _authRepository = authRepository,
        super(const AuthInitial()) {
    on<CheckAuthEvent>(_onCheckAuth);
    on<SignInEvent>(_onSignIn);
    on<RegisterEvent>(_onRegister);
    on<SignOutEvent>(_onSignOut);
    on<ContinueAsGuestEvent>((_, emit) => emit(const AuthGuest()));
  }

  void _onCheckAuth(CheckAuthEvent event, Emitter<AuthState> emit) {
    final user = _authRepository.getCurrentUser();
    if (user != null) {
      emit(AuthAuthenticated(user));
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(SignInEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _signIn(
        SignInParams(email: event.email, password: event.password),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_parseError(e)));
    }
  }

  Future<void> _onRegister(RegisterEvent event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = await _register(
        RegisterParams(
          email: event.email,
          password: event.password,
          displayName: event.displayName,
        ),
      );
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(_parseError(e)));
    }
  }

  Future<void> _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    await _signOut(NoParams());
    emit(const AuthUnauthenticated());
  }

  String _parseError(Object e) {
    final msg = e.toString();
    if (msg.contains('user-not-found')) return 'No account found with this email';
    if (msg.contains('wrong-password')) return 'Incorrect password';
    if (msg.contains('email-already-in-use')) return 'Email already registered';
    if (msg.contains('weak-password')) return 'Password must be at least 6 characters';
    if (msg.contains('invalid-email')) return 'Invalid email address';
    return 'Something went wrong. Please try again.';
  }
}
