import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:newsly/config/routes/app_routes.dart';
import 'package:newsly/config/theme/app_theme.dart';
import 'package:newsly/config/theme/theme_cubit.dart';
import 'package:newsly/features/articles/presentation/screens/home_screen.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_event.dart';
import 'package:newsly/features/auth/presentation/bloc/auth_state.dart';
import 'package:newsly/features/auth/presentation/screens/login_screen.dart';
import 'package:newsly/firebase_options.dart';
import 'package:newsly/injection_container.dart';

final _navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initDependencies();
  await sl<ThemeCubit>().loadTheme();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => sl<AuthBloc>()..add(const CheckAuthEvent())),
        BlocProvider.value(value: sl<ThemeCubit>()),
      ],
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            _navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (_) => false,
            );
          } else if (state is AuthUnauthenticated) {
            _navigatorKey.currentState?.pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (_) => false,
            );
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              navigatorKey: _navigatorKey,
              title: 'Newsly',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              home: const LoginScreen(),
            );
          },
        ),
      ),
    );
  }
}
