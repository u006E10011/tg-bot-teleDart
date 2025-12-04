import 'package:teledart/model.dart';
import 'package:teledart/teledart.dart';

class CommandHandler {
  static TeleDart? _teleDart;
  static TeleDart? get teleDart => _teleDart;

  static void init(TeleDart teledart)
  {
    _teleDart = teledart;
  }

  static void initCommand() {
    _teleDart!.setMyCommands([
      BotCommand(command: "/start", description: "Start"),
      BotCommand(command: "/info", description: "Information"),
    ]);
  }
}
