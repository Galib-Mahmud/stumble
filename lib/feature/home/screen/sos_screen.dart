import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Background image
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/avatar/sos.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
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
                    // Title text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Choose the support",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                        Text(
                          "you need",
                          style: TextStyle(
                            fontSize: 22.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                    // Settings icon
                    Container(
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
                  ],
                ),
              ),

              // Support Circle - Aligned to left
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: _buildSupportCircle(),
                ),
              ),

              // Record Button
              _buildRecordButton(),

              SizedBox(height: 28.h),

              // Support Modes Title
              Text(
                "Support Modes",
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),

              SizedBox(height: 16.h),

              // Support Mode Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildModeItem(
                      label: 'Gentle',
                      index: 0,
                      color: const Color(0xFFFFD93D), // Yellow
                    ),
                    _buildModeItem(
                      label: 'Critical',
                      index: 1,
                      color: const Color(0xFFFF9500), // Orange
                    ),
                    _buildModeItem(
                      label: 'Urgent',
                      index: 2,
                      color: const Color(0xFFFF6B35), // Red-Orange
                    ),
                  ],
                ),
              ),

              SizedBox(height: 50.h),
            ],
          ),
        ),
      ),
    );
  }

  // Support Circle - Using image asset with pulse animation
  Widget _buildSupportCircle() {
    return Padding(
      padding: const EdgeInsets.only(right: 110),
      child: AnimatedBuilder(
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

            fit: BoxFit.contain,
          ),
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
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(25.r),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Red record icon
            Container(
              width: 20.w,
              height: 20.w,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFFF3B30),
              ),
              child: Center(
                child: Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.r),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              "Record a grounding Message",
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
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
    required String label,
    required int index,
    required Color color,
  }) {
    bool isSelected = selectedModeIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedModeIndex = index;
        });
      },
      child: Column(
        children: [
          Container(
            width: 75.w,
            height: 75.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C2E),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isSelected
                    ? const Color(0xFF4EFFEE)
                    : const Color(0xFF2A2A3E),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: const Color(0xFF4EFFEE).withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ]
                  : null,
            ),
            child: Center(
              child: Icon(
                Icons.warning_amber_rounded,
                color: color,
                size: 34.w,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: isSelected
                  ? const Color(0xFF4EFFEE)
                  : Colors.white.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }
}