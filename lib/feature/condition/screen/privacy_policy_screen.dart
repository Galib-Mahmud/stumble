import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../widget/condition/custom_appbar2.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar2(
        title: "Privacy Policy",
        onBack: () {
          Navigator.pop(context);
        },
        actionIcon: "assets/images/splash/three dot .png",
        onAction: () {},
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/splash/Terms of Use (1).png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "We respect your privacy.",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24.h),
              const Section(
                number: "1",
                title: "What We Collect",
                content:
                "• Basic account info (email, age range, avatar).\n"
                    "• Optional mood logs, journal entries, content preferences.\n"
                    "• Device + usage data (for performance & safety).",
              ),
              const Section(
                number: "2",
                title: "How We Use It",
                content:
                "• To personalize your experience (e.g., mood-based content).\n"
                    "• To keep the community safe (moderation + fraud prevention).\n"
                    "• To improve Stumble (analytics, bug fixes).",
              ),
              const Section(
                number: "3",
                title: "What We Don't Do",
                content:
                "• We do not sell personal data.\n"
                    "• We do not share identifiable info without consent.",
              ),
              const Section(
                number: "4",
                title: "Sharing",
                content:
                "• Anonymized insights may be shared with partners (opt-in only).\n"
                    "• Third-party vendors (hosting, analytics) must follow strict data security rules.",
              ),
              const Section(
                number: "5",
                title: "Your Rights",
                content:
                "• Download your data.\n"
                    "• Delete your data anytime.\n"
                    "• Control notifications + preferences.",
              ),
              SizedBox(height: 40.h),
            ],
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String number;
  final String title;
  final String content;

  const Section({
    super.key,
    required this.number,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$number. ',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.only(left: 20.w),
            child: Text(
              content,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}