import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/route_model.dart';

class RouteStorageService {
  static const String key = 'climbing_routes';

  // Cargar todos los bloques guardados
  static Future<List<ClimbingRoute>> loadRoutes() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList(key) ?? [];
    return data.map((jsonStr) {
      final jsonMap = json.decode(jsonStr);
      return ClimbingRoute.fromJson(jsonMap);
    }).toList();
  }

  // Guardar un nuevo bloque
  static Future<void> saveRoute(ClimbingRoute route) async {
    final prefs = await SharedPreferences.getInstance();
    final routes = await loadRoutes();
    routes.add(route);
    final jsonList = routes.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  // Actualizar un bloque existente por su posición en la lista
  static Future<void> updateRouteAtIndex(int index, ClimbingRoute updated) async {
    final prefs = await SharedPreferences.getInstance();
    final routes = await loadRoutes();

    if (index < 0 || index >= routes.length) return;

    routes[index] = updated;
    final jsonList = routes.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }

  // Eliminar un bloque por su índice
  static Future<void> deleteRouteAtIndex(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final routes = await loadRoutes();

    if (index < 0 || index >= routes.length) return;

    routes.removeAt(index);
    final jsonList = routes.map((r) => json.encode(r.toJson())).toList();
    await prefs.setStringList(key, jsonList);
  }
}