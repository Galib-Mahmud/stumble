import 'dart:io';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import '../../../core/local_storage/user_info.dart';
import '../../../core/endpoint/api_endpoint.dart';

class VideoRecordController extends GetxController {
  CameraController? cameraController;
  RxBool isRecording = false.obs;
  RxBool isUploading = false.obs;
  RxBool isCameraInitialized = false.obs;
  RxString recordingTime = "00:00".obs;
  RxString uploadStatus = "".obs;

  int _seconds = 0;
  bool _timerRunning = false;

  Future<void> initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        Get.snackbar("Error", "No camera available");
        return;
      }

      CameraDescription selectedCamera = cameras.first;
      for (var camera in cameras) {
        if (camera.lensDirection == CameraLensDirection.front) {
          selectedCamera = camera;
          break;
        }
      }

      cameraController = CameraController(
        selectedCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      await cameraController!.initialize();
      isCameraInitialized.value = true;
      update();
    } catch (e) {
      Get.snackbar("Camera Error", e.toString());
      isCameraInitialized.value = false;
    }
  }

  void _startTimer() {
    _seconds = 0;
    _timerRunning = true;
    _updateTimer();
  }

  void _updateTimer() async {
    while (_timerRunning) {
      await Future.delayed(const Duration(seconds: 1));
      if (_timerRunning) {
        _seconds++;
        int minutes = _seconds ~/ 60;
        int secs = _seconds % 60;
        recordingTime.value =
        "${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}";
      }
    }
  }

  void _stopTimer() {
    _timerRunning = false;
    _seconds = 0;
    recordingTime.value = "00:00";
  }

  Future<void> startRecording() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      await initCamera();
    }

    if (cameraController == null || !cameraController!.value.isInitialized) {
      Get.snackbar("Error", "Camera not initialized");
      return;
    }

    try {
      isRecording.value = true;
      _startTimer();
      await cameraController!.startVideoRecording();
    } catch (e) {
      isRecording.value = false;
      _stopTimer();
      Get.snackbar("Recording Error", e.toString());
    }
  }

  Future<File?> stopRecording() async {
    if (cameraController == null || !cameraController!.value.isRecordingVideo) {
      return null;
    }

    try {
      isRecording.value = false;
      _stopTimer();
      XFile recordedFile = await cameraController!.stopVideoRecording();
      return File(recordedFile.path);
    } catch (e) {
      Get.snackbar("Stop Recording Error", e.toString());
      return null;
    }
  }

  Future<void> uploadVideo(File file) async {
    final token = await UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Please login again.");
      return;
    }

    // Check file exists
    if (!await file.exists()) {
      Get.snackbar("Error", "Video file not found");
      return;
    }

    // Get file info
    final fileSize = await file.length();
    final fileSizeMB = fileSize / (1024 * 1024);

    print("╔══════════════════════════════════════╗");
    print("║       VIDEO UPLOAD DEBUG             ║");
    print("╠══════════════════════════════════════╣");
    print("║ File: ${file.path}");
    print("║ Size: ${fileSizeMB.toStringAsFixed(2)} MB ($fileSize bytes)");
    print("║ URL: ${ApiEndpoint.baseUrl}${ApiEndpoint.videoUpload}");
    print("╚══════════════════════════════════════╝");

    try {
      isUploading.value = true;
      uploadStatus.value = "Preparing...";

      // Create HTTP client with timeout
      final client = http.Client();

      try {
        final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.videoUpload}");
        final request = http.MultipartRequest("POST", uri);

        request.headers["Authorization"] = "Bearer $token";

        // Read file as bytes for better control
        uploadStatus.value = "Reading file...";
        final bytes = await file.readAsBytes();
        print("📄git  File read complete: ${bytes.length} bytes");

        // Add file to request
        request.files.add(http.MultipartFile.fromBytes(
          "video_file",
          bytes,
          filename: basename(file.path),
        ));

        uploadStatus.value = "Uploading...";
        print("📤 Sending request...");

        // Send with timeout
        final streamedResponse = await request.send().timeout(
          const Duration(minutes: 5),
          onTimeout: () {
            print("❌ Request timeout after 5 minutes");
            throw Exception("Upload timeout - please try again");
          },
        );

        print("📥 Response status: ${streamedResponse.statusCode}");

        uploadStatus.value = "Processing response...";
        final response = await http.Response.fromStream(streamedResponse).timeout(
          const Duration(minutes: 2),
          onTimeout: () {
            print("❌ Response timeout");
            throw Exception("Response timeout");
          },
        );

        print("📥 Response body: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {
          print("✅ Upload successful!");
          Get.snackbar(
            "Success",
            "Video uploaded successfully ✅",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 3),
          );

          // Delete local file
          try {
            await file.delete();
            print("🗑️ Local file deleted");
          } catch (e) {
            print("⚠️ Could not delete local file: $e");
          }
        } else {
          print("❌ Upload failed: ${response.statusCode}");
          print("❌ Error body: ${response.body}");
          Get.snackbar(
            "Upload Failed",
            "Server error: ${response.statusCode}",
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 5),
          );
        }
      } finally {
        client.close();
      }
    } on Exception catch (e) {
      print("❌ Exception: $e");
      Get.snackbar(
        "Upload Error",
        e.toString().replaceAll("Exception: ", ""),
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
      );
    } finally {
      isUploading.value = false;
      uploadStatus.value = "";
    }
  }

  void disposeCamera() {
    cameraController?.dispose();
    cameraController = null;
    isCameraInitialized.value = false;
    _stopTimer();
  }

  @override
  void onClose() {
    disposeCamera();
    super.onClose();
  }
}