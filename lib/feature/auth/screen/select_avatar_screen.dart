import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widget/onboarding/custom_button.dart';
import '../controller/avatar_controller.dart';

class SelectAvatarScreen extends StatefulWidget {
  const SelectAvatarScreen({super.key});

  @override
  State<SelectAvatarScreen> createState() => _SelectAvatarScreenState();
}

class _SelectAvatarScreenState extends State<SelectAvatarScreen> {
  late AvatarController controller;

  final int currentStep = 5;
  final int totalSteps = 8;

  @override
  void initState() {
    super.initState();
    controller = Get.put(AvatarController());
  }

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
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Get.back(),
                          child: Container(
                            width: 32.w,
                            height: 32.h,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.white,
                              size: 18.sp,
                            ),
                          ),
                        ),
                        Image.asset(
                          'assets/images/splash/stumble.png',
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Progress Bar
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 7.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: currentStep,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF09AFB9),
                                          Color(0xFFFFAD72),
                                          Color(0xFFF96D01),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: totalSteps - currentStep,
                                  child: const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$currentStep',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' / $totalSteps',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main Content - Scrollable
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Title
                      Obx(() => Text(
                        controller.hasSelection
                            ? "Select an avatar"
                            : "Create your Stumble Avatar",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      )),
                      SizedBox(height: 30.h),

                      // Avatar Grid (Local Assets)
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.avatars.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 16.h,
                          crossAxisSpacing: 16.w,
                        ),
                        itemBuilder: (context, index) {
                          return Obx(() {
                            final isSelected = controller.selectedAvatarIndex.value == index;
                            return GestureDetector(
                              onTap: () => controller.selectAvatar(index),
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF09AFB9)
                                        : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    controller.avatars[index],
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          });
                        },
                      ),

                      SizedBox(height: 20.h),

                      // Picked image preview
                      Obx(() {
                        final pickedFile = controller.pickedImage.value;
                        if (pickedFile != null) {
                          return Column(
                            children: [
                              Container(
                                width: 80.w,
                                height: 80.w,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF09AFB9),
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.file(
                                    pickedFile,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Text(
                                "Your photo selected",
                                style: TextStyle(
                                  color: const Color(0xFF09AFB9),
                                  fontSize: 12.sp,
                                ),
                              ),
                              SizedBox(height: 12.h),
                            ],
                          );
                        }
                        return const SizedBox.shrink();
                      }),

                      // Divider
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Text(
                              'or',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 14.sp,
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              height: 2,
                              color: Colors.white.withOpacity(0.2),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Add photo button
                      GestureDetector(
                        onTap: () => controller.pickImageFromGallery(),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                          decoration: BoxDecoration(
                            color: const Color(0xFF183A37),
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.add, color: Colors.white, size: 20.sp),
                              SizedBox(width: 8.w),
                              Text(
                                "Add your photo",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),

              // Bottom Section (Fixed)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    Text(
                      "This helps you stay anonymous",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // Next Button
                    Obx(() {
                      if (controller.isSubmitting.value) {
                        return Container(
                          height: 46.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF09AFB9),
                            borderRadius: BorderRadius.circular(23.r),
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          ),
                        );
                      }

                      if (controller.hasSelection) {
                        return CustomButton(
                          text: "Next",
                          onTap: () => controller.submitAvatar(),
                        );
                      }

                      return Container(
                        height: 46.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A3E),
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: Center(
                          child: Text(
                            'Next',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.4),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}