import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

class YourBadgesScreen extends StatelessWidget {
  const YourBadgesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              // Top bar with back and share buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back button
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
                    // Share button
                    GestureDetector(
                      onTap: () {
                        // Share functionality
                      },
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Image.asset('assets/images/avatar/Capa_1 (1).png')
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
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: GridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16.h,
                    crossAxisSpacing: 12.w,
                    childAspectRatio: 0.75,
                    children: [
                      // Row 1
                      _buildBadgeItem(
                        image: 'assets/images/avatar/Frame1.png',
                        title: 'Pioneer\nBadge',
                        subtitle: 'Early explorer',
                        isUnlocked: true,
                        hasGradientBorder: true,
                        gradientColors: [Color(0xFFFF6B6B), Color(0xFFFFE66D), Color(0xFF4ECDC4)],
                      ),
                      _buildBadgeItem(
                        image: 'assets/images/avatar/Frame1.png',
                        title: 'Onboard\nBadge',
                        subtitle: 'First steps complete',
                        isUnlocked: false,
                      ),
                      _buildBadgeItem(
                        image: 'assets/images/badges/signal_flare.png',
                        title: 'Signal Flare\nBadge',
                        subtitle: 'First post made',
                        isUnlocked: false,
                      ),

                      // Row 2
                      _buildBadgeItem(
                        image: 'assets/images/badges/reflection.png',
                        title: 'Reflection\nBadge',
                        subtitle: 'First journal entry',
                        isUnlocked: false,
                      ),
                      _buildBadgeItem(
                        image: 'assets/images/badges/no_contact.png',
                        title: 'No Contact\nBadge',
                        subtitle: 'Boundary milestone',
                        isUnlocked: false,
                      ),
                      _buildBadgeItem(
                        image: 'assets/images/badges/support_karma.png',
                        title: 'Support Karma\nBadge',
                        subtitle: 'Community support',
                        isUnlocked: false,
                      ),

                      // Row 3
                      _buildBadgeItem(
                        image: 'assets/images/badges/graduation.png',
                        title: 'Graduation\nBadge',
                        subtitle: 'Next stage reached',
                        isUnlocked: false,
                      ),
                      _buildBadgeItem(
                        image: 'assets/images/badges/evergreen.png',
                        title: 'Evergreen\nBadge',
                        subtitle: 'Emerging mentor',
                        isUnlocked: false,
                        showSoonTag: true,
                      ),
                    ],
                  ),
                ),
              ),

              // Next Button
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteName.startQuiz);
                  },
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
                        stops: [0.0, 0.53, 1.0], // Fixed: 6.0 -> 1.0
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
                        'Next', // Fixed: missing text
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
    required String image,
    required String title,
    required String subtitle,
    required bool isUnlocked,
    bool hasGradientBorder = false,
    List<Color>? gradientColors,
    bool showSoonTag = false,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Badge circle
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            // Outer border (gradient or gray)
            Container(
              width: 80.w,
              height: 80.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: hasGradientBorder && gradientColors != null
                    ? SweepGradient(colors: gradientColors)
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
                    color: isUnlocked
                        ? Colors.transparent
                        : const Color(0xFF2A2535),
                  ),
                  child: isUnlocked
                      ? ClipOval(
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
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

            // "Soon" tag
            if (showSoonTag)
              Positioned(
                top: -8.h,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3548),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    'Soon',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        ),

        SizedBox(height: 8.h),

        // Title
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            height: 1.2,
          ),
        ),

        SizedBox(height: 2.h),

        // Subtitle
        Text(
          subtitle,
          textAlign: TextAlign.center,
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