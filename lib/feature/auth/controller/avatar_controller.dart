import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../route/route_name.dart';

class AvatarController extends GetxController {
  var selectedAvatarIndex = (-1).obs;
  var pickedImage = Rxn<File>();
  final isSubmitting = false.obs;

  // Local asset avatars
  final List<String> avatars = [
    'assets/images/avatar/avatar1.png',
    'assets/images/avatar/avatar2.png',
    'assets/images/avatar/avatar3.png',
    'assets/images/avatar/avatar4.png',
    'assets/images/avatar/avatar5.png',
    'assets/images/avatar/avatar6.png',
  ];

  bool get hasSelection => selectedAvatarIndex.value != -1 || pickedImage.value != null;

  void selectAvatar(int index) {
    if (index < 0 || index >= avatars.length) return;
    selectedAvatarIndex.value = index;
    pickedImage.value = null;
  }

  Future<void> pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      pickedImage.value = File(image.path);
      selectedAvatarIndex.value = -1;
    }
  }

  Future<void> submitAvatar() async {
    if (!hasSelection) {
      Get.snackbar("Error", "Please select an avatar or add your photo");
      return;
    }

    final token = (await UserInfo.getAccessToken())?.trim();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Access token missing. Please login again.");
      return;
    }

    isSubmitting.value = true;

    try {
      File imageFile;

      if (pickedImage.value != null) {
        imageFile = pickedImage.value!;
      } else {
        imageFile = await _assetToFile(avatars[selectedAvatarIndex.value]);
      }

      final success = await _uploadImage(token, imageFile);

      if (success) {
        print("✅ Avatar submitted successfully");
        Get.toNamed(RouteName.shareYourMind);
      }
    } catch (e) {
      print("❌ Error: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  Future<File> _assetToFile(String assetPath) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final fileName = assetPath.split('/').last;
    final file = File('${tempDir.path}/$fileName');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file;
  }

  Future<bool> _uploadImage(String token, File imageFile) async {
    try {
      var uri = Uri.parse('${ApiEndpoint.baseUrl}${ApiEndpoint.submitAvatar}');
      var request = http.MultipartRequest('POST', uri);

      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath(
        'profile_picture',
        imageFile.path,
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      print("📤 Upload Response: ${response.body}");

      final data = jsonDecode(response.body);

      if (data['success'] == true) {
        return true;
      } else {
        Get.snackbar("Error", data['message'] ?? "Upload failed");
        return false;
      }
    } catch (e) {
      print("❌ Upload error: $e");
      Get.snackbar("Error", "Upload failed: ${e.toString()}");
      return false;
    }
  }
}