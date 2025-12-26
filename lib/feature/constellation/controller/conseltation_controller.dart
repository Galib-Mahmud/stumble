import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/core/local_storage/user_info.dart' as local_storage;

class ConstellationController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // Primary tribe data
  Rx<Map<String, dynamic>> primaryTribe = Rx<Map<String, dynamic>>({});
  RxList<Map<String, dynamic>> tribes = <Map<String, dynamic>>[].obs;

  // Computed values for easy access
  RxString constellationName = ''.obs;
  RxString constellationDescription = ''.obs;
  RxString userAvatar = ''.obs;
  RxString tribeName = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserTribes();
  }

  Future<void> fetchUserTribes() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse("${ApiEndpoint.baseUrl}/api/chatbot/tribes/user/");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print('Tribes API Status: ${response.statusCode}');
      print('Tribes API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          // Parse tribes list
          if (data['data']['tribes'] != null) {
            tribes.value = List<Map<String, dynamic>>.from(data['data']['tribes']);
            print('Tribes loaded: ${tribes.length}');
          }

          // Parse primary tribe
          if (data['data']['primary_tribe'] != null) {
            primaryTribe.value = Map<String, dynamic>.from(data['data']['primary_tribe']);

            // Extract tribe details
            final tribeData = primaryTribe.value['tribe'];
            if (tribeData != null) {
              constellationName.value = tribeData['display_name'] ?? 'Your Constellation';
              constellationDescription.value = tribeData['description'] ?? '';
              tribeName.value = tribeData['name'] ?? '';
            }

            // Extract user avatar
            userAvatar.value = primaryTribe.value['user_avatar'] ?? '';

            print('Primary Tribe: ${constellationName.value}');
            print('Description: ${constellationDescription.value}');
            print('User Avatar: ${userAvatar.value}');
          }
        } else {
          errorMessage.value = data['message'] ?? "Failed to load tribes";
        }
      } else {
        errorMessage.value = "Failed to load tribes (${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Tribes fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get subtitle based on tribe name
  String getSubtitle() {
    switch (tribeName.value) {
      case 'next_horizon':
        return 'Growth and rediscovery';
      case 'tora':
        return 'A space to steady and soften';
      default:
        return 'A space to steady and soften';
    }
  }

  // Refresh data
  Future<void> refreshTribes() async {
    await fetchUserTribes();
  }
}