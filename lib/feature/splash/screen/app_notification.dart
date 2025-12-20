import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppNotification {
  static void show({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
    bool autoDismiss = true,
  }) {
    // Remove any existing notification first
    if (Get.isOverlaysOpen) {
      Get.back();
    }

    Get.dialog(
      _NotificationOverlay(
        title: title,
        message: message,
        duration: duration,
        autoDismiss: autoDismiss,
      ),
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      useSafeArea: false,
    );
  }

  // Quick methods - all same style
  static void success(String message, {String title = "Success"}) {
    show(title: title, message: message);
  }

  static void error(String message, {String title = "Error", bool autoDismiss = true}) {
    show(title: title, message: message, autoDismiss: autoDismiss);
  }

  static void warning(String message, {String title = "Warning"}) {
    show(title: title, message: message);
  }

  static void info(String message, {String title = "Info"}) {
    show(title: title, message: message);
  }
}

class _NotificationOverlay extends StatefulWidget {
  final String title;
  final String message;
  final Duration duration;
  final bool autoDismiss;

  const _NotificationOverlay({
    required this.title,
    required this.message,
    required this.duration,
    required this.autoDismiss,
  });

  @override
  State<_NotificationOverlay> createState() => _NotificationOverlayState();
}

class _NotificationOverlayState extends State<_NotificationOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();

    if (widget.autoDismiss) {
      // Calculate duration based on message length
      final baseDuration = widget.duration.inMilliseconds;
      final extraTime = (widget.message.length / 50) * 1000;
      final totalDuration = Duration(milliseconds: baseDuration + extraTime.toInt());

      Future.delayed(totalDuration, () {
        _dismiss();
      });
    }
  }

  void _dismiss() async {
    if (mounted && _controller.isCompleted) {
      await _controller.reverse();
      if (Get.isOverlaysOpen) {
        Get.back();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        onTap: _dismiss,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            // Tap outside to dismiss
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),

            // Notification
            Align(
              alignment: Alignment.topCenter,
              child: SlideTransition(
                position: _slideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: GestureDetector(
                    onTap: () {}, // Prevent dismiss when tapping notification
                    onVerticalDragEnd: (details) {
                      if (details.velocity.pixelsPerSecond.dy < -100) {
                        _dismiss();
                      }
                    },
                    child: Container(
                      constraints: BoxConstraints(
                        maxWidth: screenWidth - 32,
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      margin: EdgeInsets.only(
                        top: topPadding + 10,
                        left: 16,
                        right: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        // Default snackbar dark color
                        color: const Color(0xFF323232),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Content
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  widget.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxHeight: MediaQuery.of(context).size.height * 0.35,
                                  ),
                                  child: SingleChildScrollView(
                                    child: Text(
                                      widget.message,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white.withOpacity(0.85),
                                        height: 1.4,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Close Button
                          GestureDetector(
                            onTap: _dismiss,
                            behavior: HitTestBehavior.opaque,
                            child: Padding(
                              padding: const EdgeInsets.all(2),
                              child: Icon(
                                Icons.close,
                                color: Colors.white.withOpacity(0.7),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}