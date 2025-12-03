

// Screen 3: Welcome to Stumble
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../route/route_name.dart';
import '../../widget/onboarding/custom_button.dart';

class OnboardingScreen3 extends StatelessWidget {
  const OnboardingScreen3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/Onboarding.png'),
            fit: BoxFit.cover,
          ),
        ),

          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),
                  Row(

                    children: [
                      Container(
                        width: 55.w,
                        height: 40.h,

                        child: Image.asset(
                          'assets/images/splash/stumble.png',
                          width: 55.w,
                          height: 40.h,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Text(
                        'STUMBLE',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    'Start Your',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    'Journey',
                    style: TextStyle(
                      color: const Color(0xFF00D9C0),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 40.h),
                  GestureDetector(
                    onTap: () {
                     Get.toNamed(RouteName.startQuiz);
                    },
                    child: Container(
                      height: 56.h,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Center(
                              child: Text(
                                'Finish',
                                style: TextStyle(
                                  color: Color(0xFF4EFFEE),
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(4.w),
                            width: 48.w,
                            height: 48.w,
                            decoration: const BoxDecoration(
                              color: Color(0xFF4EFFEE),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                              size: 24.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 32.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 32.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        width: 32.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF8754ED),
                          borderRadius: BorderRadius.circular(2.r),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                ],
              ),
            ),
          ),
        ),

    );
  }
}