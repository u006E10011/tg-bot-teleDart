import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';
import 'package:telegram_bot/util.dart';

class Command {
  TeleDart? _teleDart;
  TeleDart? get teleDart => _teleDart;
  Listener? listener;

  Command(TeleDart teleDart) {
    _teleDart = teleDart;
    listener = Listener().addListeners(teleDart);
  }

  void initCommand() {
    _teleDart!.setMyCommands([
      BotCommand(command: "/start", description: "Start"),
      BotCommand(command: "/info", description: "Information"),
      BotCommand(command: "/fc", description: "Create chat filter"),
      BotCommand(command: "/fs", description: "Show chat filters"),
      BotCommand(command: "/mf", description: "Use personal filter"),
      BotCommand(command: "/mfc", description: "Create personal filter"),
      BotCommand(command: "/mfs", description: "Show personal filters"),
    ]);
  }
}
