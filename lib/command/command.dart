import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:telegram_bot/command/listener.dart';

class Command {
  TeleDart? _teleDart;
  TeleDart? get teleDart => _teleDart;
  Listener? listener;

  Command(TeleDart teleDart)
  {
    _teleDart = teleDart;
    listener = Listener().addListeners(teleDart);
  }

  void initCommand() {
    _teleDart!.setMyCommands([
      BotCommand(command: "/start", description: "Start"),
      BotCommand(command: "/info", description: "Information"),
    ]);
  }
}
