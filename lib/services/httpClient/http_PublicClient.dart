import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:me_and_my_tent_client/services/httpClient/http_client_contract.dart';

class PublicClient implements IPublicClient {
  final http.Client _client;
  PublicClient(this._client);

  @override
  Future<HttpResult> get(Uri url) async {
    final modifiedHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };
    try {
      final response = await _client.get(url, headers: modifiedHeaders);
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HttpResult(data, _setstatus(response));
    } catch (e) {
      return HttpResult(
          {'error': 'Error connecting to server'}, Status.failure);
    }
  }

  Status _setstatus(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201)
      return Status.success;
    if (response.statusCode == 408) return Status.exist;
    return Status.failure;
  }
}
