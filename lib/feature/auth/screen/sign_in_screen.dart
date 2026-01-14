import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../route/route_name.dart';
import '../../widget/onboarding/custom_button.dart';
import '../controller/sign_in_controller.dart';
import '../controller/guest_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController controller = Get.put(SignInController());
  final GuestController guestController = Get.put(GuestController());

  bool _obscurePassword = true;

  @override
  void dispose() {
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
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        // Logo centered
                        Center(
                          child: Image.asset(
                            'assets/images/splash/stumble.png',
                            height: 60.h,
                            width: 60.w,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Sign In Title
                        Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // Email Field
                        _buildTextField(
                          controller: controller.emailController,
                          hintText: 'E-mail',
                          isPassword: false,
                        ),
                        SizedBox(height: 16.h),
                        // Password Field
                        _buildTextField(
                          controller: controller.passwordController,
                          hintText: 'Password',
                          isPassword: true,
                          obscureText: _obscurePassword,
                          onToggleVisibility: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        SizedBox(height: 16.h),
                        // Forgot Password
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Get.toNamed(RouteName.forgetPassword);
                            },
                            child: Text(
                              'Forgot password?',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 16.sp,
                                letterSpacing: 0.9,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Bottom Section
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Column(
                  children: [
                    // Sign In Button
                    CustomButton(
                      text: 'Sign in',
                      onTap: () {
                        controller.loginUser();
                      },
                    ),
                    SizedBox(height: 24.h),
                    // Or Divider
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          child: Text(
                            'or',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 2,
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 24.h),



                    // Sign Up Text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't you have an account? ",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 15.sp,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.toNamed(RouteName.signUp);
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool isPassword,
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
  }) {
    return Container(
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(32.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword ? obscureText : false,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.4),
            fontSize: 16.sp,
          ),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          suffixIcon: isPassword
              ? IconButton(
            onPressed: onToggleVisibility,
            icon: Icon(
              obscureText ? Icons.visibility_off : Icons.visibility,
              color: Colors.white.withOpacity(0.4),
              size: 22.sp,
            ),
          )
              : null,
        ),
      ),
    );
  }
}