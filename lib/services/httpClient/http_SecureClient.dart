import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:me_and_my_tent_client/cache/local_store_contract.dart';
import 'package:me_and_my_tent_client/services/httpClient/http_client_contract.dart';

class SecureClient implements IHttpClient {
  final http.Client _client;
  final ILocalStore _localStore;
  SecureClient(this._client, this._localStore);

  @override
  Future<HttpResult> get(Uri url) async {
    final token = await _localStore.fetchtoken();
    final modifiedHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.value}'
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

  @override
  Future<HttpResult> post(Uri url, String body) async {
    final token = await _localStore.fetchtoken();
    final modifiedHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.value}'
    };
    try {
      final response =
          await _client.post(url, headers: modifiedHeaders, body: body);
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HttpResult(data, _setstatus(response));
    } catch (e) {
      return HttpResult(
          {'error': 'Error connecting to server'}, Status.failure);
    }
  }

  @override
  Future<HttpResult> delete(Uri url, [String body]) async {
    final token = await _localStore.fetchtoken();
    final modifiedHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.value}'
    };
    final modifiedBody = body ?? jsonEncode({'body': 'dummy body'});
    try {
      final response = await _client.delete(
        url,
        headers: modifiedHeaders,
        body: modifiedBody,
      );
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HttpResult(data, _setstatus(response));
    } catch (e) {
      return HttpResult(
          {'error': 'Error connecting to server'}, Status.failure);
    }
  }

  @override
  Future<HttpResult> patch(Uri url, [String body]) async {
    final token = await _localStore.fetchtoken();
    final modifiedHeaders = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${token.value}'
    };
    final modifiedBody = body ?? jsonEncode({'body': 'dummy body'});
    try {
      final response = await _client.patch(url,
          headers: modifiedHeaders, body: modifiedBody);
      final Map<String, dynamic> data = jsonDecode(response.body);
      return HttpResult(data, _setstatus(response));
    } catch (err) {
      return HttpResult(
          {'error': 'Error connecting to server'}, Status.failure);
    }
  }

  @override
  Future<HttpResult> multiPartRequest(Uri url, List<String> imagePath) async {
    final token = await _localStore.fetchtoken();
    final Map<String, String> modifiedHeaders = {
      'Content-Type': 'multipart/form-data',
      'Authorization': 'Bearer ${token.value}'
    };
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(modifiedHeaders);
    for (String path in imagePath) {
      request.files.add(await http.MultipartFile.fromPath(
        'photos',
        path,
      ));
    }
    try {
      var response = await _client.send(request);
      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var result = String.fromCharCodes(responseData);
        return HttpResult(
          jsonDecode(result),
          Status.success,
        );
      } else {
        return HttpResult(
          {'message': 'Failed to Upload the images'},
          Status.failure,
        );
      }
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
