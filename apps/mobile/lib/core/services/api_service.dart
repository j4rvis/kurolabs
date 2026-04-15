import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

/// HTTP client that communicates with the Next.js API layer.
/// All requests are authenticated with the Supabase JWT as a Bearer token.
class ApiService {
  ApiService._();

  static const _baseUrl = String.fromEnvironment('API_BASE_URL');

  static String? get _accessToken =>
      Supabase.instance.client.auth.currentSession?.accessToken;

  static Map<String, String> get _headers {
    final token = _accessToken;
    if (token == null) throw Exception('Not authenticated');
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  static Uri _uri(String path, {Map<String, String>? queryParams}) {
    final base = Uri.parse(_baseUrl);
    return base.replace(
      path: '${base.path}$path',
      queryParameters: queryParams,
    );
  }

  static Future<dynamic> get(String path, {Map<String, String>? queryParams}) async {
    final response = await http.get(_uri(path, queryParams: queryParams), headers: _headers);
    return _parse(response);
  }

  static Future<dynamic> post(String path, [Map<String, dynamic>? body]) async {
    final response = await http.post(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body ?? {}),
    );
    return _parse(response);
  }

  static Future<dynamic> patch(String path, Map<String, dynamic> body) async {
    final response = await http.patch(
      _uri(path),
      headers: _headers,
      body: jsonEncode(body),
    );
    return _parse(response);
  }

  static Future<dynamic> delete(String path) async {
    final response = await http.delete(_uri(path), headers: _headers);
    return _parse(response);
  }

  static dynamic _parse(http.Response response) {
    final body = jsonDecode(response.body);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    final message = body is Map ? (body['error'] ?? 'Request failed') : 'Request failed';
    throw Exception(message);
  }
}
