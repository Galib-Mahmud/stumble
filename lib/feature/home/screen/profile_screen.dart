import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widget/onboarding/custom_button.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _aboutController = TextEditingController();

  String? _gender = 'Select';
  String? _ageRange = 'Select';

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/Sign In.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Back Button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        width: 32.w,
                        height: 32.h,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 18.sp,
                        ),
                      ),
                    ),
                    // Title
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    // Settings Icon
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/settings');
                      },
                      child: Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h),
                        // Profile Avatar with Edit Icon
                        Center(
                          child: Stack(
                            children: [
                              Container(
                                width: 90.w,
                                height: 90.h,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFF09AFB9),
                                    width: 3,
                                  ),
                                ),
                                child: ClipOval(
                                  child: Image.asset(
                                    'assets/images/avatar/avatar4.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 28.w,
                                  height: 28.h,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF2A2A3E),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.2),
                                      width: 1,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.white,
                                    size: 14.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        // User Name
                        Center(
                          child: Text(
                            'Itunuoluwa Abidoye',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 4.h),
                        // User Type
                        Center(
                          child: Text(
                            'Advanced User',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.5),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // User Name Field
                        _buildLabel('User Name'),
                        _buildTextField(
                          controller: _usernameController,
                          hintText: 'Your User Name',
                        ),
                        SizedBox(height: 16.h),

                        // Email Field
                        _buildLabel('Email address'),
                        _buildTextField(
                          controller: _emailController,
                          hintText: 'Your email address',
                        ),
                        SizedBox(height: 16.h),

                        // Phone Field
                        _buildLabel('Phone'),
                        _buildPhoneField(),
                        SizedBox(height: 16.h),

                        // About me Field
                        _buildLabel('About me'),
                        _buildTextField(
                          controller: _aboutController,
                          hintText: 'Type here',
                        ),
                        SizedBox(height: 16.h),

                        // Gender Dropdown
                        _buildLabel('Gender'),
                        _buildDropdown(
                          value: _gender,
                          items: ['Select', 'Male', 'Female', 'Other'],
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.h),

                        // Age Range Dropdown
                        _buildLabel('Age Range'),
                        _buildDropdown(
                          value: _ageRange,
                          items: ['Select', '18-25', '26-35', '36-45', '46-60', '60+'],
                          onChanged: (value) {
                            setState(() {
                              _ageRange = value;
                            });
                          },
                        ),
                        SizedBox(height: 30.h),

                        // Edit Button
                        CustomButton(
                          text: 'Edit',
                          onTap: () {
                            Get.toNamed('/edit_profile');
                          },
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
  }) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.circular(25.r),

      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
          color: Colors.white,
          fontSize: 14.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 14.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.circular(25.r),

      ),
      child: Row(
        children: [
          SizedBox(width: 12.w),
          // Flag
          Image.asset(
            'assets/images/avatar/flag.png', // Bangladesh flag
            width: 24.w,
            height: 16.h,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
              ),
              decoration: InputDecoration(
                hintText: '+880',
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 14.sp,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
  }) {
    return Container(
      height: 48.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Color(0xFF222222),
        borderRadius: BorderRadius.circular(25.r),

      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: const Color(0xFF1A1A2E),
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: Colors.white.withOpacity(0.5),
          ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 14.sp,
          ),
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: TextStyle(
                  color: item == 'Select'
                      ? Colors.white.withOpacity(0.4)
                      : Colors.white,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}