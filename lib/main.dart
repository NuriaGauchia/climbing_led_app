import 'package:flutter/material.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';

void main() {
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
      themeMode: ThemeMode.system, // usa el tema del sistema
      initialRoute: '/auth',
      routes: AppRoutes.routes,
    );
  }
}