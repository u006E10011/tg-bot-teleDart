import 'package:teledart/teledart.dart';

class Listener {
  
  final Map<String, String> command = {
    "start": "GitHub: https://github.com/u006E10011/tg-bot-teleDart",
    "info": "NullReferenceException",
    "filter": "Add new filter"
  };

  Listener addListeners(TeleDart teleDart)
  {
    command.forEach((key, value) => teleDart.onCommand(key)
      .listen((message) => message.reply(value)));

    return this;
  }
}
