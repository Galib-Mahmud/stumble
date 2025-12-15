import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../controller/profile_controller.dart';
import '../../widget/onboarding/custom_button.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  final ProfileController controller = Get.put(ProfileController());

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
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF09AFB9),
                      ),
                    );
                  }

                  if (controller.errorMessage.value.isNotEmpty) {
                    return _buildErrorWidget();
                  }

                  return _buildProfileContent();
                }),
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
          // Title
          Text(
            'Profile',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          // Settings Icon
          GestureDetector(
            onTap: () {
              Get.toNamed(RouteName.settings);
            },
            child: Icon(
              Icons.settings_outlined,
              color: Colors.white,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileContent() {
    return RefreshIndicator(
      onRefresh: controller.fetchProfile,
      color: const Color(0xFF09AFB9),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10.h),

              // Profile Avatar
              _buildProfileAvatar(),

              SizedBox(height: 12.h),

              // User Name
              Center(
                child: Obx(() => Text(
                  controller.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ),

              SizedBox(height: 4.h),

              // User Type
              Center(
                child: Text(
                  'Advanced User',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.5),
                    fontSize: 14.sp,
                  ),
                ),
              ),

              SizedBox(height: 24.h),

              // Full Name Field (Read Only)
              _buildLabel('Full Name'),
              _buildReadOnlyField(
                value: controller.fullNameController.text.isEmpty
                    ? 'Not set'
                    : controller.fullNameController.text,
              ),
              SizedBox(height: 16.h),

              // Username Field (Read Only)
              _buildLabel('Username'),
              _buildReadOnlyField(
                value: controller.usernameController.text.isEmpty
                    ? 'Not set'
                    : controller.usernameController.text,
              ),
              SizedBox(height: 16.h),

              // Email Field (Read Only - Not Editable)
              _buildLabel('Email address'),
              _buildReadOnlyField(
                value: controller.email.isEmpty ? 'Not set' : controller.email,
                isLocked: true,
              ),
              SizedBox(height: 16.h),

              // Phone Field (Read Only)
              _buildLabel('Phone'),
              _buildPhoneField(),
              SizedBox(height: 16.h),

              // About me Field (Read Only)
              _buildLabel('About me'),
              _buildReadOnlyField(
                value: controller.introductionController.text.isEmpty
                    ? 'Not set'
                    : controller.introductionController.text,
              ),
              SizedBox(height: 16.h),

              // Gender (Read Only - Not Editable)
              _buildLabel('Gender'),
              _buildReadOnlyField(
                value: controller.gender,
                isLocked: true,
              ),
              SizedBox(height: 16.h),

              // Age Range (Read Only - Not Editable)
              _buildLabel('Age Range'),
              _buildReadOnlyField(
                value: controller.ageRange,
                isLocked: true,
              ),
              SizedBox(height: 30.h),

              // Edit Button
              CustomButton(
                text: 'Edit Profile',
                onTap: () {
                  Get.toNamed(RouteName.editProfile);
                },
              ),
              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 90.w,
            height: 90.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF09AFB9),
                width: 3,
              ),
            ),
            child: ClipOval(
              child: Obx(() {
                final imageUrl = controller.profileImageUrl;
                if (imageUrl.isNotEmpty) {
                  return Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/avatar/avatar4.png',
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                              : null,
                          color: const Color(0xFF09AFB9),
                          strokeWidth: 2,
                        ),
                      );
                    },
                  );
                }
                return Image.asset(
                  'assets/images/avatar/avatar4.png',
                  fit: BoxFit.cover,
                );
              }),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              width: 28.w,
              height: 28.h,
              decoration: BoxDecoration(
                color: const Color(0xFF2A2A3E),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 14.sp,
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

  Widget _buildReadOnlyField({
    required String value,
    bool isLocked = false,
  }) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: const Color(0xFF222222),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: value == 'Not set' || value == 'Select'
                    ? Colors.white.withOpacity(0.4)
                    : Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
          if (isLocked)
            Icon(
              Icons.lock_outline,
              color: Colors.white.withOpacity(0.3),
              size: 18.sp,
            ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      height: 48.h,
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
            child: Text(
              controller.phoneController.text.isEmpty
                  ? '+880'
                  : controller.phoneController.text,
              style: TextStyle(
                color: controller.phoneController.text.isEmpty
                    ? Colors.white.withOpacity(0.4)
                    : Colors.white,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            color: Colors.red.withOpacity(0.7),
            size: 60.w,
          ),
          SizedBox(height: 16.h),
          Text(
            controller.errorMessage.value,
            style: TextStyle(
              color: Colors.white.withOpacity(0.7),
              fontSize: 14.sp,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: controller.fetchProfile,
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 24.w,
                vertical: 12.h,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFF09AFB9),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                "Retry",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}