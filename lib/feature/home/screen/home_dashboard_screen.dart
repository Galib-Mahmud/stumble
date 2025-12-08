import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeDashboardScreen extends StatefulWidget {
  const HomeDashboardScreen({super.key});

  @override
  State<HomeDashboardScreen> createState() => _HomeDashboardScreenState();
}

class _HomeDashboardScreenState extends State<HomeDashboardScreen> {
  // Task completion status
  List<bool> taskCompleted = [true, false];

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

                // Top App Bar
                _buildTopBar(),

                SizedBox(height: 24.h),

                // Welcome Text
                _buildWelcomeText(),

                SizedBox(height: 24.h),

                // XP Gauge Card (Your Image)
                _buildXPGaugeCard(),

                SizedBox(height: 24.h),

                // Stumble Events Section
                _buildStumbleEventsSection(),

                SizedBox(height: 24.h),

                // Your Tasks Section
                _buildYourTasksSection(),

                SizedBox(height: 100.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Top Bar with logo and profile icons
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Logo
        Image.asset(
          'assets/images/avatar/Frame2.png',
         fit: BoxFit.cover,
        ),
        // Right side icons
        Row(
          children: [
            _buildTopIcon('assets/images/avatar/notification.png'),
            SizedBox(width: 12.w),
            _buildTopIcon('assets/images/avatar/settings.png'),

            SizedBox(width: 12.w),
            // Profile avatar
            Container(
              width: 36.w,
              height: 36.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,

              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/avatar/profile.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTopIcon(String iconPath) {
    return Container(
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
    );
  }

  // Welcome Text
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

  // XP Gauge Card - Using your image
  Widget _buildXPGaugeCard() {
    return GestureDetector(
      onTap: () {
        // Navigate to XP details
      },
      child: Image.asset(
        'assets/images/avatar/xpDetails.png',
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
  }

  // Stumble Events Section
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

  // Event Card - Using your images
  Widget _buildEventCard({required String imagePath}) {
    return GestureDetector(
      onTap: () {
        // Navigate to event details
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Image.asset(
          imagePath,

          fit: BoxFit.cover,
        ),
      ),
    );
  }

// Your Tasks Section
  Widget _buildYourTasksSection() {
    return Column(
      children: [
        // Header
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

        // Task items
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

          // Checkbox
          Container(
            width: 35.w,
            height: 35.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isCompleted ? Color(0xFF1E3D38) : Colors.transparent,
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
              fontWeight: FontWeight.bold,
              color: Colors.greenAccent,

            )
                : null,
          ),
          SizedBox(width: 16.w),
          // Task details
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