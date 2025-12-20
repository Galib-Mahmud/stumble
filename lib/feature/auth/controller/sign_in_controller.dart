import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stumble/feature/splash/screen/app_notification.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../route/route_name.dart';


class SignInController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  // Initialize ApiClient with your base URL
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please fill all the fields");
      return;
    }

    isLoading.value = true;

    try {
      print("🌐 [LOGIN] Calling API using ApiClient...");
      final response = await _apiClient.post(
        ApiEndpoint.signin, // e.g. "/api/login/"
        body: {
          "email": email,
          "password": password,
        },
      );



      // Safely extract token values
      final accessToken = response['data']?['tokens']?['access'];
      final refreshToken = response['data']?['tokens']?['refresh'];



      if (accessToken != null && refreshToken != null) {
        UserInfo.setAccessToken(accessToken);
        UserInfo.setRefreshToken(refreshToken);

        // Save onboarding status
        final onboardingCompleted = response['data']?['profile']?['onboarding_completed'] ?? false;
        await UserInfo.setOnboardingCompleted(onboardingCompleted);

        if (onboardingCompleted == false) {
          Get.toNamed(RouteName.username);
        } else {
          Get.toNamed(RouteName.mainScreen);
        }
      } else {
        print("🚫 [LOGIN] Tokens missing in response");
       AppNotification.error("Invalid response from server");
      }
    } catch (e) {
      print("🔥 [LOGIN] Exception caught: $e");
     AppNotification.error(e.toString());

    } finally {
      print("🔚 [LOGIN] Login process finished");
      isLoading.value = false;
    }
  }
}