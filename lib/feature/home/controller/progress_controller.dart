import 'package:get/get.dart';
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/core/local_storage/user_info.dart' as local_storage;

import '../../../core/endpoint/api_client.dart';


class ProgressPathController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<Map<String, dynamic>> milestones = <Map<String, dynamic>>[].obs;
  Rx<Map<String, dynamic>> summary = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    fetchProgressPath();
  }

  Future<void> fetchProgressPath() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await _apiClient.get(
        ApiEndpoint.progressPath, // Add this to your ApiEndpoint
        headers: {"Authorization": "Bearer $token",
            "Content-Type": "application/json",

        },
      );

      if (response['success'] == true && response['data'] != null) {
        final data = response['data'];
        milestones.value = List<Map<String, dynamic>>.from(data['milestones'] ?? []);
        summary.value = Map<String, dynamic>.from(data['summary'] ?? {});
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Check if milestone is completed
  bool isMilestoneCompleted(String milestoneKey) {
    final milestone = milestones.firstWhereOrNull(
          (m) => m['milestone'] == milestoneKey,
    );
    return milestone?['completed'] == true;
  }

  // Get milestone by key
  Map<String, dynamic>? getMilestone(String key) {
    return milestones.firstWhereOrNull((m) => m['milestone'] == key);
  }

  // Summary getters
  int get totalMilestones => summary.value['total_milestones'] ?? 0;
  int get completedMilestones => summary.value['completed_milestones'] ?? 0;
  int get remainingMilestones => summary.value['remaining_milestones'] ?? 0;
  int get progressPercentage => summary.value['progress_percentage'] ?? 0;
  bool get isComplete => summary.value['is_complete'] ?? false;

  Map<String, dynamic>? get nextMilestone => summary.value['next_milestone'];

  Future<void> refresh() async {
    await fetchProgressPath();
  }
}