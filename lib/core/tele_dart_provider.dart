import 'package:teledart/teledart.dart';

class TeleDartProvider
{
  static TeleDart? _teleDart;

  static TeleDart? get teleDart => _teleDart;

  TeleDartProvider(TeleDart teleDart){
    _teleDart = teleDart; 
  }
}