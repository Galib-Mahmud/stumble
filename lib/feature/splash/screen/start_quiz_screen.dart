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
      backgroundColor: const Color(0xFF3A3A3A), // Dark gray background
      body: SafeArea(
        child: Column(
          children: [
            // Top half - Background image
            Expanded(
              flex: 5,
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

            // Bottom half - Content card
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,

                child: Card(
                  color:Color(0xFF2B2634) ,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.r),
                      topRight: Radius.circular(32.r),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo
                      Image.asset(
                        'assets/images/splash/frame.png',
                        width: 60.w,
                        height: 60.h,
                        fit: BoxFit.cover,
                      ),

                      SizedBox(height: 24.h),

                      // Title
                      Text(
                        'Begin The Intake',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.5,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Description
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
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
                        padding: EdgeInsets.symmetric(horizontal: 8.w),
                        child: CustomButton(
                          text: 'Begin My Journey',
                          onTap: () {

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
      ),
    );
  }
}