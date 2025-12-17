import 'dart:convert';
import 'dart:io';
import 'package:telegram_bot/util.dart';

class FilterService {
  static const String _basePath = 'data/filter';

  static Future<void> saveFilter(int userId, FilterModel filter) async {
    final dir = Directory('$_basePath/$userId');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }

    final file = File('${dir.path}/${filter.key}.json');
    await file.writeAsString(filter.toJsonString());
  }

  static Future<List<FilterModel>> getFilters(int userId) async {
    final dir = Directory('$_basePath/$userId');
    if (!await dir.exists()) return [];

    final files = await dir
        .list()
        .where((f) => f.path.endsWith('.json'))
        .toList();
    final filters = <FilterModel>[];

    for (final file in files) {
      final content = await File(file.path).readAsString();
      filters.add(FilterModel.fromJson(jsonDecode(content)));
    }

    return filters;
  }
}
