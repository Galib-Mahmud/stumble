import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/profile_controller.dart';
import '../../widget/onboarding/custom_button.dart';

class EditProfileScreen extends StatelessWidget {
  EditProfileScreen({super.key});

  final ProfileController controller = Get.find<ProfileController>();

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
              // App Bar
              _buildAppBar(),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),

                        // Info Card
                        _buildInfoCard(),

                        SizedBox(height: 24.h),

                        // Full Name Field
                        _buildLabel('Full Name'),
                        _buildTextField(
                          controller: controller.fullNameController,
                          hintText: 'Enter your full name',
                        ),
                        SizedBox(height: 16.h),

                        // Username Field
                        _buildLabel('Username'),
                        _buildTextField(
                          controller: controller.usernameController,
                          hintText: 'Enter username',
                        ),
                        SizedBox(height: 16.h),

                        // Phone Field
                        _buildLabel('Phone'),
                        _buildPhoneField(),
                        SizedBox(height: 16.h),

                        // About me / Introduction Field
                        _buildLabel('About me'),
                        _buildTextField(
                          controller: controller.introductionController,
                          hintText: 'Tell us about yourself',
                          maxLines: 3,
                        ),
                        SizedBox(height: 16.h),

                        // Email (Read Only)
                        _buildLabel('Email (Cannot be changed)'),
                        _buildReadOnlyField(controller.email),
                        SizedBox(height: 16.h),

                        // Gender (Read Only)
                        _buildLabel('Gender (Cannot be changed)'),
                        _buildReadOnlyField(controller.gender),
                        SizedBox(height: 16.h),

                        // Age Range (Read Only)
                        _buildLabel('Age Range (Cannot be changed)'),
                        _buildReadOnlyField(controller.ageRange),
                        SizedBox(height: 30.h),

                        // Save Button
                        Obx(() => controller.isUpdating.value
                            ? Container(
                          width: double.infinity,
                          height: 50.h,
                          decoration: BoxDecoration(
                            color: const Color(0xFF09AFB9).withOpacity(0.5),
                            borderRadius: BorderRadius.circular(25.r),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 24.w,
                              height: 24.w,
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        )
                            : CustomButton(
                          text: 'Save Changes',
                          onTap: () => controller.updateProfile(),
                        ),
                        ),

                        SizedBox(height: 16.h),

                        // Cancel Button
                        GestureDetector(
                          onTap: () => Get.back(),
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
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 30.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
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
          SizedBox(width: 16.w),
          // Title
          Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF09AFB9).withOpacity(0.15),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: const Color(0xFF09AFB9).withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: const Color(0xFF09AFB9),
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              'You can only edit your name, username, phone and about section.',
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 13.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          // Flag
          Image.asset(
            'assets/images/avatar/flag.png',
            width: 24.w,
            height: 16.h,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: controller.phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: '+880 1XXX-XXXXXX',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadOnlyField(String value) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF222222).withOpacity(0.5),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value.isEmpty ? 'Not set' : value,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 14.sp,
              ),
            ),
          ),
          Icon(
            Icons.lock_outline,
            color: Colors.white.withOpacity(0.3),
            size: 18.sp,
          ),
        ],
      ),
    );
  }
}