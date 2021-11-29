import 'package:auth/src/domain/credential.dart';

class Mapper {
  static tojson(Credential credential) => {
        "authType": credential.type.toString().split('.').last,
        "name": credential.name,
        "email": credential.email,
      };
}
