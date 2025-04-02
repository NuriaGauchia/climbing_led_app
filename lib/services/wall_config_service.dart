import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/wall_config_model.dart';

class WallConfigService {
  static Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/wall_config.json');
  }

  static Future<WallConfig?> loadConfig() async {
    final file = await _getFile();
    if (!await file.exists()) return null;

    final json = await file.readAsString();
    return WallConfig.fromJson(jsonDecode(json));
  }

  static Future<void> saveConfig(WallConfig config) async {
    final file = await _getFile();
    final json = jsonEncode(config.toJson());
    await file.writeAsString(json);
  }

  static Future<void> clearConfig() async {
    final file = await _getFile();
    if (await file.exists()) {
      await file.delete();
    }
  }
}