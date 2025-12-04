import 'package:teledart/teledart.dart';

class Listener {
  
  final Map<String, String> command = {
    "start": "GitHub: https://github.com/u006E10011/tg-bot-teleDart",
    "info": "NullReferenceException"
  };

  Listener addListeners(TeleDart teleDart)
  {
    command.forEach((key, value) => teleDart.onMessage(entityType: "bot_command", keyword: key).listen(
      (message) => teleDart.sendMessage(message.chat.id, value),));

      return this;
  }
}
