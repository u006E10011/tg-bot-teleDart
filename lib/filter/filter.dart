// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:convert';
import 'dart:io';
import 'package:telegram_bot/filter/filter_data.dart';
import 'package:telegram_bot/tele_dart_provider.dart';

import 'package:teledart/model.dart' as teleDart;

class Filter
{
  void save(teleDart.Update update, String filter) async {
    var data = File("./data/user/${update.message!.from!.id}.json");

    if (filter.isNotEmpty && filter.startsWith("/filter")) {
      final command = filter.split("/filter")[1].trimLeft();

      if(data.readAsString().toString().contains(command))
      {
        TeleDartProvider.teleDart!.sendMessage(update.message!.chat.id, "Filter exists: $command");
        return;
      }
      else
      {
        await data.writeAsString(json.encode(buildFilterData(update.message!, command)));
      }
    }
  }

  FilterData buildFilterData(teleDart.Message message, String command){
    var (type, id) = getMessageInfo(message);

    return FilterData(
      command: command,
      type: type,
      id: id,
      text: message.text!,
      createdAt: message.date_
      );
  }

  (String type, String url)  getMessageInfo(teleDart.Message message){
    if(message.photo != null)
      return ("photo", message.photo![0].fileId);
    else if(message.sticker != null)
      return ("sticker", message.sticker!.fileId);
    else if(message.animation != null)
      return ("animation", message.animation!.fileId);
    else if(message.video != null)
      return ("video", message.video!.fileId);
    else if(message.document != null)
      return ("document", message.document!.fileId);

    return ("null", "null");
  }
}
