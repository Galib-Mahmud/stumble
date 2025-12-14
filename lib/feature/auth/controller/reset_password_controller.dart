import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../route/route_name.dart';

class ResetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Initialize ApiClient with your base URL
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  Future<void> resetPassword() async {
    // ✅ Await the token since it returns a Future
    final resetToken = await UserInfo.getResetToken();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    print("🔑 [RESET PASSWORD] Reset Token: $resetToken");

    // Validation
    if (password.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    try {
      print("🌐 [RESET PASSWORD] Sending request using ApiClient...");
      final response = await _apiClient.post(
        ApiEndpoint.resetPass,
        body: {
          "reset_token": resetToken,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );

      print("📩 [RESET PASSWORD] Response: $response");

      final bool success = response["success"] == true || response["status"] == true;
      final String message = response["message"] ?? "No message received";

      if (success) {
        print("🟢 [RESET PASSWORD] Password reset successful!");
        Get.snackbar("Success", message);
        Get.offAllNamed(RouteName.signIn);
      } else {
        print("⚠️ [RESET PASSWORD] Failed: $message");
        Get.snackbar("Error", message);
      }
    } catch (e) {
      print("🔥 [RESET PASSWORD] Exception caught: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      passwordController.clear();
      confirmPasswordController.clear();
      print("🔚 [RESET PASSWORD] Process finished");
    }
  }
}