import 'package:get/get.dart';
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/core/local_storage/user_info.dart' as local_storage;

import '../../../core/endpoint/api_client.dart';


class BadgesController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

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

      final response = await _apiClient.get(
        ApiEndpoint.badge,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      badges.value = List<Map<String, dynamic>>.from(response['badges'] ?? []);
      earnedBadges.value = List<String>.from(response['earned_badges'] ?? []);
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Get only active badges
  List<Map<String, dynamic>> get activeBadges =>
      badges.where((b) => b['is_active'] == true).toList();

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
        return 'assets/images/icon/badge8.png';
      default:
        return 'assets/images/icon/badge1.png';
    }
  }

  Future<void> refreshBadges() async {
    await fetchBadges();
  }
}
