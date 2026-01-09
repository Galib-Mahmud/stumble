import 'package:get/get.dart';
import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../route/route_name.dart';
import '../../splash/screen/app_notification.dart';

class GetQuestionController extends GetxController {
  final isLoading = false.obs;
  final isSubmitting = false.obs; // 👈 Add this line
  final questions = <Map<String, dynamic>>[].obs;
  final currentQuestionIndex = 0.obs;
  final selectedOptionId = Rxn<int>(); // Single selected option ID

  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  int get currentStep => currentQuestionIndex.value + 1;
  int get totalSteps => questions.length;

  Map<String, dynamic>? get currentQuestion {
    if (questions.isEmpty) return null;
    return questions[currentQuestionIndex.value];
  }

  List get currentOptions {
    return currentQuestion?['options'] ?? [];
  }

  String get questionText {
    return currentQuestion?['question_text'] ?? '';
  }

  String get categoryText {
    return currentQuestion?['category'] ?? 'QUESTION';
  }

  Future<void> getQuestion() async {
    final token = (await UserInfo.getAccessToken())?.trim();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Access token is missing. Please login again.");
      return;
    }

    isLoading.value = true;
    try {
      final response = await _apiClient.get(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        ApiEndpoint.getQuestions,
      );

      if (response != null && response['success'] == true) {
        final List<dynamic> data = response['data']['questions'];
        questions.value = data.map((q) => Map<String, dynamic>.from(q)).toList();
        selectedOptionId.value = null;
        print("✅ Questions loaded: ${questions.length}");
      } else {
        Get.snackbar("Error", response?['message'] ?? "Something went wrong");
      }
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar("Error", "Request failed: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  void selectOption(int optionId) {
    selectedOptionId.value = optionId;
  }

  bool isSelected(int optionId) {
    return selectedOptionId.value == optionId;
  }

  bool get hasSelection => selectedOptionId.value != null;

  Future<void> submitAnswer(int questionId, int optionId) async {
    final token = (await UserInfo.getAccessToken())?.trim();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Access token missing.");
      return;
    }

    try {
      final body = {
        "question_id": questionId,
        "option_id": [optionId],
      };

      final response = await _apiClient.post(
        ApiEndpoint.submitAnswer,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      if (response != null && response['success'] == true) {
        print("✅ Answer submitted: $body");
      } else {
        Get.snackbar("Error", response?['message'] ?? "Failed to submit");
      }
    } catch (e) {
      AppNotification.error(e.toString());
    }
  }

  Future<void> nextQuestion() async {
    if (currentQuestion == null) return;

    final questionId = currentQuestion!['question_id'] ?? currentQuestion!['id'];
    final selected = selectedOptionId.value;

    if (selected == null) {
      Get.snackbar("Warning", "Please select an answer.");
      return;
    }

    // 👇 Start loading
    isSubmitting.value = true;

    try {
      await submitAnswer(questionId, selected);

      if (currentQuestionIndex.value < questions.length - 1) {
        currentQuestionIndex.value++;
        selectedOptionId.value = null;
      } else {
        Get.toNamed(RouteName.selectAvatar);
        Get.snackbar("Completed", "All questions answered!");
      }
    } finally {
      // 👇 Stop loading
      isSubmitting.value = false;
    }
  }
}