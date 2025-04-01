import 'package:flutter/material.dart';
import '../pages/home_page.dart';
import '../pages/scan_wall_page.dart';
import '../pages/wall_editor_page.dart';
import '../pages/create_route_page.dart';
import '../pages/settings_page.dart';
import '../pages/auth_page.dart';
import '../pages/routes_list_page.dart';
import '../pages/edit_route_page.dart';


class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/': (context) => const HomePage(),
    '/scan': (context) => const ScanWallPage(),
    '/editor': (context) => const WallEditorPage(),
    '/create': (context) => const CreateRoutePage(),
    '/settings': (context) => const SettingsPage(),
    '/auth': (context) => const AuthPage(),
    '/routes': (context) => const RoutesListPage(),
    '/edit': (context) => const EditRoutePage(),
  };
}