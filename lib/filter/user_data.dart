import 'dart:convert';
import 'package:telegram_bot/util.dart';

class UserData {
  final String name;
  final String username;
  final int userId;
  final List<FilterModel> filters;

  UserData({
    required this.name,
    required this.username,
    required this.userId,
    required this.filters,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'username': username,
    'user_id': userId,
    'filters': filters.map((f) => f.toJson()).toList(),
  };

  factory UserData.fromJson(Map<String, dynamic> json) => UserData(
    name: json['name'],
    username: json['username'],
    userId: json['user_id'],
    filters: (json['filters'] as List).map((f) => FilterModel.fromJson(f)).toList(),
  );

  String toJsonString() => JsonEncoder.withIndent('  ').convert(toJson());
}