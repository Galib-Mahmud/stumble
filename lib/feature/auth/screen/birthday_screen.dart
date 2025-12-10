import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../../widget/onboarding/custom_button.dart';

class BirthdayScreen extends StatefulWidget {
  const BirthdayScreen({super.key});

  @override
  State<BirthdayScreen> createState() => _BirthdayScreenState();
}

class _BirthdayScreenState extends State<BirthdayScreen> {
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();

  final FocusNode _monthFocus = FocusNode();
  final FocusNode _dayFocus = FocusNode();
  final FocusNode _yearFocus = FocusNode();

  final int currentStep = 2;
  final int totalSteps = 8;

  @override
  void dispose() {
    _monthController.dispose();
    _dayController.dispose();
    _yearController.dispose();
    _monthFocus.dispose();
    _dayFocus.dispose();
    _yearFocus.dispose();
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
              // Top Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  children: [
                    // Row with Back Button and Logo
                    Row(
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
                        // Logo
                        Image.asset(
                          'assets/images/splash/stumble.png',
                           fit: BoxFit.cover,
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    // Progress Bar Row
                    Row(
                      children: [
                        // Progress Bar
                        Expanded(
                          child: Container(
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Row(
                              children: [
                                Flexible(
                                  flex: currentStep,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF09AFB9),
                                          Color(0xFFFFAD72),
                                          Color(0xFFF96D01),


                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(3.r),
                                    ),
                                  ),
                                ),
                                Flexible(
                                  flex: totalSteps - currentStep,
                                  child: const SizedBox(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        // Step Text
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: '$currentStep',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.5),
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              TextSpan(
                                text: ' / $totalSteps',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      SizedBox(height: 30.h),
                      // Title
                      Text(
                        "When's your birthday",
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),

                      const Spacer(),

                      // Date Input Row - MM DD YY
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Month Field
                          _buildDateTextField(
                            controller: _monthController,
                            focusNode: _monthFocus,
                            hint: 'MM',
                            maxLength: 2,
                            onChanged: (value) {
                              if (value.length == 2) {
                                _dayFocus.requestFocus();
                              }
                            },
                          ),
                          SizedBox(width: 12.w),
                          // Day Field
                          _buildDateTextField(
                            controller: _dayController,
                            focusNode: _dayFocus,
                            hint: 'DD',
                            maxLength: 2,
                            onChanged: (value) {
                              if (value.length == 2) {
                                _yearFocus.requestFocus();
                              }
                            },
                          ),
                          SizedBox(width: 12.w),
                          // Year Field
                          _buildDateTextField(
                            controller: _yearController,
                            focusNode: _yearFocus,
                            hint: 'YYYY',
                            maxLength: 4,
                            width: 90.w,
                            onChanged: (value) {
                              if (value.length == 4) {
                                _yearFocus.unfocus();
                              }
                            },
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Bottom Text
                      Text(
                        "We'll use this to match you around with\nothers of the same age",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.6),
                          height: 1.5,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      // Next Button
                      CustomButton(
                        text: "Next",
                        onTap: () {
                     Get.toNamed(RouteName.gender);
                        },
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String hint,
    required int maxLength,
    required Function(String) onChanged,
    double? width,
  }) {
    return Container(
      width: width ?? 75.w,
      height: 46.h,
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(23.r),
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: maxLength,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.sp,
          fontWeight: FontWeight.w500,
        ),
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.white.withOpacity(0.5),
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
        onChanged: onChanged,
      ),
    );
  }
}