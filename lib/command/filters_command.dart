import 'package:teledart/model.dart';
import 'package:telegram_bot/util.dart';

class FiltersCommand {
  static Future<void> handleMyFilters(Message message) async {
    final args = message.text?.split(' ');
    
    if (args != null && args.length > 1) {
      final key = args.sublist(1).join(' ').toLowerCase();
      final filter = await FilterService.checkPersonalFilterExists(message.from!.id, key);
      
      if (filter != null) {
        await _sendFilterMedia(message.chat.id, message.messageId, filter);
      } else {
        await TeleDartProvider.teleDart!.sendMessage(
          message.chat.id,
          'Личный фильтр "$key" не найден',
        );
      }
      return;
    }
    
    final filters = await FilterService.getPersonalFilters(message.from!.id);
    
    if (filters.isEmpty) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'У вас нет личных фильтров',
      );
      return;
    }

    final filterList = filters.map((f) => '• ${f.key}').join('\n');
    await TeleDartProvider.teleDart!.sendMessage(
      message.chat.id,
      'Ваши личные фильтры:\n$filterList',
    );
  }

  static Future<void> handleAllFilters(Message message) async {
    final allFilters = await FilterService.getChatFilters(message.chat.id);
    
    if (allFilters.isEmpty) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'В этом чате нет фильтров',
      );
      return;
    }

    final filterList = allFilters.map((f) => '• ${f.key}').join('\n');
    await TeleDartProvider.teleDart!.sendMessage(
      message.chat.id,
      'Фильтры этого чата:\n$filterList',
    );
  }
  
  static Future<void> _sendFilterMedia(int chatId, int replyToId, FilterModel filter) async {
    final td = TeleDartProvider.teleDart!;
    switch (filter.mediaType) {
      case 'photo':
        await td.sendPhoto(chatId, filter.url, replyToMessageId: replyToId, caption: filter.description);
      case 'video':
        await td.sendVideo(chatId, filter.url, replyToMessageId: replyToId, caption: filter.description);
      case 'animation':
        await td.sendAnimation(chatId, filter.url, replyToMessageId: replyToId, caption: filter.description);
      case 'sticker':
        await td.sendSticker(chatId, filter.url, replyToMessageId: replyToId);
      case 'document':
        await td.sendDocument(chatId, filter.url, replyToMessageId: replyToId, caption: filter.description);
      default:
        if (filter.description.isNotEmpty) {
          await td.sendMessage(chatId, filter.description, replyToMessageId: replyToId);
        }
    }
  }
}