import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../route/route_name.dart';


class ForgetPassController extends GetxController {
  final emailController = TextEditingController();

  // Initialize ApiClient with base URL
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  Future<void> forgetPass() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email");
      return;
    }

    try {
      print("🌐 [FORGET PASSWORD] Sending request using ApiClient...");

      // Use ApiClient’s post() method
      final response = await _apiClient.post(
        ApiEndpoint.forgetPass, // e.g. "/api/forget-password/"
        body: {"email": email},
      );

      print("✅ [FORGET PASSWORD] Response received: $response");

      // Extract reset token safely
      final resetToken = response['data']?['reset_token'];

      if (resetToken != null) {
        UserInfo.ResetToken(resetToken);
        Get.toNamed(RouteName.resetPassword);

      } else {
        print("⚠️ [FORGET PASSWORD] Reset token missing in response");
        Get.snackbar("Error", "Invalid response from server");
      }
    } catch (e) {
      print("🔥 [FORGET PASSWORD] Exception caught: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      emailController.clear();
    }
  }
}