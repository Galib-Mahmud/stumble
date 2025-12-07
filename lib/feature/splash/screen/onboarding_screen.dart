import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../route/route_name.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;

  void _onNextTap() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
    } else {
      Get.toNamed(RouteName.signIn);
    }
  }

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

                // Logo and title
                Row(
                  children: [
                    Image.asset(
                      'assets/images/splash/stumble.png',
                      width: 55.w,
                      height: 40.h,
                      fit: BoxFit.cover,
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

                // Text content based on current page
                _buildTextContent(),

                SizedBox(height: 40.h),

                // Next/Finish Button
                GestureDetector(
                  onTap: _onNextTap,
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
                              _currentPage == 2 ? 'Finish' : 'Next',
                              style: TextStyle(
                                color: const Color(0xFF4EFFEE),
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

                // Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: 32.w,
                      height: 4.h,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF8754ED)
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 32.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent() {
    switch (_currentPage) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome',
              style: TextStyle(color: Colors.white, fontSize: 63.sp),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'to ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 64.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'Stumble',
                    style: TextStyle(
                      color: const Color(0xFF00D9C0),
                      fontSize: 64.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Where healing',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40.sp,
                height: 1.2,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'meets ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  TextSpan(
                    text: 'connection',
                    style: TextStyle(
                      color: const Color(0xFF00D9C0),
                      fontSize: 40.sp,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        );

      default:
        return const SizedBox();
    }
  }
}
