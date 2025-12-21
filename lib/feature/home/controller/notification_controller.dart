import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/endpoint/api_client.dart';
import '../../../core/endpoint/api_endpoint.dart';
import '../../../core/local_storage/user_info.dart';


class NotificationController extends GetxController {
  final ApiClient _apiClient = ApiClient(baseUrl: ApiEndpoint.baseUrl);

  // Observables
  var isLoading = false.obs;
  var notifications = <NotificationItem>[].obs;
  var totalCount = 0.obs;
  var unreadCount = 0.obs;
  var readCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotificationStats();
  }

  /// Get auth headers
  Future<Map<String, String>> _getAuthHeaders() async {
    final token = await UserInfo.getAccessToken();
    return {
      "Authorization": "Bearer $token",
    };
  }

  /// Fetch all notifications
  Future<void> fetchNotifications() async {
    try {
      isLoading.value = true;
      final headers = await _getAuthHeaders();
      final response = await _apiClient.get(
        ApiEndpoint.notifications,
        headers: headers,
      );

      if (response != null && response['success'] == true) {
        final List<dynamic> results = response['results'] ?? [];
        notifications.value = results
            .map((json) => NotificationItem.fromJson(json))
            .toList();
      }
    } catch (e) {
      print("❌ Error fetching notifications: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch notification stats (for badge count)
  Future<void> fetchNotificationStats() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiClient.get(
        ApiEndpoint.notificationStats,
        headers: headers,
      );

      if (response != null && response['success'] == true) {
        final data = response['data'];
        totalCount.value = data['total_count'] ?? 0;
        unreadCount.value = data['unread_count'] ?? 0;
        readCount.value = data['read_count'] ?? 0;
      }
    } catch (e) {
      print("❌ Error fetching notification stats: $e");
    }
  }

  /// Mark all notifications as read
  Future<void> markAllAsRead() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiClient.patch(
        ApiEndpoint.notifications,
        headers: headers,
      );

      if (response != null && response['success'] == true) {
        // Update local state
        for (var notification in notifications) {
          notification.isRead = true;
        }
        notifications.refresh();
        unreadCount.value = 0;
        readCount.value = totalCount.value;

        Get.snackbar(
          "Success",
          response['message'] ?? "All notifications marked as read",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print("❌ Error marking notifications as read: $e");
    }
  }

  /// Delete all notifications
  Future<void> deleteAllNotifications() async {
    try {
      final headers = await _getAuthHeaders();
      final response = await _apiClient.delete(
        ApiEndpoint.notifications,
        headers: headers,
      );

      if (response != null && response['success'] == true) {
        notifications.clear();
        totalCount.value = 0;
        unreadCount.value = 0;
        readCount.value = 0;

        Get.snackbar(
          "Success",
          response['message'] ?? "All notifications cleared",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green.withOpacity(0.8),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      print("❌ Error deleting notifications: $e");
    }
  }

  /// Show notification bottom sheet
  void showNotificationSheet() {
    fetchNotifications(); // Refresh notifications when opening

    Get.bottomSheet(
      NotificationBottomSheet(controller: this),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  /// Get icon for notification type
  IconData getNotificationIcon(String type) {
    switch (type) {
      case 'reward':
        return Icons.star_rounded;
      case 'achievement':
        return Icons.emoji_events_rounded;
      case 'message':
        return Icons.message_rounded;
      case 'reminder':
        return Icons.alarm_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  /// Get color for notification type
  Color getNotificationColor(String type) {
    switch (type) {
      case 'reward':
        return const Color(0xFFFFD700);
      case 'achievement':
        return const Color(0xFF4CAF50);
      case 'message':
        return const Color(0xFF2196F3);
      case 'reminder':
        return const Color(0xFFFF9800);
      default:
        return const Color(0xFF9C27B0);
    }
  }

  /// Format time ago
  String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }
}

/// Notification Item Model (inline to keep it simple)
class NotificationItem {
  final int id;
  final String notificationType;
  final String title;
  final String message;
  final String? actionLink;
  bool isRead;
  final DateTime createdAt;

  NotificationItem({
    required this.id,
    required this.notificationType,
    required this.title,
    required this.message,
    this.actionLink,
    required this.isRead,
    required this.createdAt,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? 0,
      notificationType: json['notification_type'] ?? 'general',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      actionLink: json['action_link'],
      isRead: json['is_read'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}

/// Notification Bottom Sheet Widget
class NotificationBottomSheet extends StatelessWidget {
  final NotificationController controller;

  const NotificationBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Header
          Padding(
            padding: EdgeInsets.all(20.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Notifications",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Row(
                  children: [
                    // Mark all as read
                    Obx(() => controller.unreadCount.value > 0
                        ? GestureDetector(
                      onTap: () => controller.markAllAsRead(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.done_all,
                              size: 16.sp,
                              color: Colors.white70,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Read all",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.white70,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                        : const SizedBox()),
                    SizedBox(width: 8.w),

                    // Delete all
                    Obx(() => controller.notifications.isNotEmpty
                        ? GestureDetector(
                      onTap: () => _showDeleteConfirmation(context),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Icon(
                          Icons.delete_outline,
                          size: 20.sp,
                          color: Colors.redAccent,
                        ),
                      ),
                    )
                        : const SizedBox()),
                  ],
                ),
              ],
            ),
          ),

          // Stats bar
          Obx(() => Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  "Total",
                  controller.totalCount.value.toString(),
                  Icons.notifications_rounded,
                ),
                Container(
                  width: 1,
                  height: 30.h,
                  color: Colors.white.withOpacity(0.1),
                ),
                _buildStatItem(
                  "Unread",
                  controller.unreadCount.value.toString(),
                  Icons.mark_email_unread_rounded,
                  color: Colors.orangeAccent,
                ),
                Container(
                  width: 1,
                  height: 30.h,
                  color: Colors.white.withOpacity(0.1),
                ),
                _buildStatItem(
                  "Read",
                  controller.readCount.value.toString(),
                  Icons.mark_email_read_rounded,
                  color: Colors.greenAccent,
                ),
              ],
            ),
          )),

          SizedBox(height: 16.h),

          // Notification list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.white.withOpacity(0.5),
                    strokeWidth: 2,
                  ),
                );
              }

              if (controller.notifications.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.notifications_off_outlined,
                        size: 64.sp,
                        color: Colors.white.withOpacity(0.3),
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        "No notifications yet",
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.notifications.length,
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return _buildNotificationTile(notification);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon,
      {Color? color}) {
    return Column(
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 16.sp,
              color: color ?? Colors.white70,
            ),
            SizedBox(width: 4.w),
            Text(
              value,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 11.sp,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationTile(NotificationItem notification) {
    final iconColor = controller.getNotificationColor(notification.notificationType);
    final icon = controller.getNotificationIcon(notification.notificationType);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: notification.isRead
            ? Colors.white.withOpacity(0.03)
            : Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16.r),
        border: notification.isRead
            ? null
            : Border.all(
          color: iconColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22.sp,
            ),
          ),
          SizedBox(width: 14.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        notification.title,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: notification.isRead
                              ? FontWeight.w500
                              : FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    if (!notification.isRead)
                      Container(
                        width: 8.w,
                        height: 8.w,
                        decoration: BoxDecoration(
                          color: iconColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  notification.message,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  controller.formatTimeAgo(notification.createdAt),
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: Colors.white.withOpacity(0.4),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF1A1A2E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: Text(
          "Clear All Notifications?",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "This action cannot be undone. All notifications will be permanently deleted.",
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Cancel",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAllNotifications();
            },
            child: Text(
              "Delete All",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}