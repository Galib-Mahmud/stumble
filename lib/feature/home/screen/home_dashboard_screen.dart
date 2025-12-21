import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

// Import the controllers
import '../controller/notification_controller.dart';
import '../controller/task_controller.dart';
import '../controller/xp_controller.dart';

import '../events/bot_controller.dart';
import 'app_drawer_controller.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  // Initialize Controllers
  final XpController xpController = Get.put(XpController());
  final BotController botController = Get.put(BotController());
  final NotificationController notificationController = Get.put(NotificationController());
  final TaskController taskController = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/avatar/Home Dashboard.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h),
                _buildTopBar(),
                SizedBox(height: 24.h),
                _buildWelcomeText(),
                SizedBox(height: 24.h),
                _buildXPGaugeCard(),
                SizedBox(height: 24.h),
                SizedBox(height: 24.h),
                _buildBotsSection(),
                SizedBox(height: 24.h),
                _buildYourTasksSection(),
                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(
          'assets/images/avatar/Frame2.png',
          fit: BoxFit.cover,
        ),
        Row(
          children: [
            _buildNotificationIcon(),
            SizedBox(width: 12.w),
            _buildTopIcon(
              'assets/images/avatar/settings.png',
              onTap: () {
                Get.toNamed(RouteName.settings);
              },
            ),
            SizedBox(width: 12.w),
            GestureDetector(
              onTap: () {
                Get.toNamed(RouteName.profile);
              },
              child: Container(
                width: 36.w,
                height: 36.w,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/images/avatar/profile.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotificationIcon() {
    return GestureDetector(
      onTap: () {
        notificationController.showNotificationSheet();
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.2),
            ),
            child: Center(
              child: Image.asset(
                'assets/images/avatar/notification.png',
                width: 20.w,
                height: 20.w,
              ),
            ),
          ),
          Obx(() {
            if (notificationController.unreadCount.value > 0) {
              return Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints: BoxConstraints(
                    minWidth: 18.w,
                    minHeight: 18.w,
                  ),
                  child: Center(
                    child: Text(
                      notificationController.unreadCount.value > 9
                          ? '9+'
                          : '${notificationController.unreadCount.value}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildTopIcon(String iconPath, {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.2),
        ),
        child: Center(
          child: Image.asset(
            iconPath,
            width: 20.w,
            height: 20.w,
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Let's grow",
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.2,
          ),
        ),
        Text(
          "a little today",
          style: TextStyle(
            fontSize: 32.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildXPGaugeCard() {
    return GestureDetector(
      onTap: () {
        xpController.showXpDetailsDialog();
      },
      child: Stack(
        children: [
          Image.asset(
            'assets/images/avatar/xpDetails.png',
            width: double.infinity,
            fit: BoxFit.fitWidth,
          ),
          Positioned(
            top: 60.h,
            left: 168.w,
            child: Obx(() {
              if (xpController.isLoading.value) {
                return SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                );
              }
              return Text(
                '${xpController.totalPoints.value}',
                style: TextStyle(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.5),
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBotsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Stumble events",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        SizedBox(
          height: 160.h,
          child: Obx(() {
            if (botController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.white.withOpacity(0.5),
                  strokeWidth: 2,
                ),
              );
            }

            if (botController.bots.isEmpty) {
              return Center(
                child: Text(
                  "No events available",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              );
            }

            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: botController.bots.length,
              itemBuilder: (context, index) {
                final bot = botController.bots[index];
                return _buildBotCard(bot);
              },
            );
          }),
        ),
      ],
    );
  }

  Widget _buildBotCard(BotModel bot) {
    return GestureDetector(
      onTap: () {
        botController.selectBot(bot);
        Get.toNamed(RouteName.botChat);
      },
      child: Container(
        width: 140.w,
        margin: EdgeInsets.only(right: 12.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              bot.botColor.withOpacity(0.8),
              bot.botColor.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: bot.botColor.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -20.w,
              top: -20.h,
              child: Icon(
                bot.botIcon,
                size: 100.sp,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 42.w,
                    height: 42.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      bot.botIcon,
                      color: Colors.white,
                      size: 24.sp,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    bot.displayName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    bot.persona,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.white.withOpacity(0.85),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// ✅ Your Tasks Section - Only Add & Delete
  Widget _buildYourTasksSection() {
    return Column(
      children: [
        // Header Row
        Obx(() {
          final isSelecting = taskController.isSelectionMode.value;
          final selectedCount = taskController.selectedTaskIds.length;

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title or Selection Count
              isSelecting
                  ? Row(
                children: [
                  GestureDetector(
                    onTap: () => taskController.exitSelectionMode(),
                    child: Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(Icons.close, size: 18.sp, color: Colors.white70),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    "$selectedCount selected",
                    style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              )
                  : Text(
                "Your tasks",
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold, color: Colors.white),
              ),

              // Action Buttons
              Row(
                children: [
                  if (isSelecting) ...[
                    // Select All
                    GestureDetector(
                      onTap: () => taskController.selectAllTasks(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              taskController.isAllSelected ? Icons.deselect : Icons.select_all,
                              size: 14.sp,
                              color: Colors.white70,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              taskController.isAllSelected ? "None" : "All",
                              style: TextStyle(fontSize: 12.sp, color: Colors.white70),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Delete Selected
                    GestureDetector(
                      onTap: selectedCount > 0 ? () => taskController.showDeleteSelectedConfirmation() : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: selectedCount > 0 ? Colors.redAccent.withOpacity(0.2) : Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.delete_outline,
                              size: 14.sp,
                              color: selectedCount > 0 ? Colors.redAccent : Colors.white30,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Delete",
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: selectedCount > 0 ? Colors.redAccent : Colors.white30,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    // Select Button
                    if (taskController.tasks.isNotEmpty)
                      GestureDetector(
                        onTap: () => taskController.enterSelectionMode(),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.checklist_rounded, size: 14.sp, color: Colors.white70),
                              SizedBox(width: 4.w),
                              Text("Select", style: TextStyle(fontSize: 12.sp, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ),
                    SizedBox(width: 8.w),

                    // Add Button
                    GestureDetector(
                      onTap: () => taskController.showAddTaskSheet(),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                        decoration: BoxDecoration(
                          color: Colors.greenAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.add, size: 14.sp, color: Colors.greenAccent),
                            SizedBox(width: 4.w),
                            Text(
                              "Add",
                              style: TextStyle(fontSize: 12.sp, color: Colors.greenAccent, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          );
        }),
        SizedBox(height: 20.h),

        // Task List
        Obx(() {
          if (taskController.isLoading.value) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 30.h),
              child: CircularProgressIndicator(color: Colors.white.withOpacity(0.5), strokeWidth: 2),
            );
          }

          if (taskController.tasks.isEmpty) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 40.h),
              child: Column(
                children: [
                  Icon(Icons.task_alt, size: 48.sp, color: Colors.white.withOpacity(0.3)),
                  SizedBox(height: 12.h),
                  Text("No tasks yet", style: TextStyle(fontSize: 16.sp, color: Colors.white.withOpacity(0.5))),
                  SizedBox(height: 8.h),
                  GestureDetector(
                    onTap: () => taskController.showAddTaskSheet(),
                    child: Text(
                      "Tap + Add to create your first task",
                      style: TextStyle(fontSize: 14.sp, color: Colors.greenAccent.withOpacity(0.7)),
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: taskController.tasks.length,
            separatorBuilder: (context, index) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final task = taskController.tasks[index];
              return _buildTaskItem(task);
            },
          );
        }),
      ],
    );
  }

  Widget _buildTaskItem(TaskModel task) {
    return Obx(() {
      final isSelecting = taskController.isSelectionMode.value;
      final isSelected = taskController.isTaskSelected(task.id);

      return GestureDetector(
        onTap: () {
          if (isSelecting) {
            taskController.toggleTaskSelection(task.id);
          }
        },
        onLongPress: () {
          if (!isSelecting) {
            taskController.toggleTaskSelection(task.id);
          }
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blueAccent.withOpacity(0.15) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected ? Colors.blueAccent.withOpacity(0.5) : Colors.white.withOpacity(0.1),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              // Selection checkbox (only in selection mode)
              if (isSelecting)
                Container(
                  width: 28.w,
                  height: 28.w,
                  margin: EdgeInsets.only(right: 14.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isSelected ? Colors.blueAccent : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.3),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? Icon(Icons.check, size: 16.sp, color: Colors.white)
                      : null,
                ),

              // Task Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 14.sp, color: Colors.white.withOpacity(0.4)),
                        SizedBox(width: 6.w),
                        Text(
                          task.duration,
                          style: TextStyle(fontSize: 13.sp, color: Colors.white.withOpacity(0.5)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}