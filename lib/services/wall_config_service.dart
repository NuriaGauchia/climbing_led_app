import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/wall_config_model.dart';

class WallConfigService {
  static const String key = 'wall_config';

  static Future<void> saveConfig(WallConfig config) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(config.toJson());
    await prefs.setString(key, jsonStr);
  }

  static Future<WallConfig?> loadConfig() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(key);
    if (jsonStr == null) return null;
    final jsonMap = json.decode(jsonStr);
    return WallConfig.fromJson(jsonMap);
  }
}