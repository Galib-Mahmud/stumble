import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrbitQuotesScreen extends StatelessWidget {
  const OrbitQuotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Custom App Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Orbit',
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: const Color(0xFF3D3D3D),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 22.sp,
                  ),
                ),
              ],
            ),
          ),

          // Main Content with Background
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF1E1B4B),
                    Color(0xFF1E1B4B),
                    Color(0xFF0F172A),
                  ],
                ),
              ),
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  children: [
                    // Quote Cards Grid - Using IntrinsicHeight for proper alignment
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Left Column - 2 large cards
                          Expanded(
                            child: Column(
                              children: [
                                _buildQuoteCard(
                                  quote: "You are stronger than you think, even when you feel weak",
                                  gradientColors: const [
                                    Color(0xFF87CEEB),
                                    Color(0xFFDDA0DD),
                                    Color(0xFFFFB347),
                                  ],
                                  height: 280.h,
                                ),
                                SizedBox(height: 12.h),
                                _buildQuoteCard(
                                  quote: "You are not alone in this: even in darkness, there is a spark waiting to shine",
                                  gradientColors: const [
                                    Color(0xFF20B2AA),
                                    Color(0xFF98FB98),
                                    Color(0xFFFFB347),
                                  ],
                                  height: 300.h,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 12.w),
                          // Right Column - 4 smaller cards
                          Expanded(
                            child: Column(
                              children: [
                                _buildQuoteCard(
                                  quote: "You are worthy of love, care, and hope - always, no matter what",
                                  gradientColors: const [
                                    Color(0xFF6366F1),
                                    Color(0xFF8B5CF6),
                                    Color(0xFFEC4899),
                                  ],
                                  height: 180.h,
                                ),
                                SizedBox(height: 12.h),
                                _buildQuoteCard(
                                  quote: "You are worthy of love, care, and hope - always, no matter what",
                                  gradientColors: const [
                                    Color(0xFFFCD34D),
                                    Color(0xFFF97316),
                                  ],
                                  height: 180.h,
                                ),
                                SizedBox(height: 12.h),
                                _buildQuoteCard(
                                  quote: "You are worthy of love, care, and hope - always, no matter what",
                                  gradientColors: const [
                                    Color(0xFF06B6D4),
                                    Color(0xFF3B82F6),
                                    Color(0xFF10B981),
                                  ],
                                  height: 180.h,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 20.h),

                    // Bottom Motivational Quote Section - Using Image Asset
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.r),
                      child: Image.asset(
                        'assets/images/splash/orbit.png', // Update this path to match your asset location
                        width: double.infinity,
                        fit: BoxFit.fitWidth,
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
    );
  }

  Widget _buildQuoteCard({
    required String quote,
    required List<Color> gradientColors,
    required double height,
  }) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
      ),
      child: Stack(
        children: [
          // Quote Bubble
          Positioned(
            top: 16.h,
            left: 10.w,
            right: 10.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(14.r),
                  topRight: Radius.circular(14.r),
                  bottomRight: Radius.circular(14.r),
                  bottomLeft: Radius.circular(4.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Quote Icon
                  Container(
                    width: 28.w,
                    height: 22.h,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9500),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Center(
                      child: Text(
                        '66',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    quote,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.35,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),

          // Star Button
          Positioned(
            bottom: 14.h,
            right: 14.w,
            child: Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                color: const Color(0xFF5D4037),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.star,
                color: const Color(0xFFFFD700),
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}