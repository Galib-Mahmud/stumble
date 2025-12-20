import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/feature/home/screen/app_drawer_controller.dart';
import 'package:stumble/feature/home/screen/custom_drawer_screen.dart';
import 'package:stumble/feature/home/screen/home_dashboard_screen.dart';
import 'package:stumble/feature/home/screen/orbit_screen.dart';
import 'package:stumble/feature/home/screen/sos_screen.dart';
import 'package:stumble/feature/home/screen/your_jurnal_screen.dart';
import 'package:stumble/feature/home/websocket/chat_service.dart';
import 'package:stumble/route/route_name.dart';

// ADD THIS IMPORT - ChatService for dynamic tribe navigation


class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  static double get navBarHeight => 120.h;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 3;

  late AnimationController _drawerController;
  late Animation<double> _drawerAnimation;
  bool _isDrawerOpen = false;

  final AppDrawerController _appDrawerCtrl = Get.put(AppDrawerController());

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;

    _drawerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _drawerAnimation = Tween<double>(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: _drawerController, curve: Curves.easeOutCubic),
    );

    _appDrawerCtrl.setDrawerFunctions(
      open: _openDrawer,
      close: _closeDrawer,
    );
  }

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  void _openDrawer() {
    _drawerController.forward();
    setState(() {
      _isDrawerOpen = true;
    });
  }

  void _closeDrawer() {
    _drawerController.reverse().then((_) {
      setState(() {
        _isDrawerOpen = false;
      });
    });
  }

  final List<Widget> _pages = [
    OrbitQuotesScreen(),
    SupportScreen(),
    YourJurnalScreen(),
    HomeDashboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 8 && !_isDrawerOpen) {
          _openDrawer();
        }
        if (details.delta.dx < -8 && _isDrawerOpen) {
          _closeDrawer();
        }
      },
      child: Scaffold(
        extendBody: true,
        body: Stack(
          children: [
            _pages[_currentIndex],
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNavigationBar(),
            ),
            if (_isDrawerOpen)
              AnimatedBuilder(
                animation: _drawerController,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: _closeDrawer,
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx < -8) {
                        _closeDrawer();
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      color: Colors.black.withOpacity(
                        0.5 * _drawerController.value,
                      ),
                    ),
                  );
                },
              ),
            AnimatedBuilder(
              animation: _drawerAnimation,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(
                    _drawerAnimation.value * 280.w,
                    0,
                  ),
                  child: child,
                );
              },
              child: CustomDrawer(
                onClose: _closeDrawer,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 78.h,
            decoration: BoxDecoration(
              color: const Color(0xFF0D0620),
              borderRadius: BorderRadius.circular(40.r),
              border: Border.all(
                color: const Color(0xFF1E1535),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: const Color(0xFF4EFFEE).withOpacity(0.2),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(width: 10.w),
                _buildNavItem(
                  iconPath: 'assets/images/avatar/Orbit.png',
                  label: 'Orbit',
                  index: 0,
                ),
                SizedBox(width: 20.w),
                _buildNavItem(
                  iconPath: 'assets/images/avatar/layer_1.png',
                  label: 'SOS',
                  index: 1,
                ),
                SizedBox(width: 65.w),
                _buildNavItem(
                  iconPath: 'assets/images/avatar/Journal.png',
                  label: 'Journal',
                  index: 2,
                ),
                SizedBox(width: 5.w),
                _buildNavItem(
                  iconPath: 'assets/images/avatar/dash.png',
                  label: 'Dashboard',
                  index: 3,
                ),
              ],
            ),
          ),

          // ═══════════════════════════════════════════
          // CHAT BUTTON - Uses ChatService for dynamic tribe
          // ═══════════════════════════════════════════
          Positioned(
            top: -25.h,
            child: GestureDetector(
              onTap: () {
                // This fetches user's tribe from API and navigates
                ChatService.goToTribeChat();
              },
              child: Container(
                height: 55.w,
                width: 55.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.2),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/avatar/chat.png',
                    width: 28.w,
                    height: 28.w,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required String iconPath,
    required String label,
    required int index,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
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
              height: 24.h,
              width: 24.w,


              color: isSelected
                  ? const Color(0xFF4EFFEE)
                  : Colors.white.withOpacity(0.4),
            ),
            SizedBox(height: 7.h),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFF4EFFEE)
                    : Colors.white.withOpacity(0.4),
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}