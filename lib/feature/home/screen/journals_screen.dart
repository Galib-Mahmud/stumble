import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../core/local_storage/user_info.dart';
import '../../widget/onboarding/custom_button.dart';
import '../controller/journal_controller.dart';


class CreateJournalScreen extends StatelessWidget {
  const CreateJournalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(JournalController());

    final List<String> moodImages = [
      "assets/images/avatar/mood1.png",
      "assets/images/avatar/mood2.png",
      "assets/images/avatar/mood3.png",
      "assets/images/avatar/mood4.png",
      "assets/images/avatar/mood5.png",
    ];

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/avatar/New Journal .png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 40.w,
                        height: 40.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 20.sp,
                        ),
                      ),
                    ),
                    Text(
                      "Your Journals",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Image.asset(
                      "assets/images/avatar/Frame2.png",
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),

              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      SizedBox(height: 12.h),
                      _buildMoodCard(controller, moodImages),
                      SizedBox(height: 16.h),
                      _buildSummaryCard(controller),
                      SizedBox(height: 16.h),
                      _buildGratitudeCard(controller, context),
                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              // Save Button
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Obx(() => controller.isLoading.value
                    ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : CustomButton(
                  text: 'Save',
                  onTap: () async {
                    final token = await UserInfo.getAccessToken();
                    controller.createJournal(token: token);
                  },
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mood Selection Card
  Widget _buildMoodCard(JournalController controller, List<String> moodImages) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How are you feeling?",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20.h),

          // Mood Icons Row
          Obx(() => Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              bool isSelected = controller.selectedMoodIndex.value == index;
              return GestureDetector(
                onTap: () => controller.selectMood(index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.black, width: 2.5)
                        : null,
                    boxShadow: isSelected
                        ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                        : null,
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(isSelected ? 2.w : 0),
                    child: Image.asset(
                      moodImages[index],
                      width: 48.w,
                      height: 48.w,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              );
            }),
          )),

          SizedBox(height: 20.h),

          // Feelings Chips
          Obx(() => Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: controller.feelings.map((feeling) {
              bool isSelected =
              controller.selectedFeelings.contains(feeling);
              return GestureDetector(
                onTap: () => controller.toggleFeeling(feeling),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFFECEDF0)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    feeling,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  // Summary Card
  Widget _buildSummaryCard(JournalController controller) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Write a summary of your day",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 12.h),
          TextField(
            controller: controller.summaryController,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: "Start writing ...",
              hintStyle: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey.shade400,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.black87,
            ),
          ),

          // Show selected image preview
          Obx(() {
            if (controller.selectedImage.value != null) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                height: 100.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: FileImage(controller.selectedImage.value!),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => controller.clearImage(),
                    child: Container(
                      margin: EdgeInsets.all(8.w),
                      padding: EdgeInsets.all(4.w),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16.sp,
                      ),
                    ),
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Show selected file indicator
          Obx(() {
            if (controller.selectedFile.value != null) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.insert_drive_file,
                        color: Colors.blue, size: 24.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        controller.selectedFile.value!.path.split('/').last,
                        style: TextStyle(fontSize: 12.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.clearFile(),
                      child: Icon(Icons.close,
                          color: Colors.red, size: 20.sp),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          // Show selected audio indicator
          Obx(() {
            if (controller.selectedAudio.value != null) {
              return Container(
                margin: EdgeInsets.only(bottom: 12.h),
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  children: [
                    Icon(Icons.audiotrack, color: Colors.purple, size: 24.sp),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        controller.selectedAudio.value!.path.split('/').last,
                        style: TextStyle(fontSize: 12.sp),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.clearAudio(),
                      child: Icon(Icons.close,
                          color: Colors.red, size: 20.sp),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          }),

          SizedBox(height: 8.h),

          // Bottom icons
          Row(
            children: [
              _buildBottomIcon(
                "assets/images/avatar/clip.png",
                onTap: () => controller.pickFile(),
              ),
              SizedBox(width: 17.w),
              _buildBottomIcon(
                "assets/images/avatar/gallary.png",
                onTap: () => controller.pickImage(),
              ),
              SizedBox(width: 18.w),
              _buildBottomIcon(
                "assets/images/avatar/micro.png",
                onTap: () => controller.pickAudio(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(String assetPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        assetPath,
        width: 24.w,
        height: 24.w,
      ),
    );
  }

  // Gratitude Card
  Widget _buildGratitudeCard(
      JournalController controller, BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "List three things you're grateful for today",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16.h),

          // Gratitude items list
          Obx(() => Column(
            children: controller.gratitudeItems.asMap().entries.map((entry) {
              int index = entry.key;
              String item = entry.value;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Text(
                        item,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.removeGratitudeItem(index),
                      child: Icon(
                        Icons.close,
                        color: Colors.red,
                        size: 18.sp,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          )),

          // Add list button (only show if less than 3 items)
          Obx(() {
            if (controller.gratitudeItems.length < 3) {
              return GestureDetector(
                onTap: () => _showAddGratitudeDialog(context, controller),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.grey.shade600,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        "Add list",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  void _showAddGratitudeDialog(
      BuildContext context, JournalController controller) {
    final TextEditingController gratitudeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add gratitude"),
        content: TextField(
          controller: gratitudeController,
          decoration: const InputDecoration(
            hintText: "I'm grateful for...",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              if (gratitudeController.text.isNotEmpty) {
                controller.addGratitudeItem(gratitudeController.text);
              }
              Navigator.pop(context);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}