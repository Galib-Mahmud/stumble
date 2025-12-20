import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _httpClient;

  ApiClient({required this.baseUrl, http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  final Map<String, String> _defaultHeader = {
    "Accept": "application/json",
    "Content-Type": "application/json",
  };

  /// GET request
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    print("🌐 [GET] URL: $url");
    print("📋 [GET] Headers: $mergedHeaders");

    final response = await _httpClient.get(url, headers: mergedHeaders);
    return _handleResponse(response, url, method: "GET");
  }

  /// POST request
  Future<dynamic> post(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    print("🌐 [POST] URL: $url");
    print("📋 [POST] Headers: $mergedHeaders");
    print("📦 [POST] Body: $body");

    final response =
    await _httpClient.post(url, headers: mergedHeaders, body: encodedBody);
    return _handleResponse(response, url, method: "POST");
  }

  /// DELETE request
  Future<dynamic> delete(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    print("🌐 [DELETE] URL: $url");
    print("📋 [DELETE] Headers: $mergedHeaders");
    print("📦 [DELETE] Body: $body");

    final response = await _httpClient.delete(
      url,
      headers: mergedHeaders,
      body: encodedBody,
    );
    return _handleResponse(response, url, method: "DELETE");
  }

  /// PATCH request
  Future<dynamic> patch(
      String endpoint, {
        Map<String, String>? headers,
        dynamic body,
      }) async {
    final url = Uri.parse('$baseUrl$endpoint');
    final mergedHeaders = {..._defaultHeader, ...?headers};
    final encodedBody = body != null ? jsonEncode(body) : null;

    print("🌐 [PATCH] URL: $url");
    print("📋 [PATCH] Headers: $mergedHeaders");
    print("📦 [PATCH] Body: $body");

    final response = await _httpClient.patch(
      url,
      headers: mergedHeaders,
      body: encodedBody,
    );
    return _handleResponse(response, url, method: "PATCH");
  }

  /// Handle all HTTP responses with debug logs
  dynamic _handleResponse(http.Response response, Uri url,
      {required String method}) {
    print("📩 [$method] Response Code: ${response.statusCode}");
    print("📩 [$method] Raw Response Body: ${response.body}");

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) {
        print("✅ [$method] Empty success response");
        return null;
      }
      try {
        final decoded = jsonDecode(response.body);
        print("✅ [$method] Decoded Response: $decoded");
        return decoded;
      } catch (e) {
        print("❌ [$method] JSON Decode Error: $e");
        throw HttpException(
          message: "Invalid JSON format",
          statusCode: response.statusCode,
          uri: url,
          body: response.body,
        );
      }
    } else {
      print("🚫 [$method] Request Failed");
      throw HttpException(
        message: "Request failed",
        statusCode: response.statusCode,
        uri: url,
        body: response.body,
      );
    }
  }
}

class HttpException implements Exception {
  final String message;
  final int statusCode;
  final Uri uri;
  final String? body;

  HttpException({
    required this.message,
    required this.statusCode,
    required this.uri,
    this.body,
  });

  @override
  String toString() {
    return " message: $message, body: $body)";
  }
}