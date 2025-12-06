import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:stumble/feature/splash/screen/onboarding_screen1.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    OnboardingScreen1(),
    OnboardingScreen1(),
    OnboardingScreen1(),
    OnboardingScreen1(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 65,
        width: 65,
        margin: EdgeInsets.only(top: 40.h),

        child: FloatingActionButton(
          elevation: 0,

          backgroundColor: Colors.white,
          onPressed: () {
            // Center button action
          },


          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100.r),
          ),

          child: Image.asset(
            'assets/home/Journal.png',
            width: 24.w,
            height: 24.h,
          ),




        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        height: 100.h,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF10042A),
          borderRadius: BorderRadius.circular(40.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: SizedBox(
              height: 60.h,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    iconPath: 'assets/home/Journal.png',
                    label: 'Orbit',
                    index: 0,
                  ),
                  _buildNavItem(
                    iconPath: 'assets/home/Journal.png',
                    label: 'SOS',
                    index: 1,
                  ),
                  SizedBox(width: 60.w), // Space for FAB
                  _buildNavItem(
                    iconPath: 'assets/home/Journal.png',
                    label: 'Journal',
                    index: 2,
                  ),
                  _buildNavItem(
                    iconPath: 'assets/home/Journal.png',
                    label: 'Dashboard',
                    index: 3,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _currentIndex = index;
        }),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                iconPath,
                width: 28.w,
                height: 28.h,
                color: isSelected
                    ? const Color(0xFF4EFFEE)
                    : Colors.white.withOpacity(0.5),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? const Color(0xFF4EFFEE)
                      : Colors.white.withOpacity(0.5),
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}