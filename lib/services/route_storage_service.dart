import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_model.dart';

class RouteStorageService {
  static const String key = 'climbing_routes';

  static Future<List<ClimbingRoute>> loadRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];
    return data.map((jsonStr) {
      final jsonMap = json.decode(jsonStr);
      return ClimbingRoute.fromJson(jsonMap);
    }).toList();
  }

  static Future<void> saveRoute(ClimbingRoute route) async {
    final prefs = await SharedPreferences.getInstance();
    final routes = await loadRoutes();
    routes.add(route);
    final jsonList = routes.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }
}