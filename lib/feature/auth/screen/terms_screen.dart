import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:stumble/route/route_name.dart';

import '../../widget/onboarding/custom_button.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  final int currentStep = 7;
  final int totalSteps = 8;

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
                            height: 7.h,
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
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20.h),
                        // Title
                        Center(
                          child: Text(
                            "Terms & Policies",
                            style: TextStyle(
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 30.h),

                        // ==================== TERMS OF USE ====================
                        _buildMainHeader("Terms of Use"),
                        SizedBox(height: 16.h),

                        // Eligibility Section
                        _buildSectionHeader(
                          icon: Icons.check_circle_outline,
                          title: 'Eligibility',
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "By using this app you agree not to upload post or share content -",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.8),
                            height: 1.5,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildBulletPoint(
                          "Is obscene, abusive or otherwise objectionable",
                        ),
                        SizedBox(height: 10.h),
                        _buildBulletPoint(
                          "Is obscene, abusive or otherwise objectionable",
                        ),
                        SizedBox(height: 10.h),
                        _buildBulletPoint(
                          "Is obscene, abusive or otherwise objectionable",
                        ),

                        SizedBox(height: 30.h),

                        // Violators Section
                        _buildSectionHeader(
                          icon: Icons.block,
                          title: 'Violators',
                          iconColor: const Color(0xFFE57373),
                        ),
                        SizedBox(height: 12.h),
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.8),
                              height: 1.5,
                            ),
                            children: [
                              const TextSpan(
                                text:
                                "By using this app you agree not to upload post or share content ",
                              ),
                              TextSpan(
                                text: "read more",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),

                        _buildDivider(),

                        // ==================== PRIVACY POLICY ====================
                        _buildMainHeader("Privacy Policy"),
                        SizedBox(height: 16.h),
                        Text(
                          "We respect your privacy.",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        _buildSection(
                          number: "1",
                          title: "What We Collect",
                          content:
                          "• Basic account info (email, age range, avatar).\n"
                              "• Optional mood logs, journal entries, content preferences.\n"
                              "• Device + usage data (for performance & safety).",
                        ),
                        _buildSection(
                          number: "2",
                          title: "How We Use It",
                          content:
                          "• To personalize your experience (e.g., mood-based content).\n"
                              "• To keep the community safe (moderation + fraud prevention).\n"
                              "• To improve Stumble (analytics, bug fixes).",
                        ),
                        _buildSection(
                          number: "3",
                          title: "What We Don't Do",
                          content: "• We do not sell personal data.\n"
                              "• We do not share identifiable info without consent.",
                        ),
                        _buildSection(
                          number: "4",
                          title: "Sharing",
                          content:
                          "• Anonymized insights may be shared with partners (opt-in only).\n"
                              "• Third-party vendors (hosting, analytics) must follow strict data security rules.",
                        ),
                        _buildSection(
                          number: "5",
                          title: "Your Rights",
                          content: "• Download your data.\n"
                              "• Delete your data anytime.\n"
                              "• Control notifications + preferences.",
                        ),

                        _buildDivider(),

                        // ==================== DATA RETENTION & DELETION ====================
                        _buildMainHeader("Data Retention & Deletion Policy"),
                        SizedBox(height: 16.h),
                        _buildSection(
                          number: "1",
                          title: "Retention",
                          content: "• Account data kept while you are active.\n"
                              "• Inactive accounts may be archived after 12 months.\n"
                              "• Aggregated, anonymized insights may be retained for research/analytics.",
                        ),
                        _buildSection(
                          number: "2",
                          title: "Deletion",
                          content:
                          "• You may request deletion at any time (in-app or via support).\n"
                              "• Deletion = removal of journal entries, posts, DMs, and account info within 30 days.\n"
                              "• Backups may persist for up to 90 days before permanent erasure.",
                        ),
                        _buildSection(
                          number: "3",
                          title: "Export",
                          content:
                          "• Users may download a copy of their personal data before deletion.",
                        ),

                        _buildDivider(),

                        // ==================== DISCLAIMERS ====================
                        _buildMainHeader("Disclaimers"),
                        SizedBox(height: 16.h),
                        _buildSection(
                          number: "1",
                          title: "Not a Substitute",
                          content:
                          "Stumble is not a substitute for therapy or medical advice.",
                        ),
                        _buildSection(
                          number: "2",
                          title: "Crisis Resources",
                          content:
                          "If you are in crisis, use the Support Button for resources — or call:\n\n"
                              "• U.S. & Canada: 988 Suicide & Crisis Lifeline\n"
                              "• UK & Ireland: Samaritans at 116 123\n"
                              "• Elsewhere: See findahelpline.com for local hotlines",
                        ),
                        _buildSection(
                          number: "3",
                          title: "Peer Support Only",
                          content:
                          "Stumble is a peer-support and wellness tool only.",
                        ),

                        SizedBox(height: 30.h),

                        // Keep our community safe
                        Center(
                          child: Text(
                            "Keep our community safe",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ),
                        SizedBox(height: 20.h),
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
                    // I agree Button
                    CustomButton(
                      text: "I agree",
                      onTap: () {
                        Get.toNamed(RouteName.constellationTora);
                      },
                    ),
                    SizedBox(height: 16.h),
                    // Privacy Policy & Terms
                    GestureDetector(
                      onTap: () {
                        // Navigate to privacy policy
                      },
                      child: Text(
                        "Privacy Policy & Terms & Services",
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.6),
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white.withOpacity(0.6),
                        ),
                      ),
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

  Widget _buildMainHeader(String title) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF09AFB9),
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    Color? iconColor,
  }) {
    return Row(
      children: [
        Icon(icon, color: iconColor ?? const Color(0xFF09AFB9), size: 22.sp),
        SizedBox(width: 10.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildBulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: 6.h),
          child: Container(
            width: 6.w,
            height: 6.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.7),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({
    required String number,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. ',
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 18.w),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.white.withOpacity(0.8),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 24.h),
      child: Container(
        height: 1,
        color: Colors.white.withOpacity(0.2),
      ),
    );
  }
}