import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/core/local_storage/user_info.dart' as local_storage;

class BadgesController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<Map<String, dynamic>> badges = <Map<String, dynamic>>[].obs;
  RxList<String> earnedBadges = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBadges();
  }

  Future<void> fetchBadges() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.badge}");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print('Badge API Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Parse badges list
        if (data['badges'] != null) {
          badges.value = List<Map<String, dynamic>>.from(data['badges']);
          print('Badges loaded: ${badges.length}');

          // Debug: Print each badge
          for (var badge in badges) {
            print('Badge: ${badge['name']} - is_active: ${badge['is_active']} (${badge['is_active'].runtimeType}) - unlocked: ${badge['unlocked']}');
          }
        }

        // Parse earned badges list
        if (data['earned_badges'] != null) {
          earnedBadges.value = List<String>.from(data['earned_badges']);
        }
        print('Earned badges: $earnedBadges');

        // Force UI update
        badges.refresh();

      } else {
        errorMessage.value = "Failed to load badges (${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Badge fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get only active badges
  List<Map<String, dynamic>> get activeBadges {
    final active = badges.where((b) {
      final isActive = b['is_active'];
      return isActive == true || isActive.toString() == 'true';
    }).toList();
    return active;
  }

  // Get unlocked badges
  List<Map<String, dynamic>> get unlockedBadges =>
      badges.where((b) => b['unlocked'] == true).toList();

  // Check if badge is unlocked
  bool isBadgeUnlocked(Map<String, dynamic> badge) {
    return badge['unlocked'] == true;
  }

  // Get badge image based on code
  String getBadgeImage(String code) {
    switch (code) {
      case 'day_one':
        return 'assets/images/icon/badge1.png';
      case 'courage':
        return 'assets/images/icon/badge2.png';
      case 'reflection':
        return 'assets/images/icon/badge3.png';
      case 'resilience':
        return 'assets/images/icon/badge4.png';
      case 'support_karma':
        return 'assets/images/icon/badge5.png';
      case 'growth':
        return 'assets/images/icon/badge6.png';
      case 'graduation':
        return 'assets/images/icon/badge7.png';
      case 'mentor':
        return 'assets/images/icon/badge8.png';
      case 'legacy':
        return 'assets/images/icon/badge9.png';
      default:
        return 'assets/images/icon/badge1.png';
    }
  }

  int getBadgeColor(String code) {
    switch (code) {
      case 'day_one':
        return 0xFF4CAF50;
      case 'courage':
        return 0xFFE91E63;
      case 'reflection':
        return 0xFF9C27B0;
      case 'resilience':
        return 0xFFFF9800;
      case 'support_karma':
        return 0xFF2196F3;
      case 'growth':
        return 0xFF8BC34A;
      case 'graduation':
        return 0xFFFFD700;
      case 'mentor':
        return 0xFF00BCD4;
      case 'legacy':
        return 0xFFFF5722;
      default:
        return 0xFFE8734A;
    }
  }

  Future<void> refreshBadges() async {
    await fetchBadges();
  }
}