import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newsly/config/routes/app_routes.dart';
import 'package:newsly/config/theme/app_theme.dart';
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
    return MaterialApp(
      title: 'Newsly',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: AppRoutes.home,
    );
  }
}
