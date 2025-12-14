import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../route/route_name.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';

class GenderController extends GetxController {
  var selectedGender = RxnString(); // "male", "female", "other"
  final isLoading = false.obs;

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  /// Set gender
  void setGender(String? gender) {
    selectedGender.value = gender?.toLowerCase(); // lowercase to send
  }

  /// Submit gender
  Future<void> submitGender() async {
    if (selectedGender.value == null || selectedGender.value!.isEmpty) {
      Get.snackbar("Error", "Please select a gender");
      return;
    }

    isLoading.value = true;

    try {
      final token = (await UserInfo.getAccessToken())?.trim();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Access token missing. Please login again.");
        return;
      }

      // Example API call (replace with actual endpoint)
      final response = await _apiClient.post(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        ApiEndpoint.gender, // replace with your endpoint
        body: {"gender": selectedGender.value},
      );

      if (response != null && response['success'] == true) {
        // Navigate to next screen
        Get.toNamed(RouteName.question);
      } else {
        Get.snackbar("Error", response?['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}