import 'dart:io';
import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import './command/command.dart';
import 'package:telegram_bot/token.dart';
import './tele_dart_provider.dart';

Future<void> main() async 
{
  final token = await Token.importToken();
  final bot = await Telegram(token).getMe();
  var teledart = TeleDart(token, Event(bot.username!));

  teledart.start();
  teledart.setMyShortDescription("The bot is written in Dart", "ru");
  stdout.write("Starting bot: ${bot.firstName}(${bot.username})");

  TeleDartProvider(teledart);
  Command(teledart).initCommand();
}
