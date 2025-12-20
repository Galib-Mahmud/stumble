import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'tribe_message_model.dart';

class TribeChatApiService {
  /// Get message history for a tribe
  /// Endpoint: GET /api/chatbot/tribes/{id}/messages/
  ///
  /// FIXED: Better response parsing to handle different API response formats
  Future<List<TribeMessage>> getMessageHistory({
    required String baseUrl,
    required String tribeId,
    required String token,
    required String currentUserEmail,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final uri = Uri.parse(
        '$baseUrl/api/chatbot/tribes/$tribeId/messages/?page=$page&page_size=$pageSize',
      );

      print('═══════════════════════════════════════════');
      print('📡 [GET] Fetching message history');
      print('   URL: $uri');
      print('   Page: $page, PageSize: $pageSize');
      print('   User Email: $currentUserEmail');
      print('═══════════════════════════════════════════');

      final response = await http.get(
        uri,
        headers: _buildHeaders(token),
      );

      print('📩 [GET] Response status: ${response.statusCode}');
      print('📩 [GET] Response body preview: ${response.body.substring(0, response.body.length.clamp(0, 500))}...');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Handle different response formats
        List<dynamic> results = [];

        // Format 1: { "results": [...], "count": X, "next": ..., "previous": ... }
        if (data is Map<String, dynamic> && data.containsKey('results')) {
          results = data['results'] as List<dynamic>? ?? [];
          print('📦 Response format: Paginated (results key)');
          print('   Total count: ${data['count']}');
          print('   Has next: ${data['next'] != null}');
        }
        // Format 2: { "success": true, "data": { "messages": [...] } }
        else if (data is Map<String, dynamic> && data['success'] == true) {
          final innerData = data['data'];
          if (innerData is Map<String, dynamic> && innerData.containsKey('messages')) {
            results = innerData['messages'] as List<dynamic>? ?? [];
            print('📦 Response format: Success wrapper with messages');
          } else if (innerData is List) {
            results = innerData;
            print('📦 Response format: Success wrapper with list');
          }
        }
        // Format 3: { "data": [...] }
        else if (data is Map<String, dynamic> && data.containsKey('data')) {
          final innerData = data['data'];
          if (innerData is List) {
            results = innerData;
            print('📦 Response format: Data wrapper');
          } else if (innerData is Map && innerData.containsKey('messages')) {
            results = innerData['messages'] as List<dynamic>? ?? [];
            print('📦 Response format: Data wrapper with messages');
          }
        }
        // Format 4: Direct array response [...]
        else if (data is List) {
          results = data;
          print('📦 Response format: Direct array');
        }
        // Format 5: { "messages": [...] }
        else if (data is Map<String, dynamic> && data.containsKey('messages')) {
          results = data['messages'] as List<dynamic>? ?? [];
          print('📦 Response format: Messages key');
        }

        print('📊 Parsed ${results.length} messages from response');

        if (results.isEmpty) {
          print('⚠️ No messages found in response');
          return [];
        }

        // Parse messages
        final messages = results.map((json) {
          try {
            return TribeMessage.fromJson(json as Map<String, dynamic>, currentUserEmail);
          } catch (e) {
            print('❌ Error parsing message: $e');
            print('   Raw JSON: $json');
            return null;
          }
        }).whereType<TribeMessage>().toList();

        // Sort by created_at (oldest first for display)
        messages.sort((a, b) => a.createdAt.compareTo(b.createdAt));

        print('✅ Successfully parsed ${messages.length} messages');
        return messages;
      } else if (response.statusCode == 401) {
        print('❌ Unauthorized - token may be expired');
        throw Exception('Unauthorized - Please login again');
      } else if (response.statusCode == 404) {
        print('❌ Tribe not found: $tribeId');
        throw Exception('Chat room not found');
      } else {
        print('❌ API Error: ${response.statusCode}');
        print('   Body: ${response.body}');
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('❌ Network error: $e');
      throw Exception('Network error - Please check your connection');
    } on FormatException catch (e) {
      print('❌ JSON parsing error: $e');
      throw Exception('Invalid response format from server');
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
      final uri = Uri.parse('$baseUrl/api/chatbot/tribes/$tribeId/upload/');

      print('═══════════════════════════════════════════');
      print('📡 [POST] Uploading file');
      print('   URL: $uri');
      print('   File: ${file.path}');
      print('   File size: ${await file.length()} bytes');
      print('═══════════════════════════════════════════');

      final request = http.MultipartRequest('POST', uri);
      request.headers.addAll({
        'Authorization': 'Bearer $token',
      });

      // Get file extension and determine content type
      final fileName = file.path.split('/').last;
      final extension = fileName.split('.').last.toLowerCase();

      String contentType = 'application/octet-stream';
      if (['jpg', 'jpeg'].contains(extension)) {
        contentType = 'image/jpeg';
      } else if (extension == 'png') {
        contentType = 'image/png';
      } else if (extension == 'gif') {
        contentType = 'image/gif';
      } else if (extension == 'webp') {
        contentType = 'image/webp';
      }

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: fileName,
      ));

      print('📤 Sending file upload request...');
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('📩 [POST] Upload response status: ${response.statusCode}');
      print('📩 [POST] Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Try different response formats
        String? fileUrl;

        if (data is Map<String, dynamic>) {
          fileUrl = data['file_url'] as String? ??
              data['url'] as String? ??
              data['data']?['file_url'] as String? ??
              data['data']?['url'] as String?;
        }

        if (fileUrl != null) {
          print('✅ File uploaded successfully: $fileUrl');
          return fileUrl;
        } else {
          print('❌ No file URL in response');
          throw Exception('No file URL returned from server');
        }
      } else if (response.statusCode == 413) {
        throw Exception('File too large. Please choose a smaller image.');
      } else if (response.statusCode == 415) {
        throw Exception('Unsupported file type');
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
      final uri = Uri.parse('$baseUrl/api/chatbot/support/request/');

      print('📡 [POST] Requesting support: $uri');
      print('   Mode: ${mode.name}');

      final response = await http.post(
        uri,
        headers: _buildHeaders(token),
        body: jsonEncode({
          'mode': mode.name,
          'message': message,
          'tribe_id': tribeId,
        }),
      );

      print('📩 [POST] Support response status: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      'Accept': 'application/json',
    };
  }
}