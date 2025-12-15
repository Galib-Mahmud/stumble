import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../route/route_name.dart';
import '../../auth/controller/video_record_controller.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  final VideoRecordController controller = Get.put(VideoRecordController());

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
          padding: EdgeInsets.only(bottom: 140.h),
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
    return Obx(() => GestureDetector(
      onTap: controller.isUploading.value ? null : () => _showRecordingDialog(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: controller.isUploading.value
              ? const Color(0xFF253F5A).withOpacity(0.6)
              : const Color(0xFF253F5A),
          borderRadius: BorderRadius.circular(32.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (controller.isUploading.value)
              SizedBox(
                width: 25.w,
                height: 25.w,
                child: const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            else
              Image.asset(
                'assets/images/icon/video_record.png',
                width: 30.w,
                height: 25.w,
              ),
            SizedBox(width: 10.w),
            Text(
              controller.isUploading.value
                  ? "Uploading..."
                  : "Record a grounding Message",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Show Recording Dialog
  void _showRecordingDialog() {
    // Initialize camera when dialog opens
    controller.initCamera();

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1A2E3D),
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF253F5A),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20.r),
                    topRight: Radius.circular(20.r),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Record Video Message",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (controller.isRecording.value) {
                          controller.stopRecording();
                        }
                        controller.disposeCamera();
                        Get.back();
                      },
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Camera Preview
              Obx(() => Container(
                height: 350.h,
                width: double.infinity,
                margin: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: controller.isCameraInitialized.value &&
                      controller.cameraController != null
                      ? CameraPreview(controller.cameraController!)
                      : const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  ),
                ),
              )),

              // Recording Timer
              Obx(() => controller.isRecording.value
                  ? Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 8.h,
                ),
                margin: EdgeInsets.only(bottom: 16.h),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12.w,
                      height: 12.w,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Obx(() => Text(
                      controller.recordingTime.value,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    )),
                  ],
                ),
              )
                  : const SizedBox.shrink()),

              // Action Buttons
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() => Row(
                  children: [
                    // Cancel Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          if (controller.isRecording.value) {
                            controller.stopRecording();
                          }
                          controller.disposeCamera();
                          Get.back();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Text(
                              "Cancel",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Record/Stop Button
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          if (controller.isRecording.value) {
                            // Stop recording and upload
                            final file = await controller.stopRecording();
                            controller.disposeCamera();
                            Get.back();
                            if (file != null) {
                              await controller.uploadVideo(file);
                            }
                          } else {
                            // Start recording
                            await controller.startRecording();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          decoration: BoxDecoration(
                            color: controller.isRecording.value
                                ? Colors.red
                                : const Color(0xFF4EFFEE),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  controller.isRecording.value
                                      ? Icons.stop
                                      : Icons.fiber_manual_record,
                                  color: controller.isRecording.value
                                      ? Colors.white
                                      : Colors.black,
                                  size: 20.w,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  controller.isRecording.value
                                      ? "Stop & Upload"
                                      : "Start Recording",
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: controller.isRecording.value
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
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