import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:stumble/feature/widget/condition/custom_appbar2.dart';

class StumbleSkyScreen extends StatelessWidget {
  const StumbleSkyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: CustomAppBar2(title: "Stumble Sky",onBack: () => Get.back()),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/avatar/Sky.png',
          fit: BoxFit.cover,



        ),
      ),
    );
  }
}