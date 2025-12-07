import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/condition/custom_appbar2.dart';


class DataRetentionDeletionPolicyScreen extends StatelessWidget {
  const DataRetentionDeletionPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar2(
        title: "Data Retention &\nDeletion Policy",
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
              const Section(
                number: "1",
                title: "Retention",
                content:
                "• Account data kept while you are active.\n"
                    "• Inactive accounts may be archived after 12 months.\n"
                    "• Aggregated, anonymized insights may be retained for research/analytics.",
              ),
              const Section(
                number: "2",
                title: "Deletion",
                content:
                "• You may request deletion at any time (in-app or via support).\n"
                    "• Deletion = removal of journal entries, posts, DMs, and account info within 30 days.\n"
                    "• Backups may persist for up to 90 days before permanent erasure.",
              ),
              const Section(
                number: "3",
                title: "Export",
                content:
                "• Users may download a copy of their personal data before deletion.",
              ),
              SizedBox(height: 24.h),
              const Section(
                number: "4",
                title: "Important Disclaimer",
                content:
                "Stumble is not a substitute for therapy or medical advice.\n\n"
                    "If you are in crisis, use the Support Button for resources — or call:\n\n"
                    "• U.S. & Canada: 988 Suicide & Crisis Lifeline\n"
                    "• UK & Ireland: Samaritans at 116 123\n"
                    "• Elsewhere: See findahelpline.com for local hotlines\n\n"
                    "Stumble is a peer-support and wellness tool only.",
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