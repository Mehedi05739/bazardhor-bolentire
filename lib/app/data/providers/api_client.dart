import 'dart:convert';

import 'package:http/http.dart' as http;

/// A thin wrapper around the `http` package that centralizes the base URL,
/// default headers, timeouts and JSON decoding for the whole app.
///
/// Registered as a permanent dependency in [InitialBinding] so any repository
/// can obtain it via `Get.find<ApiClient>()`.
class ApiClient {
  ApiClient({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  static const Duration _timeout = Duration(seconds: 30);

  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    // Add auth tokens here, e.g. 'Authorization': 'Bearer $token'.
  };

  Uri _uri(String path, [Map<String, dynamic>? query]) {
    final normalized = path.startsWith('/') ? path.substring(1) : path;
    return Uri.parse('$baseUrl/$normalized').replace(
      queryParameters: query?.map((k, v) => MapEntry(k, '$v')),
    );
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _client
        .get(_uri(path, query), headers: _defaultHeaders)
        .timeout(_timeout);
    return _process(response);
  }

  Future<dynamic> post(String path, {Object? body}) async {
    final response = await _client
        .post(_uri(path), headers: _defaultHeaders, body: jsonEncode(body))
        .timeout(_timeout);
    return _process(response);
  }

  Future<dynamic> put(String path, {Object? body}) async {
    final response = await _client
        .put(_uri(path), headers: _defaultHeaders, body: jsonEncode(body))
        .timeout(_timeout);
    return _process(response);
  }

  Future<dynamic> delete(String path) async {
    final response = await _client
        .delete(_uri(path), headers: _defaultHeaders)
        .timeout(_timeout);
    return _process(response);
  }

  /// Decodes the body and throws [ApiException] on non-2xx responses.
  dynamic _process(http.Response response) {
    final status = response.statusCode;
    final dynamic decoded =
        response.body.isEmpty ? null : jsonDecode(response.body);

    if (status >= 200 && status < 300) return decoded;

    throw ApiException(
      statusCode: status,
      message: decoded is Map && decoded['message'] != null
          ? '${decoded['message']}'
          : 'Request failed with status $status',
    );
  }

  void dispose() => _client.close();
}

/// Error type surfaced by [ApiClient] so controllers can react to failures.
class ApiException implements Exception {
  ApiException({required this.statusCode, required this.message});

  final int statusCode;
  final String message;

  @override
  String toString() => 'ApiException($statusCode): $message';
}
