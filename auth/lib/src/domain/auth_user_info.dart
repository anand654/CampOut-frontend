import 'package:auth/auth.dart';

class AuthUserInfo {
  final Token token;
  final String name;
  final String email;
  final String profileImg;
  AuthUserInfo({this.token, this.name, this.email, this.profileImg});
}
