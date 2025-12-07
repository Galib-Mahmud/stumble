import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';
import '../../widget/onboarding/custom_button.dart';

class StartQuizScreen extends StatelessWidget {
  const StartQuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2634),
      body: Stack(
        children: [
          // Top half - Background image (full width, top portion)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/splash/startQuiz.png'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          // Bottom half - Content card (overlapping the image)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.53, // Overlap position
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF201C2A),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32.r),
                  topRight: Radius.circular(32.r),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo
                    Image.asset(
                      'assets/images/splash/frame.png',

                      fit: BoxFit.contain,
                    ),

                    SizedBox(height: 14.h),

                    // Title
                    Text(
                      'Begin The Intake',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    SizedBox(height: 16.h),

                    // Description
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 32.w),
                      child: Text(
                        'Answer a few simple questions so we can connect you to the right Constellation, people who get where you are and walk beside you through it',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: const Color(0xFFB0B0B0),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          height: 1.6,
                        ),
                      ),
                    ),

                    SizedBox(height: 32.h),

                    // Button
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w),
                      child: CustomButton(
                        text: 'Begin My Journey',
                        onTap: () {
                          Get.toNamed(RouteName.question);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}