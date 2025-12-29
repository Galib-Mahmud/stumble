import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../route/route_name.dart';
import '../../auth/controller/video_record_controller.dart';
import '../controller/support_controller.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});

  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen>
    with SingleTickerProviderStateMixin {
  final VideoRecordController controller = Get.put(VideoRecordController());
  final SupportController supportController = Get.put(SupportController());

  int selectedModeIndex = 0; // 0: Gentle, 1: Critical, 2: Urgent

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Emergency numbers for Urgent mode
  final List<Map<String, String>> emergencyNumbers = [
    {'name': 'Emergency Services', 'number': '911', 'icon': 'emergency'},
    {'name': 'National Crisis Hotline', 'number': '988', 'icon': 'crisis'},
    {'name': 'Suicide Prevention', 'number': '1-800-273-8255', 'icon': 'prevention'},
    {'name': 'Crisis Text Line', 'number': 'Text HOME to 741741', 'icon': 'text'},
    {'name': 'International Emergency', 'number': '112', 'icon': 'international'},
  ];

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
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Obx(() => Row(
                  children: [
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
                    Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () async {
                          if (controller.isRecording.value) {
                            final file = await controller.stopRecording();
                            controller.disposeCamera();
                            Get.back();
                            if (file != null) {
                              await controller.uploadVideo(file);
                            }
                          } else {
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

  // ============== MODE POPUP DIALOGS ==============

  // Show Gentle Mode Popup - STATIC (No API call)
  void _showGentleModePopup() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 60.h),
        child: Container(
          constraints: BoxConstraints(maxHeight: 500.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1A3A4A),
                Color(0xFF0D2535),
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: const Color(0xFF4EFFEE).withOpacity(0.3),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPopupHeader(
                title: 'Gentle Support',
                color: const Color(0xFF4EFFEE),
                icon: Icons.spa_outlined,
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(24.w),
                  child: Column(
                    children: [
                      Container(
                        width: 100.w,
                        height: 100.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF4EFFEE).withOpacity(0.3),
                              const Color(0xFF4EFFEE).withOpacity(0.1),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.touch_app_rounded,
                          size: 50.w,
                          color: const Color(0xFF4EFFEE),
                        ),
                      ),
                      SizedBox(height: 24.h),
                      Text(
                        "Please tap on the middle button of this app",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "The center support button provides calming exercises and grounding techniques to help you feel better.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      GestureDetector(
                        onTap: () => Get.back(),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16.h),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF4EFFEE), Color(0xFF00D9C6)],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: Center(
                            child: Text(
                              "Got it!",
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // Show Critical Mode Popup - DYNAMIC (API call)
  void _showCriticalModePopup() {
    // Call API for critical mode
    supportController.requestSupport('critical');


  }

  // Show Urgent Mode Popup - STATIC (No API call)
  void _showUrgentModePopup() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 40.h),
        child: Container(
          constraints: BoxConstraints(maxHeight: 600.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4A1A1A),
                Color(0xFF2D0D0D),
              ],
            ),
            borderRadius: BorderRadius.circular(24.r),
            border: Border.all(
              color: Colors.red.withOpacity(0.4),
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPopupHeader(
                title: 'Emergency Support',
                color: Colors.red,
                icon: Icons.emergency,
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16.r),
                          border: Border.all(
                            color: Colors.red.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                              size: 28.w,
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Text(
                                "Emergency Phone Numbers",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.h),
                      ...emergencyNumbers.map((emergency) =>
                          _buildEmergencyCard(emergency)
                      ),
                      SizedBox(height: 16.h),
                      Container(
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.red.withOpacity(0.8),
                              size: 28.w,
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "You are not alone. Help is available 24/7.",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white.withOpacity(0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  // Build Popup Header with Close Button
  Widget _buildPopupHeader({
    required String title,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24.w),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.close,
                color: Colors.white,
                size: 20.w,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Build Emergency Card for Urgent Mode
  Widget _buildEmergencyCard(Map<String, String> emergency) {
    return GestureDetector(
      onTap: () {
        if (!emergency['number']!.startsWith('Text')) {
          _makePhoneCall(emergency['number']!);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: Colors.red.withOpacity(0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.call,
                color: Colors.red,
                size: 26.w,
              ),
            ),
            SizedBox(width: 14.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    emergency['name']!,
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    emergency['number']!,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.red,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Make Phone Call
  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber.replaceAll(RegExp(r'[^\d+]'), ''),
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
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

          // Show appropriate popup based on selected mode
          switch (index) {
            case 0:
              _showGentleModePopup(); // Static
              break;
            case 1:
              _showCriticalModePopup(); // Dynamic - API call
              break;
            case 2:
              _showUrgentModePopup(); // Static
              break;
          }
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