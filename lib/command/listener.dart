import 'package:teledart/teledart.dart';
import 'package:teledart/model.dart';
import 'package:telegram_bot/util.dart';

class Listener {
  final Map<String, String> command = {
    "start": "GitHub: https://github.com/u006E10011/tg-bot-teleDart",
    "info": "NullReferenceException",
  };

  Listener addListeners(TeleDart teleDart) {
    command.forEach(
      (key, value) =>
          teleDart.onCommand(key).listen((message) => message.reply(value)),
    );

    teleDart.onCommand('filter').listen(_handleFilterCommand);
    teleDart.onCommand('mfilters').listen(FiltersCommand.handleMyFilters);
    teleDart.onCommand('mf').listen(FiltersCommand.handleMyFilters);
    teleDart.onCommand('filters').listen(FiltersCommand.handleAllFilters);
    teleDart.onCommand('f').listen(FiltersCommand.handleAllFilters);
    teleDart.onMessage().listen(_checkForFilters);

    return this;
  }

  Future<void> _handleFilterCommand(Message message) async {
    final args = message.text?.split(' ');
    if (args == null || args.length < 2) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'Укажите название фильтра: /filter <название>',
      );
      return;
    }

    final key = args.sublist(1).join(' ');
    
    final existingFilter = await FilterService.checkFilterExists(key);
    if (existingFilter != null) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'Фильтр $key уже существует. Посмотреть список созданных фильтров /mfilters',
      );
      await _sendFilterMedia(message.chat.id, message.messageId, existingFilter);
      return;
    }

    if (message.replyToMessage == null) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'Используйте команду ответом на сообщение: /filter <название>',
      );
      return;
    }
    
    final replyMsg = message.replyToMessage!;
    String url = '';
    String mediaType = 'text';
    String description = replyMsg.text ?? '';

    if (replyMsg.photo != null && replyMsg.photo!.isNotEmpty) {
      url = replyMsg.photo!.last.fileId;
      mediaType = 'photo';
    } else if (replyMsg.video != null) {
      url = replyMsg.video!.fileId;
      mediaType = 'video';
    } else if (replyMsg.animation != null) {
      url = replyMsg.animation!.fileId;
      mediaType = 'animation';
    } else if (replyMsg.document != null) {
      url = replyMsg.document!.fileId;
      mediaType = 'document';
    } else if (replyMsg.sticker != null) {
      url = replyMsg.sticker!.fileId;
      mediaType = 'sticker';
    }

    if (url.isEmpty && description.isEmpty) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'Сообщение должно содержать медиа или текст',
      );
      return;
    }

    final filter = FilterModel(
      key: key,
      url: url,
      description: description,
      date: DateTime.now(),
      mediaType: mediaType,
    );

    try {
      final user = message.from!;
      final name = '${user.firstName ?? ''} ${user.lastName ?? ''}'.trim();
      await FilterService.saveFilter(user.id, name, user.username ?? '', filter);
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'Фильтр "$key" сохранён',
      );
    } catch (e) {
      await TeleDartProvider.teleDart!.sendMessage(
        message.chat.id,
        'Ошибка сохранения фильтра',
      );
    }
  }

  Future<void> _checkForFilters(Message message) async {
    if (message.text == null || message.from == null) return;
    
    final filters = await FilterService.getFilters(message.from!.id);
    for (final filter in filters) {
      if (message.text!.contains(filter.key)) {
        await _sendFilterMedia(message.chat.id, message.messageId, filter);
        break;
      }
    }
  }

  Future<void> _sendFilterMedia(int chatId, int replyToId, FilterModel filter) async {
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
