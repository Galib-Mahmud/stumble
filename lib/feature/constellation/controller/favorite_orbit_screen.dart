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
                children: [
                  // Back Button
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Container(
                      width: 35.w,
                      height: 35.w,
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
                  // Star Icon
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
                            height: 80.w,
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
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Star your favorite orbits to see them here',
                            style: TextStyle(
                              color: Colors.white54,
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 24.h),
                          ElevatedButton(
                            onPressed: () => Get.back(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                              padding: EdgeInsets.symmetric(
                                horizontal: 32.w,
                                vertical: 12.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: Text(
                              'Explore Orbits',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Favorite Posts - Horizontal Scroll
                  return RefreshIndicator(
                    onRefresh: () => controller.fetchFavoriteOrbitPosts(),
                    color: const Color(0xFF6366F1),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Count Text
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Text(
                              '${controller.favoritePosts.length} Favorite${controller.favoritePosts.length > 1 ? 's' : ''}',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Horizontal Scroll List
                          SizedBox(
                            height: 280.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                          ),

                          SizedBox(height: 30.h),

                          // Bottom Motivational Section
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(20.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    const Color(0xFF6366F1).withOpacity(0.3),
                                    const Color(0xFF8B5CF6).withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16.r),
                                border: Border.all(
                                  color: const Color(0xFF6366F1).withOpacity(0.3),
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.auto_awesome,
                                    color: const Color(0xFFFFD700),
                                    size: 32.sp,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    'Your Inspiration Collection',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 8.h),
                                  Text(
                                    'These are the moments that inspire you. Keep adding more!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SizedBox(height: 100.h),
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

  Widget _buildFavoriteCard({
    required OrbitPost post,
    required List<Color> gradientColors,
    required OrbitController controller,
    required BuildContext context,
  }) {
    return Container(
      width: 200.w,
      margin: EdgeInsets.only(right: 16.w),
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
            blurRadius: 12,
            offset: const Offset(0, 6),
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
                // Star Badge
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
                              color: Colors.white,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Remove from favorites button
                    GestureDetector(
                      onTap: () => controller.toggleFavorite(post, context),
                      child: Container(
                        width: 32.w,
                        height: 32.w,
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

                // Quote Bubble
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
                      // Quote Icon
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
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
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
                        maxLines: 3,
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