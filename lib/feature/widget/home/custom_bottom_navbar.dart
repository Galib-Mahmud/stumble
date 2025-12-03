import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  const CustomBottomNavBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.h, left: 10.w, right: 10.w), // Scaled margin
      child: Container(
        height: 70.h, // Scaled height
        decoration: BoxDecoration(
          color: const Color.fromRGBO(154, 154, 154, 1),
          borderRadius: BorderRadius.circular(35.r), // Scaled border radius
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Image.asset('assets/images/home/homeicon.png'),
              isSelected: selectedIndex == 0,
              onTap: () => onItemSelected(0),
              label: 'Home',
            ),
            _NavItem(
              icon: Image.asset('assets/images/home/icon2.png'),
              isSelected: selectedIndex == 1,
              onTap: () => onItemSelected(1),
              label: 'Resources',
            ),
            _NavItem(
              icon: Image.asset('assets/images/home/shopicon.png'),
              isSelected: selectedIndex == 2,
              onTap: () => onItemSelected(2),
              label: 'Shop',
            ),
            _NavItem(
              icon: Image.asset('assets/images/home/people.png'),
              isSelected: selectedIndex == 3,
              onTap: () => onItemSelected(3),
              label: 'Community',
            ),
            _NavItem(
              icon: Image.asset('assets/images/home/profile.png'),
              isSelected: selectedIndex == 4,
              onTap: () => onItemSelected(4),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;
  final String? label;

  const _NavItem({
    Key? key,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h), // Scaled padding
        decoration: BoxDecoration(
          color: isSelected ? const Color.fromRGBO(47, 46, 46, 1) : Colors.transparent,
          borderRadius: BorderRadius.circular(25.r), // Scaled border radius
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Check if the icon is a normal icon or an image and adjust size accordingly
            icon is IconData
                ? Icon(
              icon as IconData,
              color: isSelected ? Colors.white : Colors.black,
              size: 26.sp, // Scaled icon size
            )
                : ColorFiltered(
              colorFilter: ColorFilter.mode(
                isSelected ? Colors.white : Colors.black,
                BlendMode.srcIn,
              ),
              child: SizedBox(
                width: 24.w, // Scaled width
                height: 24.h, // Scaled height
                child: icon,
              ),
            ),
            if (isSelected && label != null) ...[
              SizedBox(width: 10.w), // Scaled width
              Text(
                label!,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 14.sp, // Scaled text size
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}