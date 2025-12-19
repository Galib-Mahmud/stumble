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
                        child: Image.asset('assets/images/avatar/Capa_1 (1).png'),
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
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  }

                  if (controller.errorMessage.isNotEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.errorMessage.value,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14.sp,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => controller.refreshBadges(),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (controller.activeBadges.isEmpty) {
                    return Center(
                      child: Text(
                        'No badges available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => controller.refreshBadges(),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 12.w,
                          childAspectRatio: 0.75,
                        ),
                        itemCount: controller.activeBadges.length,
                        itemBuilder: (context, index) {
                          final badge = controller.activeBadges[index];
                          return _buildBadgeItem(
                            controller: controller,
                            badge: badge,
                            isFirst: index == 0 && badge['unlocked'] == true,
                          );
                        },
                      ),
                    ),
                  );
                }),
              ),

              // Next Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: GestureDetector(
                  onTap: () => Get.toNamed(RouteName.mainScreen),
                  child: Container(
                    height: 46.h,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFFEA11E0),
                          Color(0xFFF13D75),
                          Color(0xFFF86D01),
                        ],
                        stops: [0.0, 0.53, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(23.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFF96D01).withOpacity(0.2),
                          blurRadius: 12.r,
                          offset: Offset(0, 4.h),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ),
                ),
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
                      ? const Color(0xFFE8734A)
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
                    color: isUnlocked ? Colors.transparent : const Color(0xFF2A2535),
                  ),
                  child: isUnlocked
                      ? ClipOval(
                    child: Image.asset(
                      controller.getBadgeImage(code),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF2A2535),
                          child: Icon(
                            Icons.emoji_events,
                            color: const Color(0xFFE8734A),
                            size: 32.sp,
                          ),
                        );
                      },
                    ),
                  )
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
          ],
        ),
        SizedBox(height: 8.h),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.white,
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
}