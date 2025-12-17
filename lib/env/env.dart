import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'TOKEN', obfuscate: true)
  static final String token = _Env.token;

  @EnviedField(varName: 'ADMIN', obfuscate: true)
  static final String admin = _Env.admin;
}
