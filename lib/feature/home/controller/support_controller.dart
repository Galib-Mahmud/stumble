import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart' as local_storage;
import '../../splash/screen/app_notification.dart';

class SupportController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);
  final isLoading = false.obs;

  Future<bool> requestSupport(String mode) async {
    isLoading.value = true;


    try {
      print("🌐 [SUPPORT] Requesting $mode support...");
      final token = await local_storage.UserInfo.getAccessToken();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Please login again.");
        isLoading.value = false;
        return false;
      }

      final response = await _apiClient.post(
        ApiEndpoint.supportRequest, // Add this endpoint to your ApiEndpoint class
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },

        body: {
          "mode": mode,
        },
      );

      print("✅ [SUPPORT] Response: $response");

      if (response['success'] == true) {
        final message = response['message'] ?? 'Support requested successfully';
        _showTransparentSnackbar(message);
        return true;
      } else {
        AppNotification.error(response['message'] ?? 'Failed to request support');
        return false;
      }
    } catch (e) {
      print("🔥 [SUPPORT] Exception caught: $e");
      AppNotification.error(e.toString());
      return false;
    } finally {
      print("🔚 [SUPPORT] Request finished");
      isLoading.value = false;
    }
  }

  void _showTransparentSnackbar(String message) {
    Get.rawSnackbar(
      message: message,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.black.withOpacity(0.7),
      margin: const EdgeInsets.all(16),
      borderRadius: 12,
      snackPosition: SnackPosition.TOP,
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}