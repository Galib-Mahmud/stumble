import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'tribe_message_model.dart';

class TribeChatApiService {
  /// Get message history for a tribe
  /// Endpoint: GET /api/chatbot/tribes/{id}/messages/
  Future<List<TribeMessage>> getMessageHistory({
    required String baseUrl,
    required String tribeId,
    required String token,
    required String currentUserEmail,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      // FIXED: Added /api/ prefix as per integration guide
      final uri = Uri.parse(
        '$baseUrl/api/chatbot/tribes/$tribeId/messages/?page=$page&page_size=$pageSize',
      );

      print('📡 [GET] Fetching message history: $uri');

      final response = await http.get(
        uri,
        headers: _buildHeaders(token),
      );

      print('📩 [GET] Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final results = data['results'] as List<dynamic>? ?? data as List<dynamic>;

        return results
            .map((json) => TribeMessage.fromJson(json, currentUserEmail))
            .toList()
            .reversed // API returns newest first, we want oldest first
            .toList();
      } else {
        throw Exception('Failed to load messages: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Error fetching message history: $e');
      rethrow;
    }
  }

  /// Upload a file to the tribe chat
  /// Endpoint: POST /api/chatbot/tribes/{id}/upload/
  Future<String?> uploadFile({
    required String baseUrl,
    required String tribeId,
    required String token,
    required File file,
  }) async {
    try {
      // FIXED: Added /api/ prefix
      final uri = Uri.parse('$baseUrl/api/chatbot/tribes/$tribeId/upload/');

      print('📡 [POST] Uploading file to: $uri');

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll(_buildHeaders(token));
      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📩 [POST] Upload response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return data['file_url'] as String?;
      } else {
        throw Exception('Failed to upload file: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error uploading file: $e');
      rethrow;
    }
  }

  /// Request support
  /// Endpoint: POST /api/chatbot/support/request/
  Future<SupportResponse> requestSupport({
    required String baseUrl,
    required String token,
    required int tribeId,
    required SupportMode mode,
    required String message,
  }) async {
    try {
      // FIXED: Added /api/ prefix
      final uri = Uri.parse('$baseUrl/api/chatbot/support/request/');

      print('📡 [POST] Requesting support: $uri');

      final response = await http.post(
        uri,
        headers: _buildHeaders(token),
        body: jsonEncode({
          'mode': mode.name, // gentle, critical, urgent
          'message': message,
          'tribe_id': tribeId,
        }),
      );

      print('📩 [POST] Support response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        return SupportResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to request support: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error requesting support: $e');
      rethrow;
    }
  }

  /// Get support history
  /// Endpoint: GET /api/chatbot/support/history/
  Future<List<Map<String, dynamic>>> getSupportHistory({
    required String baseUrl,
    required String token,
  }) async {
    try {
      // FIXED: Added /api/ prefix
      final uri = Uri.parse('$baseUrl/api/chatbot/support/history/');

      final response = await http.get(
        uri,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['results'] ?? data);
      } else {
        throw Exception('Failed to get support history: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching support history: $e');
      rethrow;
    }
  }

  /// Get list of available bots
  /// Endpoint: GET /api/chatbot/bots/
  Future<List<Map<String, dynamic>>> getBots({
    required String baseUrl,
    required String token,
  }) async {
    try {
      // FIXED: Added /api/ prefix
      final uri = Uri.parse('$baseUrl/api/chatbot/bots/');

      final response = await http.get(
        uri,
        headers: _buildHeaders(token),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data['results'] ?? data);
      } else {
        throw Exception('Failed to get bots: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error fetching bots: $e');
      rethrow;
    }
  }

  /// Build headers with authorization
  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}