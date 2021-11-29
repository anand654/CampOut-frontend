import 'package:flutter/foundation.dart';

class Credential {
  final AuthType type;
  final String name;
  final String email;

  Credential({
    @required this.type,
    this.name,
    @required this.email,
  });
}

enum AuthType { email, google }
