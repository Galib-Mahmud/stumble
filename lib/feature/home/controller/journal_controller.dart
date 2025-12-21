import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class JournalController extends GetxController {
  // Base URL - update this to your actual base URL (use HTTPS if server redirects)
  final String baseUrl = "https://joeapi.dsrt321.online";

  // Observable states
  final isLoading = false.obs;
  final selectedMoodIndex = 3.obs;
  final selectedFeelings = <String>['Motivated'].obs;
  final gratitudeItems = <String>[].obs;
  final summaryText = ''.obs;

  // File observables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> selectedAudio = Rx<File?>(null);
  final Rx<File?> selectedFile = Rx<File?>(null);

  // Mood mapping - matches API mood choices (same as feelings)
  final List<String> moodValues = [
    'calm',
    'chill',
    'motivated',
    'grateful',
    'curious',
    'satisfied',
    'comfortable',
    'inspired',
    'appreciated',
  ];

  final List<String> feelings = [
    'Calm',
    'Chill',
    'Motivated',
    'Grateful',
    'Curious',
    'Satisfied',
    'Comfortable',
    'Inspired',
    'Appreciated',
  ];

  // Text controller
  final TextEditingController summaryController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    summaryController.addListener(() {
      summaryText.value = summaryController.text;
    });
  }

  @override
  void onClose() {
    summaryController.dispose();
    super.onClose();
  }

  // Select mood
  void selectMood(int index) {
    selectedMoodIndex.value = index;
  }

  // Toggle feeling selection - single selection since it's the mood
  void toggleFeeling(String feeling) {
    selectedFeelings.value = [feeling];
  }

  // Add gratitude item
  void addGratitudeItem(String item) {
    if (item.isNotEmpty && gratitudeItems.length < 3) {
      gratitudeItems.add(item);
    }
  }

  // Remove gratitude item
  void removeGratitudeItem(int index) {
    if (index >= 0 && index < gratitudeItems.length) {
      gratitudeItems.removeAt(index);
    }
  }

  // Pick image
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  // Pick audio
  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      selectedAudio.value = File(result.files.single.path!);
    }
  }

  // Pick file
  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    if (result != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  // Clear selected files
  void clearImage() => selectedImage.value = null;
  void clearAudio() => selectedAudio.value = null;
  void clearFile() => selectedFile.value = null;

  // Get current mood value - uses first selected feeling
  String get currentMood {
    if (selectedFeelings.isNotEmpty) {
      return selectedFeelings.first.toLowerCase();
    }
    return 'motivated'; // default
  }

  // POST Journal Entry with Multipart
  Future<void> createJournal({String? token}) async {
    if (summaryController.text.isEmpty && gratitudeItems.isEmpty) {
      Get.snackbar(
        'Error',
        'Please add a summary or gratitude items',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Ensure trailing slash to avoid 301 redirects
      final uri = Uri.parse('$baseUrl/api/authentication/journal/');

      // Create HttpClient that follows redirects
      final httpClient = HttpClient()..badCertificateCallback = (cert, host, port) => true;
      httpClient.autoUncompress = true;
      final ioClient = IOClient(httpClient);

      var request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      // Add fields
      request.fields['mood'] = currentMood;
      request.fields['summary'] = summaryController.text;
      request.fields['gratitude_list'] = jsonEncode(gratitudeItems.toList());

      // Add files if selected
      if (selectedImage.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'summary_image',
          selectedImage.value!.path,
        ));
      }

      if (selectedAudio.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'summary_audio',
          selectedAudio.value!.path,
        ));
      }

      if (selectedFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'summary_file',
          selectedFile.value!.path,
        ));
      }

      print("🌐 [POST] URL: $uri");
      print("📋 [POST] Fields: ${request.fields}");
      print("📎 [POST] Files: ${request.files.map((f) => f.field).toList()}");

      // Send with IOClient to handle redirects
      final streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 [POST] Response Code: ${response.statusCode}");
      print("📩 [POST] Response Body: ${response.body}");

      // Handle redirect manually if still getting 301/302
      if (response.statusCode == 301 || response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        print("🔄 Redirect to: $redirectUrl");
        throw Exception('Server redirected. Please check the API URL: $redirectUrl');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // Try to parse as JSON
        try {
          final jsonResponse = jsonDecode(response.body);

          if (jsonResponse['success'] == true) {
            Get.snackbar(
              'Success',
              jsonResponse['message'] ?? 'Journal created successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            int pointsEarned = jsonResponse['points_earned'] ?? 0;
            if (pointsEarned > 0) {
              _showPointsDialog(pointsEarned);
            }

            _clearForm();
            Get.back();
          } else {
            throw Exception(jsonResponse['message'] ?? 'Failed to create journal');
          }
        } catch (e) {
          if (e is FormatException) {
            throw Exception('Invalid response from server');
          }
          rethrow;
        }
      } else {
        // Handle error response
        String errorMessage = 'Failed to create journal';
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorMessage;
        } catch (_) {
          // Response is not JSON (like HTML error page)
          errorMessage = 'Server error: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("❌ [POST] Error: $e");
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception:', '').trim(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Show points earned dialog
  void _showPointsDialog(int points) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 60),
            const SizedBox(height: 16),
            Text(
              '+$points Points!',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Great job on your journal entry!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Awesome!'),
          ),
        ],
      ),
    );
  }

  // Clear form
  void _clearForm() {
    summaryController.clear();
    selectedMoodIndex.value = 3;
    selectedFeelings.value = ['Motivated'];
    gratitudeItems.clear();
    selectedImage.value = null;
    selectedAudio.value = null;
    selectedFile.value = null;
  }
}