import 'package:teledart/model.dart';
import 'package:telegram_bot/util.dart';

class FiltersCommand {
  static Future<void> handleMyFilters(Message message) async {
    final filters = await FilterService.getFilters(message.from!.id);
    
    if (filters.isEmpty) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'У вас нет созданных фильтров',
      );
      return;
    }

    final filterList = filters.map((f) => '• ${f.key}').join('\n');
    await TeleDartProvider.teleDart!.sendMessage(
      message.chat.id,
      'Ваши фильтры:\n$filterList',
    );
  }

  static Future<void> handleAllFilters(Message message) async {
    final allFilters = await FilterService.getAllFilters();
    
    if (allFilters.isEmpty) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'Нет доступных фильтров',
      );
      return;
    }

    final filterList = allFilters.map((f) => '• ${f.key}').join('\n');
    await TeleDartProvider.teleDart!.sendMessage(
      message.chat.id,
      'Все доступные фильтры:\n$filterList',
    );
  }
}