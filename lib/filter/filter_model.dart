import 'dart:convert';
import 'package:intl/intl.dart';

class FilterModel {
  final String key;
  final String url;
  final String description;
  final DateTime date;
  final String mediaType;

  FilterModel({
    required this.key,
    required this.url,
    required this.description,
    required this.date,
    required this.mediaType,
  });

  Map<String, dynamic> toJson() => {
    'key': key,
    'url': url,
    'description': description,
    'date': DateFormat('dd.MM.yyyy HH:mm').format(date),
    'mediaType': mediaType,
  };

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
    key: json['key'],
    url: json['url'],
    description: json['description'],
    date: _parseDate(json['date']),
    mediaType: json['mediaType'] ?? 'text',
  );

  static DateTime _parseDate(String dateStr) {
    try {
      return DateFormat('dd.MM.yyyy HH:mm').parse(dateStr);
    } catch (e) {
      return DateTime.parse(dateStr);
    }
  }

  String toJsonString() => JsonEncoder.withIndent('  ').convert(toJson());
}
