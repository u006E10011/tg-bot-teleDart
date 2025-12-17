import 'dart:convert';
import 'dart:io';
import 'package:telegram_bot/util.dart';

class FilterService {
  static const String _basePath = 'data/filter';

  static Future<UserData?> _getUserData(int userId) async {
    final file = File('$_basePath/$userId.json');
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    return UserData.fromJson(jsonDecode(content));
  }

  static Future<void> _saveUserData(UserData userData) async {
    final dir = Directory(_basePath);
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('$_basePath/${userData.userId}.json');
    await file.writeAsString(userData.toJsonString());
  }

  static Future<FilterModel?> checkFilterExists(String key) async {
    final dir = Directory(_basePath);
    if (!await dir.exists()) return null;
    
    final lowerKey = key.toLowerCase();
    await for (final file in dir.list().where((f) => f.path.endsWith('.json'))) {
      final content = await File(file.path).readAsString();
      final userData = UserData.fromJson(jsonDecode(content));
      for (final filter in userData.filters) {
        if (filter.key == lowerKey) return filter;
      }
    }
    return null;
  }

  static Future<void> saveFilter(int userId, String name, String username, FilterModel filter) async {
    var userData = await _getUserData(userId) ?? UserData(
      name: name,
      username: username,
      userId: userId,
      filters: [],
    );
    
    userData = UserData(
      name: name,
      username: username,
      userId: userId,
      filters: [...userData.filters, filter],
    );
    
    await _saveUserData(userData);
  }

  static Future<List<FilterModel>> getFilters(int userId) async {
    final userData = await _getUserData(userId);
    return userData?.filters ?? [];
  }

  static Future<List<FilterModel>> getAllFilters() async {
    final dir = Directory(_basePath);
    if (!await dir.exists()) return [];
    
    final allFilters = <FilterModel>[];
    await for (final file in dir.list().where((f) => f.path.endsWith('.json'))) {
      final content = await File(file.path).readAsString();
      final userData = UserData.fromJson(jsonDecode(content));
      allFilters.addAll(userData.filters);
    }
    return allFilters;
  }
}
