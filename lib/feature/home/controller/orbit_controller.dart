import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../../core/local_storage/user_info.dart' as local_storage;
import '../../../core/endpoint/api_endpoint.dart';

class OrbitPost {
  final int id;
  final String title;
  final String image;
  final String imageUrl;
  final String description;
  final String createdAt;

  OrbitPost({
    required this.id,
    required this.title,
    required this.image,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
  });

  factory OrbitPost.fromJson(Map<String, dynamic> json) {
    return OrbitPost(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}

class OrbitController extends GetxController {
  RxBool isLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<OrbitPost> posts = <OrbitPost>[].obs;
  RxInt postCount = 0.obs;

  // Predefined gradient colors for cards
  final List<List<Color>> gradientColors = [
    [const Color(0xFF87CEEB), const Color(0xFFDDA0DD), const Color(0xFFFFB347)],
    [const Color(0xFF6366F1), const Color(0xFF8B5CF6), const Color(0xFFEC4899)],
    [const Color(0xFF20B2AA), const Color(0xFF98FB98), const Color(0xFFFFB347)],
    [const Color(0xFFFCD34D), const Color(0xFFF97316)],
    [const Color(0xFF06B6D4), const Color(0xFF3B82F6), const Color(0xFF10B981)],
    [const Color(0xFFFF6B6B), const Color(0xFFFFE66D)],
    [const Color(0xFF4ECDC4), const Color(0xFF556270)],
    [const Color(0xFFFC5C7D), const Color(0xFF6A82FB)],
  ];

  @override
  void onInit() {
    fetchOrbitPosts();
    super.onInit();
  }

  Future<void> fetchOrbitPosts() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      errorMessage.value = "Please login again.";
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Update this endpoint according to your API
      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.orbitPosts}");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final orbitData = data['data'];
          postCount.value = orbitData['count'] ?? 0;

          if (orbitData['posts'] != null) {
            posts.value = (orbitData['posts'] as List)
                .map((post) => OrbitPost.fromJson(post))
                .toList();
          }
        }
      } else {
        errorMessage.value = "Failed to load orbit posts";
      }
    } catch (e) {
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  // Get gradient colors for a post based on index
  List<Color> getGradientForIndex(int index) {
    return gradientColors[index % gradientColors.length];
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    await fetchOrbitPosts();
  }
}