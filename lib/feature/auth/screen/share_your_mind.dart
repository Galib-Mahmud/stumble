import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../../widget/onboarding/custom_button.dart';
import '../controller/share_your_mind_controller.dart';

class ShareYourMindScreen extends StatefulWidget {
  const ShareYourMindScreen({super.key});

  @override
  State<ShareYourMindScreen> createState() => _ShareYourMindScreenState();
}

class _ShareYourMindScreenState extends State<ShareYourMindScreen> {
  final ShareYourMindController controller = Get.put(ShareYourMindController());


  final int currentStep = 6;
  final int totalSteps = 8;

  // Selected avatar from previous screen (pass this via arguments)
  final String selectedAvatar = 'assets/images/avatar/avatar5.png';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
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
              // Top Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    // Row with Back Button and Logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
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
                        // Logo
                        Image.asset(
                          'assets/images/splash/stumble.png',
                         fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Progress Bar Row
                    Row(
                      children: [
                        // Progress Bar
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
                        // Step Text
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

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      children: [
                        SizedBox(height: 20.h),
                        // Title
                        Text(
                          "Share as much or as little\nas you want",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Avatar
                        Container(
                          width: 80.w,
                          height: 80.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: const Color(0xFF09AFB9),
                              width: 3,
                            ),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              selectedAvatar,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Text Input Box
                        Container(
                          width: double.infinity,
                          height: 150.h,
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1D1D1D),
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.white.withOpacity(0.1),
                              width: 1,
                            ),
                          ),
                          child: TextField(
                            controller: controller.introductionController,
                            maxLines: null,
                            expands: true,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                            ),
                            decoration: InputDecoration(
                              hintText: "What's on your mind ?",
                              hintStyle: TextStyle(
                                color: Colors.white.withOpacity(0.4),
                                fontSize: 14.sp,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Bottom Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // Bottom Text
                    Text(
                      "This is a safe space to share your struggle,\nget advice and support each other",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.6),
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 20.h),
                    // Next Button
                    CustomButton(
                      text: "Next",
                      onTap: () {
                        controller.submitIntroduction();
                      },
                    ),
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