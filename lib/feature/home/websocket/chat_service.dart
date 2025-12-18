import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stumble/core/endpoint/api_client.dart';
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/core/local_storage/user_info.dart';
import 'package:stumble/route/route_name.dart';

/// ChatService - Fetches user's tribe and navigates to chat
class ChatService {
  // Use your existing ApiClient
  static final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  /// Navigate to tribe chat - fetches user's tribe dynamically
  static Future<void> goToTribeChat() async {
    print('═══════════════════════════════════════════');
    print('🚀 [ChatService] Starting goToTribeChat()');
    print('═══════════════════════════════════════════');

    try {
      // Show loading
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
        barrierColor: Colors.black54,
      );

      // Step 1: Get access token
      print('📌 [Step 1] Getting access token...');
      final accessToken = await UserInfo.getAccessToken();

      if (accessToken == null || accessToken.isEmpty) {
        print('❌ [Step 1] FAILED - No access token found');
        _closeLoadingAndShowError('Please login again');
        return;
      }
      print('✅ [Step 1] Token found (length: ${accessToken.length})');

      // Step 2: Fetch user's tribes using ApiClient
      print('📌 [Step 2] Fetching tribes from API...');
      print('   Endpoint: /api/chatbot/tribes/user/');

      final response = await _apiClient.get(
        '/api/chatbot/tribes/user/',
        headers: {
          'Authorization': 'Bearer $accessToken',
        },
      );

      print('✅ [Step 2] Response received: $response');

      // Step 3: Extract tribe info
      print('📌 [Step 3] Extracting tribe info...');

      if (response == null || response['success'] != true || response['data'] == null) {
        print('❌ [Step 3] FAILED - Invalid response format');
        _closeLoadingAndShowError('Failed to load tribes');
        return;
      }

      final responseData = response['data'];
      Map<String, dynamic>? tribeData;

      // Try to get primary_tribe first
      if (responseData['primary_tribe'] != null) {
        tribeData = responseData['primary_tribe'];
        print('✅ [Step 3] Found primary_tribe');
      }
      // Fallback to first tribe in list
      else if (responseData['tribes'] != null &&
          (responseData['tribes'] as List).isNotEmpty) {
        tribeData = responseData['tribes'][0];
        print('✅ [Step 3] Using first tribe from list');
      }

      if (tribeData == null) {
        print('❌ [Step 3] FAILED - No tribe found for user');
        _closeLoadingAndShowError('No tribe found. Complete onboarding first.');
        return;
      }

      print('📦 [Step 3] Tribe data: $tribeData');

      // Step 4: Extract values
      print('📌 [Step 4] Extracting values...');

      final tribe = tribeData['tribe'] as Map<String, dynamic>?;
      if (tribe == null) {
        print('❌ [Step 4] FAILED - No tribe object in response');
        _closeLoadingAndShowError('Invalid tribe data');
        return;
      }

      final String tribeId = tribe['id'].toString();
      final String tribeName = tribe['display_name']?.toString() ??
          tribe['name']?.toString() ??
          'Chat';
      final String userEmail = tribeData['user_email']?.toString() ?? '';
      final bool isUnlocked = tribeData['is_unlocked'] ?? false;

      print('✅ [Step 4] Extracted values:');
      print('   - Tribe ID: $tribeId');
      print('   - Tribe Name: $tribeName');
      print('   - User Email: $userEmail');
      print('   - Is Unlocked: $isUnlocked');

      // Close loading
      Get.back();

      // Step 5: Navigate to chat
      print('📌 [Step 5] Navigating to chat screen...');

      Get.toNamed(
        RouteName.innerCircleChat,
        arguments: {
          'tribeId': tribeId,
          'tribeName': tribeName,
          'apiBaseUrl': ApiEndpoint.baseUrl,
          'accessToken': accessToken,
          'currentUserEmail': userEmail,
        },
      );

      print('✅ [Step 5] Navigation called successfully');
      print('═══════════════════════════════════════════');

    } catch (e, stackTrace) {
      print('❌ [ChatService] EXCEPTION: $e');
      print('📜 Stack trace: $stackTrace');
      _closeLoadingAndShowError('Error: ${e.toString()}');
    }
  }

  /// Helper to close loading and show error
  static void _closeLoadingAndShowError(String message) {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
    Get.snackbar(
      'Error',
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red.withOpacity(0.9),
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }
}