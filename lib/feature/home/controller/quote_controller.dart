import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stumble/core/endpoint/api_endpoint.dart';
import 'package:stumble/core/local_storage/user_info.dart' as local_storage;

class QuoteController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxString quote = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchQuote();
  }

  Future<void> fetchQuote() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse("${ApiEndpoint.baseUrl}/api/admin-dashboard/getCurrentQuotes/");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      print('Quote API Status: ${response.statusCode}');
      print('Quote API Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          quote.value = data['data']['quote'] ?? '';
          print('Quote loaded: ${quote.value}');
        } else {
          errorMessage.value = data['message'] ?? "Failed to load quote";
        }
      } else {
        errorMessage.value = "Failed to load quote (${response.statusCode})";
      }
    } catch (e) {
      errorMessage.value = e.toString();
      print('Quote fetch error: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshQuote() async {
    await fetchQuote();
  }
}