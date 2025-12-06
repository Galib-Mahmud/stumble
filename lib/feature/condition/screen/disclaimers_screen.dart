import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/condition/custom_appbar2.dart';


class DisclaimersScreen extends StatelessWidget {
  const DisclaimersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar2(
        title: "Disclaimers",
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
                title: "Not a Substitute",
                content:
                "Stumble is not a substitute for therapy or medical advice.",
              ),
              const Section(
                number: "2",
                title: "Crisis Resources",
                content:
                "If you are in crisis, use the Support Button for resources — or call:\n\n"
                    "• U.S. & Canada: 988 Suicide & Crisis Lifeline\n"
                    "• UK & Ireland: Samaritans at 116 123\n"
                    "• Elsewhere: See findahelpline.com for local hotlines",
              ),
              const Section(
                number: "3",
                title: "Peer Support Only",
                content:
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