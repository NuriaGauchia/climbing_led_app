import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ClimbingLedApp());
}

class ClimbingLedApp extends StatelessWidget {
  const ClimbingLedApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Climbing LED App',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/auth',
      routes: AppRoutes.routes,
    );
  }
}
