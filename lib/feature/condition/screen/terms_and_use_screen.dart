import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../widget/condition/custom_appbar2.dart';

class TermsAndUseScreen extends StatelessWidget {
  const TermsAndUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar2(
        title: 'Terms of Use',
        onBack: () => Get.back(),
        actionIcon: 'assets/images/splash/three dot .png',
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
              const Section(
                number: "1",
                title: "Who We Are",
                content:
                "Stumble is a safe space for people navigating breakups. "
                    "We are not a dating app and not a therapy service.",
              ),
              const Section(
                number: "2",
                title: "Eligibility",
                content:
                "• You must be 18+ to use Stumble.\n"
                    "• You may not create multiple accounts to mislead or impersonate.",
              ),
              const Section(
                number: "3",
                title: "Your Use of Stumble",
                content:
                "• You are responsible for what you share.\n"
                    "• Respect our Community Guidelines (no harassment, hate, or unsafe behavior).\n"
                    "• Do not misuse Stumble (spam, abuse, illegal activity).",
              ),
              const Section(
                number: "4",
                title: "Content & Licensing",
                content:
                "• You own the content you create.\n"
                    "• By posting, you grant Stumble a limited license to display it inside the platform.\n"
                    "• We don't sell your personal content.",
              ),
              const Section(
                number: "5",
                title: "Safety & Support",
                content:
                "• Messaging requires mutual consent.\n"
                    "• Our Support Button is not a crisis hotline. For emergencies, call 911 (U.S.) or your local emergency number.",
              ),
              const Section(
                number: "6",
                title: "Termination",
                content:
                "We may suspend or terminate accounts that violate these terms.",
              ),
              const Section(
                number: "7",
                title: "Changes",
                content:
                "We may update these Terms. We'll notify you before changes take effect.",
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