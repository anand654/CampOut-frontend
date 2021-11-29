import 'package:auth/auth.dart';

abstract class ILocalStore {
  Future<void> save(AuthUserInfo token);
  Future<Token> fetchtoken();
  Future<List<String>> fetchUserInfo();
  Future<void> delete();
}
