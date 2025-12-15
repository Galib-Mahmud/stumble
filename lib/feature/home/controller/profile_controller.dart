import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stumble/feature/home/controller/profile_model.dart';
import '../../../core/local_storage/user_info.dart' as local_storage;
import '../../../core/endpoint/api_endpoint.dart';


class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  RxString errorMessage = ''.obs;

  Rx<UserProfileData?> profileData = Rx<UserProfileData?>(null);

  // Text Controllers for editable fields
  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final phoneController = TextEditingController();
  final introductionController = TextEditingController();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    usernameController.dispose();
    phoneController.dispose();
    introductionController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.profile}");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final profileResponse = UserProfileResponse.fromJson(data);
        profileData.value = profileResponse.data;

        // Populate text controllers with existing data
        _populateControllers();
      } else {
        errorMessage.value = "Failed to load profile";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  void _populateControllers() {
    final profile = profileData.value?.profile;
    if (profile != null) {
      fullNameController.text = profile.fullName ?? '';
      usernameController.text = profile.username ?? '';
      phoneController.text = profile.phoneNumber ?? '';
      introductionController.text = profile.introduction ?? '';
    }
  }

  Future<void> updateProfile() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Please login again.");
      return;
    }

    // Validate
    if (usernameController.text.trim().isEmpty) {
      Get.snackbar("Error", "Username is required");
      return;
    }

    try {
      isUpdating.value = true;

      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.profileUpdate}");

      // Only send fields that can be edited
      final body = {
        "full_name": fullNameController.text.trim(),
        "username": usernameController.text.trim(),
        "phone_number": phoneController.text.trim(),
        "introduction": introductionController.text.trim(),
      };

      final response = await http.patch(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          "Success",
          "Profile updated successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
        );
        // Refresh profile data
        await fetchProfile();
        Get.back(); // Go back to profile screen
      } else {
        final errorData = json.decode(response.body);
        String errorMsg = "Failed to update profile";

        if (errorData is Map) {
          // Handle validation errors
          errorData.forEach((key, value) {
            if (value is List && value.isNotEmpty) {
              errorMsg = value.first.toString();
            }
          });
        }

        Get.snackbar(
          "Error",
          errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isUpdating.value = false;
    }
  }

  // Getters for display
  String get email => profileData.value?.user.email ?? '';
  String get displayName => profileData.value?.profile.displayName ?? 'User';
  String get profileImageUrl => profileData.value?.profile.profileImageUrl ?? '';
  String get gender => profileData.value?.profile.displayGender ?? 'Select';
  String get ageRange => profileData.value?.profile.displayAgeRange ?? 'Select';
  int get age => profileData.value?.profile.age ?? 0;
}