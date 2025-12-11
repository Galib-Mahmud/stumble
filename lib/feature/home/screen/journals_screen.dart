import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../widget/onboarding/custom_button.dart';

class CreateJournalScreen extends StatefulWidget {
  const CreateJournalScreen({super.key});

  @override
  State<CreateJournalScreen> createState() => _CreateJournalScreenState();
}

class _CreateJournalScreenState extends State<CreateJournalScreen> {
  int selectedMoodIndex = 3; // Default selected (happy face)
  List<String> selectedFeelings = ['Motivated'];
  final TextEditingController _summaryController = TextEditingController();
  List<String> gratitudeItems = [];

  // Your custom mood icon paths - update these to match your actual file names
  final List<String> moodImages = [
    "assets/images/avatar/mood1.png", // Very sad - red
    "assets/images/avatar/mood2.png", // Sad - orange
    "assets/images/avatar/mood3.png", // Neutral - blue
    "assets/images/avatar/mood4.png", // Happy - yellow
    "assets/images/avatar/mood5.png", // Very happy - green
  ];

  final List<String> feelings = [
    'Calm',
    'Chill',
    'Motivated',
    'Grateful',
    'Curious',
    'Satisfied',
    'Comfortable',
    'Inspired',
    'Appreciated',
  ];

  @override
  void dispose() {
    _summaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                    // Right icon (link/chain icon)
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

                      // How are you feeling card
                      _buildMoodCard(),

                      SizedBox(height: 16.h),

                      // Write a summary card
                      _buildSummaryCard(),

                      SizedBox(height: 16.h),

                      // Gratitude list card
                      _buildGratitudeCard(),

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomButton(
                  text: 'Save',
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Mood Selection Card
  Widget _buildMoodCard() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (index) {
              return _buildMoodIcon(index);
            }),
          ),

          SizedBox(height: 20.h),

          // Feelings Chips
          Wrap(
            spacing: 8.w,
            runSpacing: 10.h,
            children: feelings.map((feeling) {
              bool isSelected = selectedFeelings.contains(feeling);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      selectedFeelings.remove(feeling);
                    } else {
                      selectedFeelings.add(feeling);
                    }
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFFECEDF0): Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color:  Colors.grey.shade300,

                    ),
                  ),
                  child: Text(
                    feeling,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color:  Colors.black,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // Build individual mood icon with custom images
  Widget _buildMoodIcon(int index) {
    bool isSelected = selectedMoodIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMoodIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 52.w,
        height: 52.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
            color: Colors.black,
            width: 2.5,
          )
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
  }

  // Summary Card
  Widget _buildSummaryCard() {
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
            controller: _summaryController,
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
          SizedBox(height: 8.h),
          // Bottom icons
          Row(
            children: [
              _buildBottomIcon("assets/images/avatar/clip.png"),
              SizedBox(width: 17.w),
              _buildBottomIcon("assets/images/avatar/gallary.png"),
              SizedBox(width: 18.w),
              _buildBottomIcon("assets/images/avatar/micro.png"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomIcon(String assetPath) {
    return GestureDetector(
      onTap: () {
        // Handle icon tap
      },
      child: Image.asset(
        assetPath,
        width: 24.w,
        height: 24.w,

      ),
    );
  }

  // Gratitude Card
  Widget _buildGratitudeCard() {
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
          ...gratitudeItems.map((item) => Padding(
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
              ],
            ),
          )),

          // Add list button
          GestureDetector(
            onTap: () {
              _showAddGratitudeDialog();
            },
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
          ),
        ],
      ),
    );
  }

  void _showAddGratitudeDialog() {
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
                setState(() {
                  gratitudeItems.add(gratitudeController.text);
                });
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