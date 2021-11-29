abstract class IHttpClient {
  Future<HttpResult> get(Uri url);
  Future<HttpResult> post(Uri url, String body);
  Future<HttpResult> patch(Uri url, [String body]);
  Future<HttpResult> delete(Uri url, [String body]);
  Future<HttpResult> multiPartRequest(Uri url, List<String> imagePath);
}

abstract class IPublicClient {
  Future<HttpResult> get(Uri url);
}

class HttpResult {
  final Map<String, dynamic> body;
  final Status status;
  const HttpResult(this.body, this.status);
}

enum Status { success, failure, exist }
