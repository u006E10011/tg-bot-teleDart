import 'dart:convert';

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
    'date': date.toIso8601String(),
    'mediaType': mediaType,
  };

  factory FilterModel.fromJson(Map<String, dynamic> json) => FilterModel(
    key: json['key'],
    url: json['url'],
    description: json['description'],
    date: DateTime.parse(json['date']),
    mediaType: json['mediaType'] ?? 'text',
  );

  String toJsonString() => jsonEncode(toJson());
}