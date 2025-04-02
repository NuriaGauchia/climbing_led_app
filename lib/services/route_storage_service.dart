import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/route_model.dart';

class RouteStorageService {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/routes.json');
  }

  static Future<List<ClimbingRoute>> loadRoutes() async {
    final file = await _getFile();
    if (!await file.exists()) return [];

    final json = await file.readAsString();
    final list = jsonDecode(json) as List;
    return list.map((e) => ClimbingRoute.fromJson(e)).toList();
  }

  static Future<void> saveRoutes(List<ClimbingRoute> routes) async {
    final file = await _getFile();
    final json = jsonEncode(routes.map((e) => e.toJson()).toList());
    await file.writeAsString(json);
  }

  static Future<void> addRoute(ClimbingRoute route) async {
    final routes = await loadRoutes();
    routes.add(route);
    await saveRoutes(routes);
  }

  static Future<void> saveRoute(ClimbingRoute route) async {
    await addRoute(route); // reutiliza addRoute para mantener consistencia
  }

  static Future<void> updateRouteAtIndex(int index, ClimbingRoute updated) async {
    final routes = await loadRoutes();
    if (index >= 0 && index < routes.length) {
      routes[index] = updated;
      await saveRoutes(routes);
    }
  }

  static Future<void> deleteRouteAtIndex(int index) async {
    final routes = await loadRoutes();
    if (index >= 0 && index < routes.length) {
      routes.removeAt(index);
      await saveRoutes(routes);
    }
  }

  static Future<void> clearAllRoutes() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}