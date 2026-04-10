import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/routes/app_routes.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_event.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/features/auth/presentation/screens/login_screen.dart';
import 'package:newsly/firebase_options.dart';
import 'package:newsly/injection_container.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>()..add(const CheckAuthEvent()),
      child: MaterialApp(
        title: 'Newsly',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              return const _HomeWrapper();
            }
            return const LoginScreen();
          },
        ),
      ),
    );
  }
}

// Wraps HomeScreen inside the MaterialApp routing so named routes work
class _HomeWrapper extends StatelessWidget {
  const _HomeWrapper();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
