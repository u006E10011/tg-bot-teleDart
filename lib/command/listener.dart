import 'package:teledart/teledart.dart';
import 'package:telegram_bot/command/command.dart';

class Listener {
  final TeleDart _teleDart;

  Listener(this._teleDart);

  Listener init()
  {
    start();
    info();
    return this;
  }

  void start() {
    _teleDart.onMessage(entityType: 'bot_command', keyword: 'start').listen(
    (message) => _teleDart.sendMessage(message.chat.id, "GitHub: https://github.com/u006E10011/tg-bot-teleDart"),);
  }

  void info() {
    _teleDart.onMessage(entityType: 'bot_command', keyword: 'info').listen(
    (message) => _teleDart.sendMessage(message.chat.id, "NullReferenceException"),);
  }
}
