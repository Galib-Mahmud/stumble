import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

// Import the controller
import 'app_drawer_controller.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  List<bool> taskCompleted = [true, false];

  // ❌ REMOVED: _scaffoldKey - not needed anymore
  // ❌ REMOVED: drawer - it's now in MainScreen

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ❌ REMOVED: key, drawer, drawerEnableOpenDragGesture
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
                _buildStumbleEventsSection(),
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

  // ❌ REMOVED: _buildDrawer() method - not needed anymore

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
            _buildTopIcon(
              'assets/images/avatar/notification.png',
              onTap: () {
                // Handle notification tap
              },
            ),
            SizedBox(width: 12.w),
            _buildTopIcon(
              'assets/images/avatar/settings.png',
              onTap: () {
                // ✅ CHANGED: Now calls MainScreen's drawer
                Get.find<AppDrawerController>().open();
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
      onTap: () {},
      child: Image.asset(
        'assets/images/avatar/xpDetails.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  Widget _buildStumbleEventsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Stumble events",
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: _buildEventCard(
                imagePath: 'assets/images/avatar/event1.png',
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: _buildEventCard(
                imagePath: 'assets/images/avatar/event2.png',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEventCard({required String imagePath}) {
    return GestureDetector(
      onTap: () {},
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildYourTasksSection() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Your tasks",
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.edit_outlined,
                  size: 16.sp,
                  color: Colors.white.withOpacity(0.7),
                ),
                SizedBox(width: 4.w),
                Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 20.h),
        _buildTaskItem(
          title: "Participate in my Tribe",
          subtitle: "15-30 min",
          isCompleted: taskCompleted[0],
          index: 0,
        ),
        SizedBox(height: 16.h),
        _buildTaskItem(
          title: "Breathwork",
          subtitle: "45 min",
          isCompleted: taskCompleted[1],
          index: 1,
        ),
      ],
    );
  }

  Widget _buildTaskItem({
    required String title,
    required String subtitle,
    required bool isCompleted,
    required int index,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          taskCompleted[index] = !taskCompleted[index];
        });
      },
      child: Row(
        children: [
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? const Color(0xFF1E3D38) : Colors.transparent,
              border: Border.all(
                color: isCompleted
                    ? Colors.transparent
                    : Colors.white.withOpacity(0.3),
                width: 1.5,
              ),
            ),
            child: isCompleted
                ? Icon(
              Icons.check,
              size: 18.sp,
              color: Colors.greenAccent,
            )
                : null,
          ),
          SizedBox(width: 16.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4.h),
              Row(
                children: [
                  Image.asset(
                    'assets/images/avatar/time.png',
                    width: 14.w,
                    height: 14.w,
                    color: Colors.white.withOpacity(0.5),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}