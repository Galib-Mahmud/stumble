import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../auth/controller/question_controller.dart';
import '../../widget/onboarding/custom_button.dart';

class QuestionScreen extends StatelessWidget {
  QuestionScreen({Key? key}) : super(key: key);

  final GetQuestionController controller = Get.put(GetQuestionController());

  @override
  Widget build(BuildContext context) {
    // Fetch questions once
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.questions.isEmpty) {
        controller.getQuestion();
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/question.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.6),
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Obx(() {
                // Loading
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF00D9C0),
                    ),
                  );
                }

                // Empty
                if (controller.questions.isEmpty) {
                  return const Center(
                    child: Text(
                      'No questions available',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }

                final options = controller.currentOptions;

                return Column(
                  children: [
                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 24.h),

                            // Logo
                            Center(
                              child: Image.asset(
                                'assets/images/splash/stumble.png',
                                fit: BoxFit.contain,
                              ),
                            ),

                            SizedBox(height: 20.h),

                            // Progress Bar Row
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    height: 8.h,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(32.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Flexible(
                                          flex: controller.currentStep,
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
                                        if (controller.totalSteps > controller.currentStep)
                                          Flexible(
                                            flex: controller.totalSteps - controller.currentStep,
                                            child: const SizedBox(),
                                          ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12.w),
                                RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '${controller.currentStep}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13.sp,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' / ${controller.totalSteps}',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.5),
                                          fontSize: 13.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 32.h),

                            // Category
                            Text(
                              controller.categoryText.toUpperCase(),
                              style: TextStyle(
                                color: const Color(0xFF00D9C0),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),

                            SizedBox(height: 12.h),

                            // Question
                            Text(
                              controller.questionText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                height: 1.3,
                              ),
                            ),

                            SizedBox(height: 32.h),

                            // Options
                            ...List.generate(options.length, (index) {
                              final option = options[index];
                              final optionId = option['id'] as int;
                              final optionText = option['option_text'] ?? '';

                              return Obx(() {
                                final isSelected = controller.isSelected(optionId);

                                return GestureDetector(
                                  onTap: () {
                                    controller.selectOption(optionId);
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(bottom: 12.h),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 20.w,
                                      vertical: 18.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF00D9C0).withOpacity(0.2)
                                          : const Color(0xFF3A3A3A).withOpacity(0.8),
                                      borderRadius: BorderRadius.circular(25.r),
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 24.w,
                                          height: 24.w,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: isSelected
                                                  ? const Color(0xFF00D9C0)
                                                  : Colors.white.withOpacity(0.5),
                                              width: 2,
                                            ),
                                            color: isSelected
                                                ? const Color(0xFF00D9C0)
                                                : Colors.transparent,
                                          ),
                                          child: isSelected
                                              ? Icon(
                                            Icons.check,
                                            size: 14.w,
                                            color: Colors.white,
                                          )
                                              : null,
                                        ),
                                        SizedBox(width: 16.w),
                                        Expanded(
                                          child: Text(
                                            optionText,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15.sp,
                                              fontWeight: FontWeight.w500,
                                              height: 1.4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              });
                            }),

                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                    ),

                    // Fixed Button at Bottom
                    Padding(
                      padding: EdgeInsets.only(bottom: 80.h, top: 10.h),
                      child: Obx(() {
                        // 👇 Submitting হলে loading দেখাও
                        if (controller.isSubmitting.value) {
                          return Container(
                            height: 46.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF09AFB9), Color(0xFFF96D01)],
                              ),
                              borderRadius: BorderRadius.circular(23.r),
                            ),
                            child: const Center(
                              child: SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }

                        // 👇 Selection থাকলে active button
                        if (controller.hasSelection) {
                          return CustomButton(
                            text: controller.currentStep == controller.totalSteps
                                ? 'Finish'
                                : 'Next',
                            onTap: () => controller.nextQuestion(),
                          );
                        }

                        // 👇 Selection না থাকলে disabled button
                        return Container(
                          height: 46.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFF4A4A4A),
                            borderRadius: BorderRadius.circular(23.r),
                          ),
                          child: Center(
                            child: Text(
                              'Next',
                              style: TextStyle(
                                color: const Color(0xFF8A8A8A),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}