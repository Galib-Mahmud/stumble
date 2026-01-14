import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../widget/onboarding/custom_button.dart';
import '../controller/conseltation_controller.dart';

class ConstellationScreen extends StatelessWidget {
  ConstellationScreen({Key? key}) : super(key: key);

  final ConstellationController controller = Get.put(ConstellationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF1A1A2E), Color(0xFF0F0F1A)],
              ),
            ),
            child: const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF09AFB9)),
              ),
            ),
          );
        }

        // Get dynamic background image based on tribe
        final backgroundImage = controller.backgroundImage;

        return Stack(
          children: [
            // Dynamic Background Image
            Positioned.fill(
              child: Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback gradient if image not found
                  return Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF0D6B5F), Color(0xFF0A1615)],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Bottom Buttons Section - Fixed at bottom
            Positioned(
              left: 24.w,
              right: 24.w,
              bottom: 80.h,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // About this constellation Button
                  _buildOutlineButton(
                    text: "About this constellation",
                    onTap: () => _showConstellationDialog(context),
                  ),
                  SizedBox(height: 12.h),
                  // See your path Button
                  _buildGradientButton(
                    text: "See your path",
                    onTap: () {
                      Get.toNamed(RouteName.progressPath);
                    },
                  ),  SizedBox(height: 12.h),

                  _buildGradientButton(
                    text: "Next",
                    onTap: () {
                      Get.toNamed(RouteName.mainScreen);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  // Outline Button matching design
  Widget _buildOutlineButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Container(
              width: 46.w,
              height: 46.w,
              margin: EdgeInsets.only(right: 5.w),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                ),
              ),
              child: Icon(
                Icons.arrow_outward,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Gradient Button matching design
  Widget _buildGradientButton({
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28.r),
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 46.w),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.w),
              child: Icon(
                Icons.arrow_outward,
                color: Colors.white,
                size: 20.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // About Constellation Dialog
  void _showConstellationDialog(BuildContext context) {
    final constellation = controller.currentConstellation;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A2E).withOpacity(0.95),
              borderRadius: BorderRadius.circular(24.r),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20.r,
                  offset: Offset(0, 10.h),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close button
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 32.w,
                      height: 32.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                // Avatar Orb
                Obx(() => _buildAvatarOrb(
                  controller.userAvatar.value,
                  constellation.primaryColor,
                )),
                SizedBox(height: 24.h),
                // Title
                Obx(() => Text(
                  'About ${controller.getDisplayName()}',
                  style: TextStyle(
                    color: constellation.primaryColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 16.h),
                // Description
                Obx(() => Text(
                  controller.constellationDescription.value.isNotEmpty
                      ? controller.constellationDescription.value
                      : "This constellation represents your unique path in the Stumble universe. Each constellation has its own energy, wisdom, and community of like-minded seekers.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 24.h),
                // Got it button
                _buildGradientButton(
                  text: "Got it",
                  onTap: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarOrb(String avatarUrl, Color glowColor) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.9),
            glowColor.withOpacity(0.5),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: glowColor.withOpacity(0.5),
            blurRadius: 30.r,
            spreadRadius: 5.r,
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.3),
            blurRadius: 20.r,
            spreadRadius: 2.r,
          ),
        ],
      ),
      child: avatarUrl.isNotEmpty
          ? ClipOval(
        child: CachedNetworkImage(
          imageUrl: avatarUrl,
          width: 80.w,
          height: 80.w,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(glowColor),
              ),
            ),
          ),
          errorWidget: (context, url, error) => Container(
            color: Colors.white,
          ),
        ),
      )
          : null,
    );
  }
}