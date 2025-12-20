import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

class GuestController extends GetxController {
  Timer? _loginReminderTimer;
  bool _isDialogShowing = false;

  void startGuestSession() {
    Get.toNamed(RouteName.mainScreen);

    // Start periodic 10 second timer - shows popup every 10 seconds
    _loginReminderTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      // Only show popup if dialog is not already showing
      if (!_isDialogShowing) {
        _showLoginPopup();
      }
    });
  }

  void _showLoginPopup() {
    _isDialogShowing = true;

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E2E),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_outline,
                  color: const Color(0xFF4CAF50),
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 20.h),

              // Title
              Text(
                'Continue with Login',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 12.h),

              // Message
              Text(
                'To continue using this app and access all features, please login to your account.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14.sp,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 24.h),

              // Login Button
              GestureDetector(
                onTap: () {
                  _cancelTimer(); // Stop the timer permanently
                  Get.back(); // Close dialog
                  Get.offAllNamed(RouteName.signIn); // Navigate to sign in
                },
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4CAF50),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  child: Center(
                    child: Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15.h),

              // Continue as Guest Button
              GestureDetector(
                onTap: () {
                  _isDialogShowing = false;
                  Get.back(); // Close dialog, timer continues running
                },

                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(25.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Continue as Guest',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _cancelTimer() {
    _loginReminderTimer?.cancel();
    _loginReminderTimer = null;
  }

  @override
  void onClose() {
    _cancelTimer();
    super.onClose();
  }
}