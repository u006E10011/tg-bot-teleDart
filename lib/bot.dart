import 'dart:io';

import 'package:teledart/teledart.dart';
import 'package:teledart/telegram.dart';
import 'package:telegram_bot/command/command.dart';
import 'package:telegram_bot/token.dart';

Future<void> main() async 
{
  final token = await Token.importToken();
  final username = (await Telegram(token).getMe()).username;
  var teledart = TeleDart(token, Event(username!));

  teledart.start();
  teledart.setMyShortDescription("The bot is written in Dart", "ru");
  stdout.write("Starting bot");

  Command(teledart).initCommand();
}