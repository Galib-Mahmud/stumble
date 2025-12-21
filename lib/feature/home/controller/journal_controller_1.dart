import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class JournalController extends GetxController {
  final String baseUrl = "https://joeapi.dsrt321.online";

  // Observable states
  final isLoading = false.obs;
  final isFetching = false.obs;
  final selectedMoodIndex = 3.obs;
  final selectedFeelings = <String>['Motivated'].obs;
  final gratitudeItems = <String>[].obs;
  final summaryText = ''.obs;

  // Journal list - simple list of maps
  final journalList = <Map<String, dynamic>>[].obs;

  // File observables
  final Rx<File?> selectedImage = Rx<File?>(null);
  final Rx<File?> selectedAudio = Rx<File?>(null);
  final Rx<File?> selectedFile = Rx<File?>(null);

  final List<String> moodValues = [
    'very_sad',
    'sad',
    'neutral',
    'happy',
    'very_happy',
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

  void selectMood(int index) {
    selectedMoodIndex.value = index;
  }

  void toggleFeeling(String feeling) {
    if (selectedFeelings.contains(feeling)) {
      selectedFeelings.remove(feeling);
    } else {
      selectedFeelings.add(feeling);
    }
  }

  void addGratitudeItem(String item) {
    if (item.isNotEmpty && gratitudeItems.length < 3) {
      gratitudeItems.add(item);
    }
  }

  void removeGratitudeItem(int index) {
    if (index >= 0 && index < gratitudeItems.length) {
      gratitudeItems.removeAt(index);
    }
  }

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

  Future<void> pickAudio() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.audio,
    );
    if (result != null) {
      selectedAudio.value = File(result.files.single.path!);
    }
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'txt'],
    );
    if (result != null) {
      selectedFile.value = File(result.files.single.path!);
    }
  }

  void clearImage() => selectedImage.value = null;
  void clearAudio() => selectedAudio.value = null;
  void clearFile() => selectedFile.value = null;

  String get currentMood => moodValues[selectedMoodIndex.value];

  // ============== GET JOURNALS ==============
  Future<void> fetchJournals({String? token}) async {
    isFetching.value = true;

    try {
      final uri = Uri.parse('$baseUrl/api/authentication/journal/');

      final httpClient = HttpClient()
        ..badCertificateCallback = (cert, host, port) => true;
      final ioClient = IOClient(httpClient);

      print("🌐 [GET] URL: $uri");

      final response = await ioClient.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print("📩 [GET] Response Code: ${response.statusCode}");
      print("📩 [GET] Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);

        List<dynamic> data = [];

        if (jsonResponse is List) {
          data = jsonResponse;
        } else if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          data = jsonResponse['data'] is List ? jsonResponse['data'] : [jsonResponse['data']];
        } else if (jsonResponse['results'] != null) {
          data = jsonResponse['results'];
        } else if (jsonResponse['journals'] != null) {
          data = jsonResponse['journals'];
        }

        journalList.value = data.map((e) => Map<String, dynamic>.from(e)).toList();

        print("✅ [GET] Fetched ${journalList.length} journals");
      } else {
        String errorMessage = 'Failed to fetch journals';
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorMessage;
        } catch (_) {
          errorMessage = 'Server error: ${response.statusCode}';
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      print("❌ [GET] Error: $e");
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception:', '').trim(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isFetching.value = false;
    }
  }

  // ============== POST JOURNAL ==============
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
      final uri = Uri.parse('$baseUrl/api/authentication/journal/');

      final httpClient = HttpClient()..badCertificateCallback = (cert, host, port) => true;
      httpClient.autoUncompress = true;
      final ioClient = IOClient(httpClient);

      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      });

      request.fields['mood'] = currentMood;
      request.fields['summary'] = summaryController.text;
      request.fields['gratitude_list'] = jsonEncode(gratitudeItems.toList());
      request.fields['feelings'] = jsonEncode(selectedFeelings.toList());

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

      final streamedResponse = await ioClient.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      print("📩 [POST] Response Code: ${response.statusCode}");
      print("📩 [POST] Response Body: ${response.body}");

      if (response.statusCode == 301 || response.statusCode == 302) {
        final redirectUrl = response.headers['location'];
        print("🔄 Redirect to: $redirectUrl");
        throw Exception('Server redirected. Please check the API URL: $redirectUrl');
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
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
            await fetchJournals(token: token);
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
        String errorMessage = 'Failed to create journal';
        try {
          final errorBody = jsonDecode(response.body);
          errorMessage = errorBody['message'] ?? errorBody['error'] ?? errorMessage;
        } catch (_) {
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

  void _clearForm() {
    summaryController.clear();
    selectedMoodIndex.value = 3;
    selectedFeelings.value = ['Motivated'];
    gratitudeItems.clear();
    selectedImage.value = null;
    selectedAudio.value = null;
    selectedFile.value = null;
  }

  // ============== HELPER METHODS FOR UI ==============
  String getMoodEmoji(String? mood) {
    switch (mood) {
      case 'very_sad':
        return '😢';
      case 'sad':
        return '😔';
      case 'neutral':
        return '😐';
      case 'happy':
        return '😊';
      case 'very_happy':
        return '😄';
      default:
        return '😊';
    }
  }

  String getFormattedTime(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final dateTime = DateTime.parse(createdAt);
      final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } catch (e) {
      return '';
    }
  }

  String getFormattedDate(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final dateTime = DateTime.parse(createdAt);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return '';
    }
  }

  String getDisplayTitle(Map<String, dynamic> journal) {
    final summary = journal['summary'] as String?;
    if (summary != null && summary.isNotEmpty) {
      final firstLine = summary.split('\n').first;
      if (firstLine.length > 30) {
        return '${firstLine.substring(0, 30)}...';
      }
      return firstLine;
    }
    return 'Journal Entry';
  }

  String getPreviewText(Map<String, dynamic> journal) {
    final summary = journal['summary'] as String?;
    if (summary != null && summary.isNotEmpty) {
      if (summary.length > 50) {
        return '${summary.substring(0, 50)}...';
      }
      return summary;
    }
    return 'No content';
  }

  List<String> getFeelingsList(dynamic feelings) {
    if (feelings == null) return [];
    if (feelings is List) return List<String>.from(feelings);
    if (feelings is String) {
      try {
        return List<String>.from(jsonDecode(feelings));
      } catch (_) {
        return [];
      }
    }
    return [];
  }
}