import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../widget/onboarding/custom_button.dart';
import '../controller/conseltation_controller.dart';


// Outline Button Widget
class CustomOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CustomOutlineButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF183A37),
          borderRadius: BorderRadius.circular(23.r),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}

class ConstellationScreen extends StatelessWidget {
  ConstellationScreen({Key? key}) : super(key: key);

  final ConstellationController controller = Get.put(ConstellationController());

  void _showConstellationDialog(BuildContext context) {
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
                // Close button row
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
                // Glowing Circle/Orb with user avatar
                Obx(() => _buildAvatarOrb(controller.userAvatar.value)),
                SizedBox(height: 24.h),
                // Title
                Obx(() => Text(
                  'About ${controller.constellationName.value}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 16.h),
                // Description
                Obx(() => Text(
                  controller.constellationDescription.value,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                )),
                SizedBox(height: 24.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatarOrb(String avatarUrl) {
    return Container(
      width: 80.w,
      height: 80.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            Colors.white,
            Colors.white.withOpacity(0.9),
            const Color(0xFF09AFB9).withOpacity(0.5),
          ],
          stops: const [0.0, 0.7, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF09AFB9).withOpacity(0.5),
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
                valueColor: AlwaysStoppedAnimation<Color>(
                  const Color(0xFF09AFB9),
                ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/Your Constellation_ Tora.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF09AFB9)),
                  ),
                );
              }

              return Column(
                children: [
                  const Spacer(flex: 2),
                  // Main Card
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(24.w),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A1A2E).withOpacity(0.85),
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
                        // Glowing Circle/Orb with user avatar
                        _buildAvatarOrb(controller.userAvatar.value),
                        SizedBox(height: 24.h),
                        // Title - Dynamic constellation name
                        Text(
                          'Your Constellation: ${controller.constellationName.value}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 8.h),
                        // Subtitle
                        Text(
                          controller.getSubtitle(),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 28.h),
                        // Gradient Button - About this constellation
                        CustomButton(
                          text: 'About this constellation',
                          onTap: () {
                            _showConstellationDialog(context);
                          },
                        ),
                        SizedBox(height: 12.h),
                        // Outline Button - See your path
                        CustomOutlineButton(
                          text: 'See your path',
                          onTap: () {
                            Get.toNamed(RouteName.progressPath);
                          },
                        ),
                        SizedBox(height: 12.h),
                        // Start Button - Navigate to main screen
                        CustomButton(text: "Start", onTap: () {
                          Get.toNamed(RouteName.mainScreen);
                        },)
                      ],
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  
}