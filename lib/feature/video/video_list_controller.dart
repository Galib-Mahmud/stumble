import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../../core/local_storage/user_info.dart';
import '../../core/endpoint/api_endpoint.dart';
import 'video_model.dart';

class VideoListController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isDeleting = false.obs;
  RxList<VideoModel> videoList = <VideoModel>[].obs;
  RxString errorMessage = ''.obs;

  @override
  void onInit() {
    fetchVideos();
    super.onInit();
  }

  Future<void> fetchVideos() async {
    final token = await UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.videoList}");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final videoResponse = VideoListResponse.fromJson(data);
        videoList.value = videoResponse.results;

        // Stop loading here, fetch durations in background
        isLoading.value = false;

        // Fetch durations in parallel (max 3 at a time)
        await _fetchAllDurations();
      } else {
        errorMessage.value = "Failed to load videos";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch durations in parallel batches
  Future<void> _fetchAllDurations() async {
    const int batchSize = 3;

    for (int i = 0; i < videoList.length; i += batchSize) {
      final batch = <Future>[];
      for (int j = i; j < i + batchSize && j < videoList.length; j++) {
        batch.add(_fetchVideoDuration(j));
      }
      await Future.wait(batch);
    }
  }

  Future<void> _fetchVideoDuration(int index) async {
    if (index >= videoList.length) return;

    VideoPlayerController? videoController;
    try {
      videoController = VideoPlayerController.networkUrl(
        Uri.parse(videoList[index].videoUrl),
      );

      // Add timeout to prevent hanging
      await videoController.initialize().timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Video initialization timeout');
        },
      );

      final duration = videoController.value.duration;
      videoList[index].duration = _formatDuration(duration);
      videoList.refresh();
    } catch (e) {
      print("Error fetching duration for video $index: $e");
      videoList[index].duration = "--:--";
      videoList.refresh();
    } finally {
      await videoController?.dispose();
    }
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    if (duration.inHours > 0) {
      final hours = twoDigits(duration.inHours);
      return '$hours:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  Future<void> deleteVideo(String videoId) async {
    final token = await UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "Please login again.");
      return;
    }

    try {
      isDeleting.value = true;

      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.videoDelete}");
      final response = await http.delete(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "video_id": videoId,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        videoList.removeWhere((video) => video.id == videoId);
        Get.snackbar(
          "Success",
          "Video deleted successfully",
          snackPosition: SnackPosition.TOP,
        );
      } else {
        Get.snackbar("Error", "Failed to delete video");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isDeleting.value = false;
    }
  }
}