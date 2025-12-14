import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stumble/core/endpoint/api_client.dart';
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/route/route_name.dart';
import '../../../core/local_storage/user_info.dart';

class ShareYourMindController extends GetxController {
  final TextEditingController introductionController = TextEditingController();
  final RxBool isLoading = false.obs;

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  bool get hasText => introductionController.text.trim().isNotEmpty;

  @override
  void onClose() {
    introductionController.dispose();
    super.onClose();
  }

  Future<void> submitIntroduction() async {
    final introduction = introductionController.text.trim();

    if (introduction.isEmpty) {
      Get.snackbar("Error", "Please share something about yourself");
      return;
    }

    final token = (await UserInfo.getAccessToken())?.trim();

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Access token is missing. Please login again.");
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        ApiEndpoint.introduction, // Your endpoint for introduction
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: {
          "introduction": introduction,
        },
      );

      if (response != null && response['success'] == true) {
        print("✅ Introduction submitted successfully");
        Get.toNamed(RouteName.terms); // Navigate to next screen
      } else {
        Get.snackbar(
            "Error",
            response?['message'] ?? response?['errors']?['introduction'] ?? "Something went wrong"
        );
      }
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar("Error", "Request failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}