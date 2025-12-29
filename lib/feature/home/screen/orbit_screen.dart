import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../controller/orbit_controller.dart';

class OrbitQuotesScreen extends StatelessWidget {
  const OrbitQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrbitController controller = Get.put(OrbitController());

    return Container(
      color: Colors.black,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Orbit',
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    width: 35.w,
                    height: 35.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D3D3D),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.settings);
                      },
                      child: Icon(
                        Icons.settings,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content with Background
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF1E1B4B),
                      Color(0xFF1E1B4B),
                      Color(0xFF0F172A),
                    ],
                  ),
                ),
                child: Obx(() {
                  // Loading State
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  // Error State
                  if (controller.errorMessage.value.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.white54,
                            size: 48.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => controller.refreshPosts(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Empty State
                  if (controller.posts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: Colors.white54,
                            size: 48.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No orbit posts yet',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 16.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Posts Grid
                  return RefreshIndicator(
                    onRefresh: () => controller.refreshPosts(),
                    color: const Color(0xFF6366F1),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 8.h,
                        bottom: 140.h,
                      ),
                      child: Column(
                        children: [
                          // Dynamic Posts Grid
                          _buildPostsGrid(controller, context),

                          SizedBox(height: 20.h),

                          // Bottom Motivational Quote Section
                          ClipRRect(
                            borderRadius: BorderRadius.circular(16.r),
                            child: Image.asset(
                              'assets/images/splash/orbit.png',
                              width: double.infinity,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPostsGrid(OrbitController controller, BuildContext context) {
    final posts = controller.posts;

    if (posts.length == 1) {
      // Single post - full width
      return _buildPostCard(
        post: posts[0],
        gradientColors: controller.getGradientForIndex(0),
        height: 300.h,
        controller: controller,
        context: context,
      );
    }

    if (posts.length == 2) {
      // Two posts - side by side
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: _buildPostCard(
              post: posts[0],
              gradientColors: controller.getGradientForIndex(0),
              height: 280.h,
              controller: controller,
              context: context,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: _buildPostCard(
              post: posts[1],
              gradientColors: controller.getGradientForIndex(1),
              height: 280.h,
              controller: controller,
              context: context,
            ),
          ),
        ],
      );
    }

    // Multiple posts - Pinterest-style layout
    List<OrbitPost> leftColumn = [];
    List<OrbitPost> rightColumn = [];

    for (int i = 0; i < posts.length; i++) {
      if (i % 2 == 0) {
        leftColumn.add(posts[i]);
      } else {
        rightColumn.add(posts[i]);
      }
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column
          Expanded(
            child: Column(
              children: leftColumn.asMap().entries.map((entry) {
                final index = entry.key * 2;
                final post = entry.value;
                final isLarge = index % 4 == 0;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildPostCard(
                    post: post,
                    gradientColors: controller.getGradientForIndex(index),
                    height: isLarge ? 300.h : 220.h,
                    controller: controller,
                    context: context,
                  ),
                );
              }).toList(),
            ),
          ),
          SizedBox(width: 12.w),
          // Right Column
          Expanded(
            child: Column(
              children: rightColumn.asMap().entries.map((entry) {
                final index = entry.key * 2 + 1;
                final post = entry.value;
                final isLarge = index % 4 == 1;
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h),
                  child: _buildPostCard(
                    post: post,
                    gradientColors: controller.getGradientForIndex(index),
                    height: isLarge ? 220.h : 300.h,
                    controller: controller,
                    context: context,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard({
    required OrbitPost post,
    required List<Color> gradientColors,
    required double height,
    required OrbitController controller,
    required BuildContext context,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Background Image (if available)
          if (post.imageUrl.isNotEmpty)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.r),
                child: CachedNetworkImage(
                  imageUrl: post.imageUrl,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Container(
                    color: Colors.black26,
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white54,
                        strokeWidth: 2,
                      ),
                    ),
                  ),
                  errorWidget: (context, url, error) => const SizedBox(),
                ),
              ),
            ),

          // Gradient Overlay for text readability
          if (post.imageUrl.isNotEmpty)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.1),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
            ),

          // Quote/Title Bubble
          Positioned(
            top: 16.h,
            left: 10.w,
            right: 10.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                  bottomLeft: Radius.circular(4.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quote Icon
                  Container(
                    width: 28.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: Text(
                        '66',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    post.title.isNotEmpty ? post.title : post.description,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),

          // Star Button - Reactive to favorite status
          Positioned(
            bottom: 14.h,
            right: 14.w,
            child: Obx(() => GestureDetector(
              onTap: () => controller.toggleFavorite(post, context),
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: post.isFavorite.value
                      ? const Color(0xFFFFD700)
                      : const Color(0xFF5D4037),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  post.isFavorite.value ? Icons.star : Icons.star_border,
                  color: post.isFavorite.value
                      ? Colors.white
                      : const Color(0xFFFFD700),
                  size: 20.sp,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }
}