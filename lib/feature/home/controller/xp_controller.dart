import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/local_storage/user_info.dart' as local_storage;
import '../../../core/endpoint/api_endpoint.dart';

class XpController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;

  // XP Data
  RxInt totalPoints = 0.obs;
  RxInt dailyStreak = 0.obs;
  RxString lastLoginDate = ''.obs;
  RxString lastActivityDate = ''.obs;
  RxList<Map<String, dynamic>> recentActivities = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    fetchXpData();
    super.onInit();
  }

  Future<void> fetchXpData() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Update this endpoint according to your API
      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.xpPoints}");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final xpData = data['data'];
          totalPoints.value = xpData['total_points'] ?? 0;
          dailyStreak.value = xpData['daily_streak'] ?? 0;
          lastLoginDate.value = xpData['last_login_date']?.toString() ?? 'N/A';
          lastActivityDate.value = xpData['last_activity_date']?.toString() ?? 'N/A';

          if (xpData['recent_activities'] != null) {
            recentActivities.value = List<Map<String, dynamic>>.from(
              xpData['recent_activities'],
            );
          }
        }
      } else {
        errorMessage.value = "Failed to load XP data";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Format activity name for display
  String formatActivityName(String activity) {
    return activity
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty
        ? '${word[0].toUpperCase()}${word.substring(1)}'
        : '')
        .join(' ');
  }

  // Show XP Details Dialog
  void showXpDetailsDialog() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'XP Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Total Points
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF4CAF50).withOpacity(0.3),
                      const Color(0xFF2E7D32).withOpacity(0.3),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.stars_rounded,
                      color: Color(0xFF4CAF50),
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Column(
                      children: [
                        Text(
                          '${totalPoints.value}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'Total XP Points',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Stats Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.local_fire_department,
                      iconColor: Colors.orange,
                      value: '${dailyStreak.value}',
                      label: 'Day Streak',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(
                      icon: Icons.calendar_today,
                      iconColor: Colors.blue,
                      value: lastActivityDate.value,
                      label: 'Last Activity',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Recent Activities
              if (recentActivities.isNotEmpty) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Recent Activities',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: recentActivities.length,
                    separatorBuilder: (_, __) => Divider(
                      color: Colors.white.withOpacity(0.1),
                      height: 1,
                    ),
                    itemBuilder: (context, index) {
                      final activity = recentActivities[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    formatActivityName(
                                        activity['activity'] ?? ''),
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    activity['date'] ?? '',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.white.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF4CAF50).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '+${activity['points']} XP',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF4CAF50),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}