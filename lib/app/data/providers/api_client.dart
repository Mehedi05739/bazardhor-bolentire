import 'dart:convert';

import 'package:http/http.dart' as http;

/// A thin wrapper around the `http` package that centralizes the base URL,
/// default headers, auth token, timeouts and JSON decoding for the whole app.
///
/// Registered as a permanent dependency in [InitialBinding] so any repository
/// can obtain it via `Get.find<ApiClient>()`. The bearer token is read lazily
/// through [tokenProvider] on every request, so freshly stored tokens are
/// picked up automatically without re-creating the client.
class ApiClient {
  ApiClient({
    required this.baseUrl,
    this.tokenProvider,
    this.zoneIdProvider,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final String? Function()? tokenProvider;
  final String? Function()? zoneIdProvider;
  final http.Client _client;

  static const Duration _timeout = Duration(seconds: 30);

  Map<String, String> get _defaultHeaders {
    final token = tokenProvider?.call();
    final zoneId = zoneIdProvider?.call();
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      if (zoneId != null && zoneId.isNotEmpty) 'zoneId': zoneId,
    };
  }

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

  /// Decodes the body and throws [ApiException] on non-2xx responses. The API
  /// wraps payloads in a `{response_code, message, data, errors}` envelope; the
  /// human-readable `message` is surfaced on failure.
  dynamic _process(http.Response response) {
    final status = response.statusCode;
    final dynamic decoded =
        response.body.isEmpty ? null : jsonDecode(response.body);

    if (status >= 200 && status < 300) return decoded;

    String message = 'Request failed with status $status';
    if (decoded is Map && decoded['message'] != null) {
      message = '${decoded['message']}';
    }

    throw ApiException(statusCode: status, message: message);
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
