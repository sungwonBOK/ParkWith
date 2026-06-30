import 'dart:convert';
import 'dart:io';

abstract class ApiClient {
  Future<Map<String, Object?>> getJson(String path);
}

class HttpApiClient implements ApiClient {
  HttpApiClient({
    required Uri baseUrl,
    HttpClient? httpClient,
  })  : _baseUrl = baseUrl,
        _httpClient = httpClient ?? HttpClient();

  final Uri _baseUrl;
  final HttpClient _httpClient;

  @override
  Future<Map<String, Object?>> getJson(String path) async {
    final request = await _httpClient.getUrl(_baseUrl.resolve(path));
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');

    final response = await request.close();
    final body = await utf8.decoder.bind(response).join();

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const ApiException('Request failed.');
    }

    final decoded = jsonDecode(body);
    if (decoded is Map<String, Object?>) {
      return decoded;
    }

    throw const ApiException('Invalid response.');
  }
}

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}
