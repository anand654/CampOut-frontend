import 'package:auth/src/domain/credential.dart';
import 'package:auth/src/infra/api/auth_api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

void main() {
  AuthApi sut;
  http.Client _client;
  String baseUrl = 'http://localhost:3000';
  setUp(() {
    _client = http.Client();
    sut = AuthApi(baseUrl, _client);
  });
// setup and group are 2 different function , first i wrote group function inside the setup function
  group('signin', () {
    test('should return json web token when successful', () async {
      var credential = Credential(
          type: AuthType.google, name: 'hello345', email: 'hello345@email.com');

      // act
      var result = await sut.signIn(credential);
      // assert
      expect(result.asValue.value, isNotEmpty);
    });
  });
}
