import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'video_list_controller.dart';
import 'video_model.dart';
import 'video_player_screen.dart';

class MyVideosScreen extends StatelessWidget {
  MyVideosScreen({super.key});

  final VideoListController controller = Get.put(VideoListController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/avatar/sos.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              _buildAppBar(),

              SizedBox(height: 20.h),

              // Video List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4EFFEE),
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return _buildErrorWidget();
                  }

                  if (controller.videoList.isEmpty) {
                    return _buildEmptyWidget();
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchVideos,
                    color: const Color(0xFF4EFFEE),
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      itemCount: controller.videoList.length,
                      itemBuilder: (context, index) {
                        return Obx(() {
                          final video = controller.videoList[index];
                          return _buildVideoItem(video, index);
                        });
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.15),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 18.w,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Text(
            "My Videos",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const Spacer(),
          Obx(() => Text(
            "${controller.videoList.length} videos",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildVideoItem(VideoModel video, int index) {
    return GestureDetector(
      onTap: () {
        Get.to(() => VideoPlayerScreen(
          videoUrl: video.videoUrl,
          title: "Video ${index + 1}",
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2E3D).withOpacity(0.9),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Row(
            children: [
              // Video Thumbnail/Icon
              _buildThumbnail(),

              SizedBox(width: 16.w),

              // Video Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // File Name
                    Text(
                      video.fileName,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: 8.h),

                    // Duration and Date Row
                    Row(
                      children: [
                        // Duration
                        _buildDurationBadge(video.duration),

                        SizedBox(width: 8.w),

                        // Upload Date
                        Expanded(
                          child: Text(
                            video.formattedDate,
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: Colors.white.withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Delete Button
              Obx(() => GestureDetector(
                onTap: controller.isDeleting.value
                    ? null
                    : () => _showDeleteDialog(video.id),
                child: Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: controller.isDeleting.value
                      ? Padding(
                    padding: EdgeInsets.all(8.w),
                    child: const CircularProgressIndicator(
                      color: Colors.red,
                      strokeWidth: 2,
                    ),
                  )
                      : Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 18.w,
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: const Color(0xFF253F5A),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.videocam_rounded,
            color: const Color(0xFF4EFFEE),
            size: 32.w,
          ),
          // Play overlay
          Positioned(
            bottom: 4.h,
            right: 4.w,
            child: Container(
              padding: EdgeInsets.all(4.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.6),
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 12.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDurationBadge(String? duration) {
    final bool isLoading = duration == null;
    final String displayText = duration ?? "...";

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 8.w,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF4EFFEE).withOpacity(0.2),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            SizedBox(
              width: 10.w,
              height: 10.w,
              child: const CircularProgressIndicator(
                color: Color(0xFF4EFFEE),
                strokeWidth: 1.5,
              ),
            )
          else
            Icon(
              Icons.access_time,
              color: const Color(0xFF4EFFEE),
              size: 12.w,
            ),
          SizedBox(width: 4.w),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF4EFFEE),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(String videoId) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A2E3D),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Delete Video",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this video? This action cannot be undone.",
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteVideo(videoId);
            },
            child: Text(
              "Delete",
              style: TextStyle(
                color: Colors.red,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.withOpacity(0.7),
              size: 60.w,
            ),
            SizedBox(height: 16.h),
            Text(
              controller.errorMessage.value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.h),
            GestureDetector(
              onTap: controller.fetchVideos,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 24.w,
                  vertical: 12.h,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF4EFFEE),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  "Retry",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.videocam_off_outlined,
            color: Colors.white.withOpacity(0.3),
            size: 80.w,
          ),
          SizedBox(height: 16.h),
          Text(
            "No videos yet",
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 18.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Record your first grounding message",
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }
}