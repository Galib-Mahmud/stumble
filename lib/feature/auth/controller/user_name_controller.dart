import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../route/route_name.dart';
import '../../splash/screen/app_notification.dart';

class UserNameController extends GetxController {
  final nameController = TextEditingController();
  final isLoading = false.obs;

  // Initialize ApiClient with your base URL
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  Future<void> updateUserName() async {
    final name = nameController.text.trim();
    if (name.isEmpty) {
      Get.snackbar("Error", "Please type your username");
      return;
    }

    // Fetch token properly
    final token = (await UserInfo.getAccessToken())?.trim();

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Access token is missing. Please login again.");
      return;
    }

    isLoading.value = true;

    try {
      final response = await _apiClient.post(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        ApiEndpoint.userName,
        body: {"username": name},
      );

      if (response != null && response['success'] == true) {
        Get.toNamed(RouteName.birthday);
      } else {
        Get.snackbar("Username Error", response?['errors'] ['username']?? "Something went wrong");
      }
    } catch (e) {
      AppNotification.error(e.toString());
    } finally {
      isLoading.value = false;
    }
  }



}