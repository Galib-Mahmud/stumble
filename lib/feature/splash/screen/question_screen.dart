import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';
import '../../widget/onboarding/custom_button.dart';

class QuestionScreen extends StatefulWidget {
  const QuestionScreen({Key? key}) : super(key: key);

  @override
  State<QuestionScreen> createState() => _QuestionScreenState();
}

class _QuestionScreenState extends State<QuestionScreen> {
  int? selectedOption;

  final List<String> options = [
    "I feel heavy. I'm trying to keep it together",
    "I'm a bit all over the place, but I'm okay",
    "I'm feeling more like myself lately",
    "I'm calm and just reflecting",
  ];

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24.h),

                  // Logo
                  Center(
                    child: Image.asset(
                      'assets/images/splash/stumble.png',
                      width: 48.w,
                      height: 48.w,
                      fit: BoxFit.contain,



                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Progress bar
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: LinearProgressIndicator(
                            value: 1 / 15, // Current question / total questions
                            backgroundColor: Colors.white.withOpacity(0.3),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                            minHeight: 8.h,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        '1/15',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  // Category
                  Text(
                    'GROUNDING & AWARENESS',
                    style: TextStyle(
                      color: const Color(0xFF00D9C0),
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w500,

                    ),
                  ),

                  SizedBox(height: 12.h),

                  // Question
                  Text(
                    'How would you describe how you\'re feeling today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),

                  SizedBox(height: 32.h),

                  // Options
                  Expanded(
                    child: ListView.builder(
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final isSelected = selectedOption == index;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedOption = index;
                            });
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
                                ),

                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Text(
                                    options[index],
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
                      },
                    ),
                  ),

                  SizedBox(height: 20.h),

                  // Button - Shows only when option is selected
                  if (selectedOption != null)
                    CustomButton(
                      text: 'Next',
                      onTap: () {
                        // Navigate to next question

                      },
                    )
                  else
                    Container(
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
                    ),

                  SizedBox(height: 32.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}