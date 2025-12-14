import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../route/route_name.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';

class BirthdayController extends GetxController {
  final monthController = TextEditingController();
  final dayController = TextEditingController();
  final yearController = TextEditingController();

  final isLoading = false.obs;

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  /// Validate and submit birthday
  Future<void> submitBirthday() async {
    final mm = monthController.text.trim();
    final dd = dayController.text.trim();
    final yy = yearController.text.trim();

    // Basic validation
    if (mm.isEmpty || dd.isEmpty || yy.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    // Optional: Validate number ranges
    final month = int.tryParse(mm);
    final day = int.tryParse(dd);
    final year = int.tryParse(yy);

    if (month == null || month < 1 || month > 12) {
      Get.snackbar("Error", "Invalid month");
      return;
    }

    if (day == null || day < 1 || day > 31) {
      Get.snackbar("Error", "Invalid day");
      return;
    }

    if (year == null || year < 1900 || year > DateTime.now().year) {
      Get.snackbar("Error", "Invalid year");
      return;
    }

    // Construct date_of_birth string
    final dateOfBirth = "${dd.padLeft(2, '0')}/${mm.padLeft(2, '0')}/$yy";

    isLoading.value = true;

    try {
      final token = (await UserInfo.getAccessToken())?.trim();
      if (token == null || token.isEmpty) {
        Get.snackbar("Error", "Access token missing. Please login again.");
        return;
      }

      // Example API call (optional, remove if not needed yet)
      final response = await _apiClient.post(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        ApiEndpoint.dateOfBirth, // Replace with your actual endpoint
        body: {"date_of_birth": dateOfBirth},
      );

      if (response != null && response['success'] == true) {
        // Navigate to next screen
        Get.toNamed(RouteName.gender);
      } else {
        Get.snackbar("Error", response?['message'] ?? "Something went wrong");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    monthController.dispose();
    dayController.dispose();
    yearController.dispose();
    super.onClose();
  }
}