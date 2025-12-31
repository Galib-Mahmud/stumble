import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../home/controller/orbit_controller.dart';

class FavoriteOrbitScreen extends StatelessWidget {
  const FavoriteOrbitScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final OrbitController controller = Get.put(OrbitController());

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Custom App Bar
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 35.w,
                      height: 35.h,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3D3D3D),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Text(
                    'My Favorite Orbits',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.star,
                    color: const Color(0xFFFFD700),
                    size: 24.sp,
                  ),
                ],
              ),
            ),

            // Main Content
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
                  if (controller.isFavoriteLoading.value || controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    );
                  }

                  // Empty State
                  if (controller.favoritePosts.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 80.w,
                            height: 80.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFD700).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.star_border,
                              color: const Color(0xFFFFD700),
                              size: 40.sp,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'No favorite orbits yet',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Star your favorite orbits to see them here',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Vertical Scroll List
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchFavoriteOrbitPosts(),
                    color: const Color(0xFF6366F1),
                    child: ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                      itemCount: controller.favoritePosts.length,
                      itemBuilder: (context, index) {
                        final favoritePost = controller.favoritePosts[index];
                        final post = favoritePost.orbitPost;
                        final gradientColors = controller.getGradientForIndex(index);

                        return _buildFavoriteCard(
                          post: post,
                          gradientColors: gradientColors,
                          controller: controller,
                          context: context,
                        );
                      },
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

  Widget _buildFavoriteCard({
    required OrbitPost post,
    required List<Color> gradientColors,
    required OrbitController controller,
    required BuildContext context,
  }) {
    return Container(
      height: 200.h,
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withOpacity(0.3),
            blurRadius: 12.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Image
          if (post.imageUrl.isNotEmpty)
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20.r),
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

          // Gradient Overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.1),
                    Colors.black.withOpacity(0.7),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row - Star Badge & Remove Button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 6.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star,
                            color: Colors.white,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Favorite',
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.toggleFavorite(post, context),
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 16.sp,
                        ),
                      ),
                    ),
                  ],
                ),

                const Spacer(),

                // Quote Content
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.r),
                      topRight: Radius.circular(12.r),
                      bottomRight: Radius.circular(12.r),
                      bottomLeft: Radius.circular(4.r),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 24.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9500),
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                        child: Center(
                          child: Text(
                            '66',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        post.title.isNotEmpty ? post.title : post.description,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                          height: 1.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}