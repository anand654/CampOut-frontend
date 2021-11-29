import 'dart:convert';

import 'package:auth/src/domain/credential.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:auth/src/infra/api/auth_api_contract.dart';

import 'mapper.dart';

class AuthApi implements IAuthApi {
  final http.Client _client;
  String baseUrl;
  AuthApi(
    this.baseUrl,
    this._client,
  );

  @override
  Future<Result<String>> signIn(Credential credential) async {
    var endPoint = Uri.parse('$baseUrl/api/v1/auth/signin');
    return await _postCredential(endPoint, credential);
  }

  Future<Result<String>> _postCredential(
      Uri endPoint, Credential credential) async {
    try {
      var responce = await _client.post(endPoint,
          body: jsonEncode(Mapper.tojson(credential)),
          headers: {"Content-type": "application/json"});
      if (responce.statusCode != 200) return Result.error('Server Error');
      var json = jsonDecode(responce.body);
      return json['auth_token'] != null
          ? Result.value(json['auth_token'])
          : Result.error(json['message']);
    } catch (err) {
      return Result.error({'error': err});
    }
  }

  @override
  Future<Result<bool>> signout(String token) async {
    var endPoint = Uri.parse('$baseUrl/api/v1/auth/signout');
    var headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token'
    };
    try {
      var response = await _client.post(endPoint, headers: headers);
      if (response.statusCode != 200) return Result.value(false);
      return Result.value(true);
    } catch (err) {
      return Result.error({'error': err});
    }
  }

  @override
  Future<Result<bool>> signInState(String token) async {
    var endPoint = Uri.parse('$baseUrl/api/v1/auth/signinstate');
    var headers = {
      "Content-type": "application/json",
      "Authorization": 'Bearer $token'
    };
    try {
      var response = await _client.get(endPoint, headers: headers);
      if (response.statusCode == 403) return Result.value(false);
      return Result.value(true);
    } catch (err) {
      return Result.error({'error': err});
    }
  }
}
