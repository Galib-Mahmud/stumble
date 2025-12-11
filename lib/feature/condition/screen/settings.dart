import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../../widget/condition/custom_appbar2.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(title: 'Settings', onBack: () => Get.back()),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/Terms of Use (1).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Others Section
              _buildSectionTitle('Others'),
              SizedBox(height: 12.h),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/newPassword.png',
                title: 'New Password',
                onTap: () {
                 Get.toNamed(RouteName.forgetPassword);
                },
              ),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/termsofuse.png',
                title: 'Terms of Use',
                onTap: () {
                  Get.toNamed(RouteName.terms);
                },
              ),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/privacypolicy.png',
                title: 'Privacy Policy',
                onTap: () {
                  Get.toNamed(RouteName.privacyPolicy);
                },
              ),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/disclaimers.png',
                title: 'Disclaimers',
                onTap: () {
                  Get.toNamed(RouteName.disclaimers);
                },
              ),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/dataRetention.png',
                title: 'Data Retention',
                onTap: () {
                  Get.toNamed(RouteName.dataRetention);
                },
              ),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/dataRetention.png',
                title: 'Your path',
                onTap: () {
                  Get.toNamed(RouteName.progressPath);
                },
              ),
              SizedBox(height: 24.h),
              // Danger Actions Section
              _buildSectionTitle('Danger Actions'),
              SizedBox(height: 12.h),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/delete.png',
                title: 'Delete Account',
                onTap: () {
                  _showDeleteAccountDialog(context);
                },
                isDanger: true,
              ),
              _buildSettingsItem(
                iconPath: 'assets/images/splash/logout.png',
                title: 'Log out',
                onTap: () {
                  _showLogoutDialog(context);
                },
                isDanger: true,
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4.w),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.white.withOpacity(0.6),
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildSettingsItem({
    required String iconPath,
    required String title,
    required VoidCallback onTap,
    bool isDanger = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 8.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: isDanger ? const Color(0xFF202232) : const Color(0xFF47286F),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            // Icon
            Image.asset(iconPath, width: 40.w, height: 40.h),
            SizedBox(width: 14.w),
            // Title
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            // Arrow
            Icon(
              Icons.chevron_right,
              color: Colors.white.withOpacity(0.5),
              size: 22.sp,
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              // Content
              Text(
                'Are you sure, you want to delete this account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              // Buttons Row
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A3E),
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Delete Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // Handle delete account
                      },
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE57373),
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: Center(
                          child: Text(
                            'Delete',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (context) => Dialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Title
              Text(
                'Are you sure?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              // Content
              Text(
                'Are you sure, you want to log out from this account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              // Buttons Row
              Row(
                children: [
                  // Cancel Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2A3E),
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: Center(
                          child: Text(
                            'Cancel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Log out Button
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        // Handle logout
                        Get.offAllNamed('/sign_in');
                      },
                      child: Container(
                        height: 46.h,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE57373),
                          borderRadius: BorderRadius.circular(23.r),
                        ),
                        child: Center(
                          child: Text(
                            'Log out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
