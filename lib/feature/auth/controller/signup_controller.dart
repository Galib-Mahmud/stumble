import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../route/route_name.dart';
import '../../splash/screen/app_notification.dart';


class SignupController extends GetxController {
  // Text Controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Observable variables
  final isPasswordVisible = true.obs;
  final isConfirmPasswordVisible = true.obs;
  final isLoading = false.obs;

  // Initialize ApiClient with base URL
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // Toggle functions
  void togglePasswordVisibility() =>
      isPasswordVisible.value = !isPasswordVisible.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;

  // Main Register Function
  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {

      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match");
      return;
    }

    isLoading.value = true;
    print("✅ [REGISTER] Register function called");

    try {
      final response = await _apiClient.post(
        ApiEndpoint.signup, // e.g. "/api/register/"
        body: {
          "email": email,
          "password": password,
          "confirm_password": confirmPassword,
        },
      );


      final bool success = response["success"] == true || response["status"] == true;
      final String message = response["message"] ?? "No message received";

      if (success) {
        print("🟢 [REGISTER] Registration Successful");

        Get.toNamed(RouteName.signIn);


      } else {
        print("⚠️ [REGISTER] Registration Failed: $message");
        Get.snackbar("Error", message);
      }
    } catch (e) {
      print("🔥 [REGISTER] Exception caught: $e");
      AppNotification.error(e.toString());
    } finally {
      isLoading.value = false;
      print("⏹️ [REGISTER] Loading stopped");
    }
  }
}