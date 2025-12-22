import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/feature/widget/condition/custom_appbar2.dart';

import '../controller/progress_controller.dart';


class ProgressPathScreen extends StatelessWidget {
  final String backgroundImage;
  final String pathImage;
  final VoidCallback? onTap;

  const ProgressPathScreen({
    super.key,
    this.backgroundImage = 'assets/images/splash/background.png',
    this.pathImage = 'assets/images/splash/path.png',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProgressPathController());
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: CustomAppBar2(title: '', onBack: () => Get.back()),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background image
          Image.asset(
            backgroundImage,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Scrollable content
          SafeArea(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                );
              }

              if (controller.errorMessage.isNotEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14.sp,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16.h),
                      ElevatedButton(
                        onPressed: () => controller.refresh(),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: () => controller.refresh(),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      SizedBox(height: 20.h),

                      // Title
                      Text(
                        'Your Progress Path',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w500,
                          letterSpacing: 0.8,
                        ),
                      ),

                      SizedBox(height: 8.h),

                      // Progress summary
                      Text(
                        '${controller.completedMilestones}/${controller.totalMilestones} Milestones • ${controller.progressPercentage}%',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 16.sp,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      // Path with milestones overlay
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: _buildPathWithMilestones(controller, screenWidth),
                      ),

                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPathWithMilestones(ProgressPathController controller, double screenWidth) {
    // Milestone positions (approximate - adjust based on your path image)
    // Format: {milestone_key: {top: %, left: %}}
    final Map<String, Map<String, double>> milestonePositions = {
      'START': {'top': 0.006, 'left': 0.44},
      'PLEASURE': {'top': 0.15, 'left': 0.76},
      'INTEGRATE': {'top': 0.28, 'left': 0.09},
      'COMPASSION': {'top': 0.33, 'left': 0.74},
      'MANIFEST': {'top': 0.47, 'left': 0.43},
      'SERVICE': {'top': 0.65, 'left': 0.12},
      'WILLING': {'top': 0.74, 'left': 0.75},
      'OPEN': {'top': 0.89, 'left': 0.24},
      'ACCEPT': {'top': 1.07, 'left': 0.54},
      'FINISH': {'top': 1.27, 'left': 0.41},
    };

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            // Static path image
            Padding(
              padding:  EdgeInsets.only(left: 20.w, right: 30.w),
              child: Image.asset(
                pathImage,
                fit: BoxFit.fitWidth,
                width: double.infinity,
              ),
            ),

            // Milestone overlays - positioned on top of path
            ...controller.milestones.map((milestone) {
              final key = milestone['milestone'] as String;
              final position = milestonePositions[key];

              if (position == null) return const SizedBox.shrink();

              return Positioned(
                top: position['top']! * constraints.maxWidth * 2.5, // Adjust multiplier based on image aspect ratio
                left: position['left']! * constraints.maxWidth,
                child: _buildMilestoneOverlay(
                  milestone: milestone,
                  isCompleted: milestone['completed'] == true,
                ),
              );
            }).toList(),
          ],
        );
      },
    );
  }

  Widget _buildMilestoneOverlay({
    required Map<String, dynamic> milestone,
    required bool isCompleted,
  }) {
    final name = milestone['milestone'] ?? '';
    final subtitle = milestone['milestone_name'] ?? '';

    return GestureDetector(
      onTap: () {
        // Optional: Show milestone details
        _showMilestoneDetails(milestone);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Glowing dot for completed milestones
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted
                  ? const Color(0xFFE040FB)
                  : Colors.blueAccent.withOpacity(0.2),
              boxShadow: isCompleted
                  ? [
                BoxShadow(
                  color: const Color(0xFFE040FB).withOpacity(0.6),
                  blurRadius: 8,
                  spreadRadius: 4,
                ),
                BoxShadow(
                  color: const Color(0xFFE040FB).withOpacity(0.4),
                  blurRadius: 20,
                  spreadRadius: 8,
                ),
              ]
                  : null,
            ),
            child: isCompleted
                ? Icon(
              Icons.check,
              color: Colors.white,
              size: 18.sp,
              fontWeight: FontWeight.bold,
            )
                : null,
          ),

          SizedBox(height: 5.h),

          // Milestone name
          Padding(
            padding: EdgeInsets.only(right:20.w),
            child: Text(
              name,
              style: TextStyle(
                color: isCompleted ? const Color(0xFFE040FB) : Colors.white,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Milestone subtitle
          Padding(
            padding:  EdgeInsets.only(right: 20.w),
            child: Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMilestoneDetails(Map<String, dynamic> milestone) {
    final isCompleted = milestone['completed'] == true;
    final completedAt = milestone['completed_at'];

    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A2E),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted
                        ? const Color(0xFFE040FB)
                        : Colors.blueAccent,
                  ),
                  child: Icon(
                    isCompleted ? Icons.check : Icons.lock_outline,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Text(
                        milestone['milestone'] ?? '',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        milestone['milestone_name'] ?? '',
                        style: TextStyle(
                          color: Colors.lightBlue,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                children: [
                  Icon(
                    isCompleted ? Icons.check_circle : Icons.pending,
                    color: isCompleted ? Colors.green : Colors.orange,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    isCompleted
                        ? 'Completed${completedAt != null ? ' on ${_formatDate(completedAt)}' : ''}'
                        : 'Not yet completed',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return '';
    }
  }
}