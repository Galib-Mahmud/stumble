import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../controller/badge_controller.dart';

class YourBadgesScreen extends StatelessWidget {
  const YourBadgesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BadgesController controller = Get.put(BadgesController());

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/Sign In.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Top bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.info_outline,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Title
              Padding(
                padding: EdgeInsets.only(left: 20.w, top: 8.h, bottom: 20.h),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Badges',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),

              // Badges Grid
              Expanded(
                child: Obx(() {
                  // Debug print
                  print('Building badge grid - isLoading: ${controller.isLoading.value}, badges count: ${controller.badges.length}');

                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

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
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 32.w),
                            child: Text(
                              controller.errorMessage.value,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14.sp,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => controller.refreshBadges(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6366F1),
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  // Use badges directly instead of activeBadges getter
                  final badgesList = controller.badges
                      .where((b) => b['is_active'] == true)
                      .toList();

                  print('Filtered badges count: ${badgesList.length}');

                  if (badgesList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.emoji_events_outlined,
                            color: Colors.white54,
                            size: 48.sp,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'No badges available',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14.sp,
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            'Total in list: ${controller.badges.length}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.refreshBadges(),
                    color: const Color(0xFF6366F1),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: badgesList.length,
                        itemBuilder: (context, index) {
                          final badge = badgesList[index];
                          final isFirstUnlocked = index == 0 && badge['unlocked'] == true;

                          return _buildBadgeItem(
                            controller: controller,
                            badge: badge,
                            isFirst: isFirstUnlocked,
                          );
                        },
                      ),
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

  Widget _buildBadgeItem({
    required BadgesController controller,
    required Map<String, dynamic> badge,
    bool isFirst = false,
  }) {
    final bool isUnlocked = badge['unlocked'] == true;
    final String code = badge['code'] ?? '';
    final String name = badge['name'] ?? '';
    final String description = badge['description'] ?? '';
    final bool hasGradientBorder = isFirst && isUnlocked;
    final badgeColor = Color(controller.getBadgeColor(code));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasGradientBorder
                    ? const SweepGradient(colors: [
                  Color(0xFFFF6B6B),
                  Color(0xFFFFE66D),
                  Color(0xFF4ECDC4),
                ])
                    : null,
                border: !hasGradientBorder
                    ? Border.all(
                  color: isUnlocked
                      ? badgeColor
                      : Colors.white.withOpacity(0.2),
                  width: 2.w,
                )
                    : null,
              ),
              child: Padding(
                padding: EdgeInsets.all(3.w),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF2A2535),
                  ),
                  child: ClipOval(
                    child: isUnlocked
                        ? _buildBadgeImage(controller, code, badgeColor)
                        : Center(
                      child: Icon(
                        Icons.lock,
                        color: Colors.white.withOpacity(0.4),
                        size: 28.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Unlocked indicator
            if (isUnlocked)
              Positioned(
                bottom: -2,
                right: -2,
                child: Container(
                  width: 24.w,
                  height: 24.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF1A1A2E),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14.sp,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: isUnlocked ? Colors.white : Colors.white.withOpacity(0.6),
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          description,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 10.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildBadgeImage(BadgesController controller, String code, Color badgeColor) {
    final imagePath = controller.getBadgeImage(code);

    return Image.asset(
      imagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        print('Badge image error for $code: $error');
        // Fallback: Show colored icon if asset doesn't exist
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                badgeColor,
                badgeColor.withOpacity(0.7),
              ],
            ),
          ),
          child: Center(
            child: Icon(
              _getBadgeIcon(code),
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        );
      },
    );
  }

  IconData _getBadgeIcon(String code) {
    switch (code) {
      case 'day_one':
        return Icons.celebration;
      case 'courage':
        return Icons.shield;
      case 'reflection':
        return Icons.auto_stories;
      case 'resilience':
        return Icons.local_fire_department;
      case 'support_karma':
        return Icons.favorite;
      case 'growth':
        return Icons.trending_up;
      case 'graduation':
        return Icons.school;
      case 'mentor':
        return Icons.psychology;
      case 'legacy':
        return Icons.stars;
      default:
        return Icons.emoji_events;
    }
  }
}