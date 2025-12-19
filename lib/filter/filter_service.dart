import 'dart:convert';
import 'dart:io';
import 'package:telegram_bot/util.dart';

class FilterService {
  static const String _basePath = 'data';

  static Future<UserData?> _getUserData(int chatId, int userId) async {
    final file = File('$_basePath/chat/$chatId/user/$userId.json');
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    return UserData.fromJson(jsonDecode(content));
  }

  static Future<UserData?> _getPersonalUserData(int userId) async {
    final file = File('$_basePath/user/$userId.json');
    if (!await file.exists()) return null;
    final content = await file.readAsString();
    return UserData.fromJson(jsonDecode(content));
  }

  static Future<void> _saveUserData(int chatId, UserData userData) async {
    final dir = Directory('$_basePath/chat/$chatId/user');
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('$_basePath/chat/$chatId/user/${userData.userId}.json');
    await file.writeAsString(userData.toJsonString());
  }

  static Future<void> _savePersonalUserData(UserData userData) async {
    final dir = Directory('$_basePath/user');
    if (!await dir.exists()) await dir.create(recursive: true);
    final file = File('$_basePath/user/${userData.userId}.json');
    await file.writeAsString(userData.toJsonString());
  }

  static Future<FilterModel?> checkFilterExists(int chatId, String key) async {
    final dir = Directory('$_basePath/chat/$chatId/user');
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

  static Future<FilterModel?> checkPersonalFilterExists(int userId, String key) async {
    final userData = await _getPersonalUserData(userId);
    if (userData == null) return null;
    
    final lowerKey = key.toLowerCase();
    for (final filter in userData.filters) {
      if (filter.key == lowerKey) return filter;
    }
    return null;
  }

  static Future<void> saveFilter(int chatId, int userId, String name, String username, FilterModel filter) async {
    final isPrivateChat = chatId == userId;
    
    if (isPrivateChat) {
      var userData = await _getPersonalUserData(userId) ?? UserData(
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
      
      await _savePersonalUserData(userData);
    } else {
      var userData = await _getUserData(chatId, userId) ?? UserData(
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
      
      await _saveUserData(chatId, userData);
    }
  }

  static Future<List<FilterModel>> getChatFilters(int chatId) async {
    final dir = Directory('$_basePath/chat/$chatId/user');
    if (!await dir.exists()) return [];
    
    final allFilters = <FilterModel>[];
    await for (final file in dir.list().where((f) => f.path.endsWith('.json'))) {
      final content = await File(file.path).readAsString();
      final userData = UserData.fromJson(jsonDecode(content));
      allFilters.addAll(userData.filters);
    }
    return allFilters;
  }

  static Future<List<FilterModel>> getPersonalFilters(int userId) async {
    final userData = await _getPersonalUserData(userId);
    return userData?.filters ?? [];
  }

  static Future<List<FilterModel>> checkChatFilters(int chatId, String text) async {
    final filters = await getChatFilters(chatId);
    final lowerText = text.toLowerCase();
    return filters.where((f) => lowerText.contains(f.key)).toList();
  }
}
