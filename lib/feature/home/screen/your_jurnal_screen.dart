import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:http/io_client.dart';

import '../../../core/endpoint/api_endpoint.dart';
import '../../../route/route_name.dart';
import '../../../core/local_storage/user_info.dart';


class YourJurnalScreen extends StatefulWidget {
  const YourJurnalScreen({super.key});

  @override
  State<YourJurnalScreen> createState() => _YourJurnalScreenState();
}

class _YourJurnalScreenState extends State<YourJurnalScreen> {
  bool isLoading = false;
  List<Map<String, dynamic>> journalList = [];

  @override
  void initState() {
    super.initState();
    _loadJournals();
  }

  Future<void> _loadJournals() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final token = await UserInfo.getAccessToken();
      final uri = Uri.parse('${ApiEndpoint.baseUrl}/api/authentication/journal/');

      final httpClient = HttpClient()
        ..badCertificateCallback = (cert, host, port) => true;
      final ioClient = IOClient(httpClient);

      print("🌐 [GET] URL: $uri");

      final response = await ioClient.get(
        uri,
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
      );

      print("📩 [GET] Response Code: ${response.statusCode}");
      print("📩 [GET] Response Body: ${response.body}");

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final jsonResponse = jsonDecode(response.body);

        List<dynamic> data = [];

        if (jsonResponse is List) {
          data = jsonResponse;
        } else if (jsonResponse['success'] == true && jsonResponse['data'] != null) {
          data = jsonResponse['data'] is List ? jsonResponse['data'] : [jsonResponse['data']];
        } else if (jsonResponse['results'] != null) {
          data = jsonResponse['results'];
        } else if (jsonResponse['journals'] != null) {
          data = jsonResponse['journals'];
        }

        if (!mounted) return;
        setState(() {
          journalList = data.map((e) => Map<String, dynamic>.from(e)).toList();
        });

        print("✅ [GET] Fetched ${journalList.length} journals");
      }
    } catch (e) {
      print("❌ [GET] Error: $e");
      if (!mounted) return;
      Get.snackbar(
        'Error',
        e.toString().replaceAll('Exception:', '').trim(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  String _getMoodEmoji(String? mood) {
    switch (mood) {
      case 'calm': return '😌';
      case 'chill': return '😎';
      case 'motivated': return '💪';
      case 'grateful': return '🙏';
      case 'curious': return '🤔';
      case 'satisfied': return '😊';
      case 'comfortable': return '😇';
      case 'inspired': return '✨';
      case 'appreciated': return '🥰';
      default: return '😊';
    }
  }

  String _getFormattedTime(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final dateTime = DateTime.parse(createdAt);
      final hour = dateTime.hour == 0 ? 12 : (dateTime.hour > 12 ? dateTime.hour - 12 : dateTime.hour);
      final period = dateTime.hour >= 12 ? 'PM' : 'AM';
      final minute = dateTime.minute.toString().padLeft(2, '0');
      return '$hour:$minute $period';
    } catch (e) {
      return '';
    }
  }

  String _getFormattedDate(String? createdAt) {
    if (createdAt == null) return '';
    try {
      final dateTime = DateTime.parse(createdAt);
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
    } catch (e) {
      return '';
    }
  }

  String _getDisplayTitle(Map<String, dynamic> journal) {
    final summary = journal['summary'] as String?;
    if (summary != null && summary.isNotEmpty) {
      final firstLine = summary.split('\n').first;
      if (firstLine.length > 30) {
        return '${firstLine.substring(0, 30)}...';
      }
      return firstLine;
    }
    return 'Journal Entry';
  }

  String _getPreviewText(Map<String, dynamic> journal) {
    final summary = journal['summary'] as String?;
    if (summary != null && summary.isNotEmpty) {
      if (summary.length > 50) {
        return '${summary.substring(0, 50)}...';
      }
      return summary;
    }
    return 'No content';
  }

  List<String> _getGratitudeList(dynamic gratitudeList) {
    if (gratitudeList == null) return [];
    if (gratitudeList is List) return List<String>.from(gratitudeList);
    if (gratitudeList is String) {
      try {
        return List<String>.from(jsonDecode(gratitudeList));
      } catch (_) {
        return [];
      }
    }
    return [];
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
            image: AssetImage("assets/images/splash/Sign In.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Custom App Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Your Journals",
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        // Navigate and refresh when coming back
                        await Get.toNamed(RouteName.createJurnal);
                        _loadJournals();
                      },
                      child: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFFFFA726),
                              Color(0xFFFF7043),
                            ],
                          ),
                        ),
                        child: Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 28.sp,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Journal List
              Expanded(
                child: isLoading
                    ? const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                )
                    : journalList.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                  onRefresh: () => _loadJournals(),
                  color: const Color(0xFFFFA726),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    itemCount: journalList.length,
                    itemBuilder: (context, index) {
                      final journal = journalList[index];
                      return _buildJournalCard(
                        journal: journal,
                        onTap: () => _showJournalDetail(journal),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 80.w,
            color: Colors.white.withOpacity(0.3),
          ),
          SizedBox(height: 16.h),
          Text(
            "No journals yet",
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Start writing your first journal entry",
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white.withOpacity(0.5),
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () async {
              await Get.toNamed(RouteName.createJurnal);
              _loadJournals();
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                ),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Text(
                "Create Journal",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJournalCard({
    required Map<String, dynamic> journal,
    required VoidCallback onTap,
  }) {
    final mood = journal['mood'] as String?;
    final createdAt = journal['created_at'] as String?;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              _getMoodEmoji(mood),
                              style: TextStyle(fontSize: 18.sp),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                _getDisplayTitle(journal),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          _getPreviewText(journal),
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _getFormattedTime(createdAt),
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        _getFormattedDate(createdAt),
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white.withOpacity(0.4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showJournalDetail(Map<String, dynamic> journal) {
    final mood = journal['mood'] as String?;
    final summary = journal['summary'] as String?;
    final createdAt = journal['created_at'] as String?;
    final gratitudeList = _getGratitudeList(journal['gratitude_list']);

    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 40.h),
        child: Container(
          constraints: BoxConstraints(maxHeight: 600.h),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A2E),
            borderRadius: BorderRadius.circular(24.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24.r),
                    topRight: Radius.circular(24.r),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      _getMoodEmoji(mood),
                      style: TextStyle(fontSize: 32.sp),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Journal Entry",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            "${_getFormattedDate(createdAt)} • ${_getFormattedTime(createdAt)}",
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 24.w,
                      ),
                    ),
                  ],
                ),
              ),

              // Content
              Flexible(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Mood
                      _buildDetailSection(
                        title: "MOOD",
                        child: Row(
                          children: [
                            Text(
                              _getMoodEmoji(mood),
                              style: TextStyle(fontSize: 24.sp),
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              (mood ?? 'motivated').capitalizeFirst ?? '',
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Summary
                      if (summary != null && summary.isNotEmpty)
                        _buildDetailSection(
                          title: "SUMMARY",
                          child: Text(
                            summary,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                          ),
                        ),

                      // Gratitude List
                      if (gratitudeList.isNotEmpty)
                        _buildDetailSection(
                          title: "GRATITUDE",
                          child: Column(
                            children: gratitudeList.map((item) {
                              return Padding(
                                padding: EdgeInsets.only(bottom: 8.h),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      color: Colors.pink,
                                      size: 16.w,
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      child: Text(
                                        item,
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.white.withOpacity(0.9),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailSection({
    required String title,
    required Widget child,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.5),
              letterSpacing: 1,
            ),
          ),
          SizedBox(height: 8.h),
          child,
        ],
      ),
    );
  }
}