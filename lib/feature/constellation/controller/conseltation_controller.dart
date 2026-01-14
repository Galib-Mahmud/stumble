import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/core/local_storage/user_info.dart' as local_storage;

class ConstellationData {
  final String name;
  final String displayName;
  final String subtitle;
  final String backgroundImage;
  final Color primaryColor;

  ConstellationData({
    required this.name,
    required this.displayName,
    required this.subtitle,
    required this.backgroundImage,
    required this.primaryColor,
  });
}

class ConstellationController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  Rx<Map<String, dynamic>> primaryTribe = Rx<Map<String, dynamic>>({});
  RxList<Map<String, dynamic>> tribes = <Map<String, dynamic>>[].obs;

  RxString constellationName = ''.obs;
  RxString constellationDescription = ''.obs;
  RxString userAvatar = ''.obs;
  RxString tribeName = ''.obs;

  // Constellation mappings - map backend tribe names to designs
  static final Map<String, ConstellationData> constellationMap = {
    // Stillroot - Green/Teal (Image 1)
    'stillroot': ConstellationData(
      name: 'stillroot',
      displayName: 'Stillroot',
      subtitle: 'A space to steady and soft.',
      backgroundImage: 'assets/images/avatar/constellation_stillroot.png',
      primaryColor: const Color(0xFF4EEABC),
    ),

    // Flowline - Blue/Cyan (Image 2)
    'flowline': ConstellationData(
      name: 'flowline',
      displayName: 'Flowline',
      subtitle: 'This is where your constellation rises.',
      backgroundImage: 'assets/images/avatar/constellation_flowline.png',
      primaryColor: const Color(0xFF00D4FF),
    ),

    // Emberpath - Orange/Red (Image 3)
    'emberpath': ConstellationData(
      name: 'emberpath',
      displayName: 'Emberpath',
      subtitle: 'A space for truth to rise above.',
      backgroundImage: 'assets/images/avatar/constellation_emberpath.png',
      primaryColor: const Color(0xFFFF8A65),
    ),

    // Highwind - Purple (Image 4)
    'highwind': ConstellationData(
      name: 'highwind',
      displayName: 'Highwind',
      subtitle: 'A space where clarity opens gently.',
      backgroundImage: 'assets/images/avatar/constellation_highwind.png',
      primaryColor: const Color(0xFFCB6CE6),
    ),

    // Map your actual backend tribe names here
    'next_horizon': ConstellationData(
      name: 'next_horizon',
      displayName: 'Flowline',
      subtitle: 'This is where your constellation rises.',
      backgroundImage: 'assets/images/constellation/constellation_flowline.png',
      primaryColor: const Color(0xFF00D4FF),
    ),

    'tora': ConstellationData(
      name: 'tora',
      displayName: 'Stillroot',
      subtitle: 'A space to steady and soft.',
      backgroundImage: 'assets/images/constellation/constellation_stillroot.png',
      primaryColor: const Color(0xFF4EEABC),
    ),
  };

  // Default constellation
  static final ConstellationData defaultConstellation = ConstellationData(
    name: 'default',
    displayName: 'Your Constellation',
    subtitle: 'A space to grow and discover.',
    backgroundImage: 'assets/images/constellation/constellation_stillroot.png',
    primaryColor: const Color(0xFF4EEABC),
  );

  @override
  void onInit() {
    super.onInit();
    fetchUserTribes();
  }

  // Get current constellation data based on tribe name
  ConstellationData get currentConstellation {
    final name = tribeName.value.toLowerCase();
    return constellationMap[name] ?? defaultConstellation;
  }

  // Get background image path
  String get backgroundImage => currentConstellation.backgroundImage;

  // Get primary color
  Color get primaryColor => currentConstellation.primaryColor;

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
          if (data['data']['tribes'] != null) {
            tribes.value = List<Map<String, dynamic>>.from(data['data']['tribes']);
            print('Tribes loaded: ${tribes.length}');
          }

          if (data['data']['primary_tribe'] != null) {
            primaryTribe.value = Map<String, dynamic>.from(data['data']['primary_tribe']);

            final tribeData = primaryTribe.value['tribe'];
            if (tribeData != null) {
              constellationName.value = tribeData['display_name'] ?? 'Your Constellation';
              constellationDescription.value = tribeData['description'] ?? '';
              tribeName.value = tribeData['name'] ?? '';
            }

            userAvatar.value = primaryTribe.value['user_avatar'] ?? '';

            print('Primary Tribe: ${constellationName.value}');
            print('Tribe Name: ${tribeName.value}');
            print('Background: ${backgroundImage}');
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

  // Get subtitle based on current constellation
  String getSubtitle() {
    return currentConstellation.subtitle;
  }

  // Get display name
  String getDisplayName() {
    if (constellationName.value.isNotEmpty) {
      return constellationName.value;
    }
    return currentConstellation.displayName;
  }

  Future<void> refreshTribes() async => await fetchUserTribes();
}