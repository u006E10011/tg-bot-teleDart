import 'dart:io';

class Token
{
  static Future<String> importToken() async {
    File env = File("./.env");
    return await env.readAsString();
  }
}