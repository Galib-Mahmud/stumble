import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../route/route_name.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  int selectedModeIndex = 0; // 0: Gentle, 1: Critical, 2: Urgent

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/avatar/sos.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: 140.h), // Navbar padding
          child: Column(
            children: [
              SizedBox(height: 16.h),

              // Top Bar - Title and Settings
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose the support",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        Text(
                          "you need",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.toNamed(RouteName.settings);
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.15),
                        ),
                        child: Icon(
                          Icons.settings,
                          color: Colors.white.withOpacity(0.8),
                          size: 20.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),

              // Support Circle - Centered
              _buildSupportCircle(),

              SizedBox(height: 40.h),

              // Record Button
              _buildRecordButton(),

              SizedBox(height: 60.h),

              // Support Modes Title
              Text(
                "Support Modes",
                style: TextStyle(
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              SizedBox(height: 20.h),

              // Support Mode Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  children: [
                    _buildModeItem(
                      index: 0,
                      iconPath: 'assets/images/icon/gentle.png',
                    ),
                    SizedBox(width: 12.w),
                    _buildModeItem(
                      index: 1,
                      iconPath: 'assets/images/icon/critical.png',
                    ),
                    SizedBox(width: 12.w),
                    _buildModeItem(
                      index: 2,
                      iconPath: 'assets/images/icon/urgent.png',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Support Circle
  Widget _buildSupportCircle() {
    return AnimatedBuilder(
      animation: _pulseController,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () {
          // Handle tap
        },
        child: Image.asset(
          'assets/images/avatar/support.png',
          width: 250.w,
          height: 250.w,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  // Record Button
  Widget _buildRecordButton() {
    return GestureDetector(
      onTap: () {
        // Handle record tap
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Color(0xFF253F5A),
          borderRadius: BorderRadius.circular(32.r),

        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/icon/video_record.png',
              width: 30.w,
              height: 25.w,
            ),
            SizedBox(width: 10.w),
            Text(
              "Record a grounding Message",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Mode Item Button
  Widget _buildModeItem({
    required int index,
    required String iconPath,
  }) {
    bool isSelected = selectedModeIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedModeIndex = index;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: isSelected
                ? [
              BoxShadow(
                color: const Color(0xFF4EFFEE).withOpacity(0.3),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ]
                : null,
          ),
          child: Image.asset(
            iconPath,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}