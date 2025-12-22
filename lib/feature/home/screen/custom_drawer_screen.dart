import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../../../core/local_storage/user_info.dart';
import '../../splash/controller/badge_controller.dart';
import '../controller/profile_controller.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onClose;

  CustomDrawer({super.key, required this.onClose});
  final ProfileController controller = Get.put(ProfileController());
  final BadgesController badgesController = Get.put(BadgesController());

  // Handle logout
  Future<void> _handleLogout(BuildContext context) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: Colors.white,
        ),
      ),
      barrierDismissible: false,
    );

    await UserInfo.clearAll();
    Get.back();
    Get.offAllNamed(RouteName.onboarding);
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
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: const Color(0xFFE57373).withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.logout_rounded,
                  color: const Color(0xFFE57373),
                  size: 28.sp,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'Log Out?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Are you sure you want to log out from your account?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                children: [
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
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _handleLogout(context);
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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.w,
      height: double.infinity,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with logo and close button
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    'assets/images/splash/stumble.png',
                    fit: BoxFit.cover,
                  ),
                  GestureDetector(
                    onTap: onClose,
                    child: Container(
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white.withOpacity(0.9),
                        size: 24.w,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            // ✅ FIXED: Profile Section wrapped in Obx
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(() {
                final profileImage = controller.profileImageUrl;
                final fullName = controller.profileData.value?.profile.fullName ?? 'Not set';
                final email = controller.email;

                return Row(
                  children: [
                    // ✅ FIXED: Profile Avatar with network image
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF6B4EAA), Color(0xFF9B6BFF)],
                        ),
                        border: Border.all(
                          color: const Color(0xFF4EFFEE),
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: profileImage.isNotEmpty
                            ? Image.network(
                          profileImage,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white54,
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 28.w,
                            );
                          },
                        )
                            : Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 28.w,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Name and Email
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName.isEmpty ? 'Not set' : fullName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            email.isEmpty ? 'Not set' : email,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 12.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),

            SizedBox(height: 12.h),

            // Badge Section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF232244),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Obx(() {
                  final currentBadge = badgesController.badges
                      .firstWhereOrNull((b) => b['unlocked'] == true);

                  return InkWell(
                    onTap: () {
                      Get.toNamed(RouteName.yourBadges);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (currentBadge != null) ...[
                          ClipOval(
                            child: _buildBadgeImage(
                              badgesController.getBadgeImage(currentBadge['code'] ?? ''),
                              currentBadge,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            currentBadge['name'] ?? "Badge",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ] else ...[
                          Icon(
                            Icons.workspace_premium,
                            color: Colors.white.withOpacity(0.5),
                            size: 20.w,
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "No Badge",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }),
              ),
            ),

            SizedBox(height: 30.h),

            // Menu Items
            _buildMenuItem(
              icon: 'assets/images/icon/video_icon.png',
              label: 'My Videos',
              onTap: () {
                Get.toNamed(RouteName.videoList);
              },
            ),
            _buildMenuItem(
              icon: 'assets/images/icon/dashboard_icon.png',
              label: 'Dashboard',
              onTap: () {
                Get.toNamed(RouteName.homeDashboard);
              },
            ),
            _buildMenuItem(
              icon: 'assets/images/icon/settings_icon.png',
              label: 'Settings',
              onTap: () {
                Get.toNamed(RouteName.settings);
              },
            ),

            const Spacer(),

            Builder(
              builder: (context) => _buildMenuItem(
                icon: 'assets/images/icon/logout.png',
                label: 'Log out',
                onTap: () {
                  _showLogoutDialog(context);
                },
                isLogout: true,
              ),
            ),

            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }

  // ✅ NEW: Helper to build badge image (handles both asset and network)
  Widget _buildBadgeImage(String imagePath, Map<String, dynamic> badge) {
    // Check if API provides image URL
    final apiImageUrl = badge['image'] ?? badge['image_url'] ?? '';

    if (apiImageUrl.toString().isNotEmpty &&
        (apiImageUrl.toString().startsWith('http://') ||
            apiImageUrl.toString().startsWith('https://'))) {
      // Use network image from API
      return Image.network(
        apiImageUrl.toString(),
        width: 20.w,
        height: 20.w,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.workspace_premium,
            color: const Color(0xFF4CAF50),
            size: 20.w,
          );
        },
      );
    }

    // Fallback to local asset
    return Image.asset(
      imagePath,
      width: 20.w,
      height: 20.w,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.workspace_premium,
          color: const Color(0xFF4CAF50),
          size: 20.w,
        );
      },
    );
  }

  Widget _buildMenuItem({
    required String icon,
    required String label,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              fit: BoxFit.cover,
              color: isLogout ? const Color(0xFFFF5252) : null,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported,
                  color: Colors.white.withOpacity(0.5),
                  size: 24.w,
                );
              },
            ),
            SizedBox(width: 18.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: Colors.white,
              size: 24.w,
            ),
          ],
        ),
      ),
    );
  }
}