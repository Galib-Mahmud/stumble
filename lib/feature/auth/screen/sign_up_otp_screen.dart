import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../widget/onboarding/custom_button.dart';

class SignUpOtpScreen extends StatefulWidget {
  const SignUpOtpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpOtpScreen> createState() => _SignUpOtpScreenState();
}

class _SignUpOtpScreenState extends State<SignUpOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    4,
        (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    4,
        (index) => FocusNode(),
  );

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
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
                        // Enter OTP Title
                        Text(
                          'Enter OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 30.h),
                        // OTP Input Fields
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(
                            4,
                                (index) => _buildOtpField(index),
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
                    // Verification Text
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12.sp,
                        ),
                        children: [
                          const TextSpan(
                            text: 'We sent a verification code to your email. Please check.\nIf not, resend in 0:20 minutes. ',
                          ),
                          TextSpan(
                            text: 'Resend',
                            style: TextStyle(
                              color: const Color(0xFFF96D01),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24.h),
                    // Submit Button
                    CustomButton(
                      text: 'Submit',
                      onTap: () {
                        // Handle OTP verification
                        Get.toNamed('/home');
                      },
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

  Widget _buildOtpField(int index) {
    return Container(
      width: 70.w,
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: TextStyle(
          color: Colors.white,
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: '-',
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.3),
            fontSize: 20.sp,
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }
}