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
  RxBool isFavorite;

  OrbitPost({
    required this.id,
    required this.title,
    required this.image,
    required this.imageUrl,
    required this.description,
    required this.createdAt,
    bool isFavorite = false,
  }) : isFavorite = isFavorite.obs;

  factory OrbitPost.fromJson(Map<String, dynamic> json, {bool isFavorite = false}) {
    return OrbitPost(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      imageUrl: json['image_url'] ?? '',
      description: json['description'] ?? '',
      createdAt: json['created_at'] ?? '',
      isFavorite: isFavorite,
    );
  }
}

class FavoriteOrbitPost {
  final int id;
  final OrbitPost orbitPost;
  final String favoritedAt;

  FavoriteOrbitPost({
    required this.id,
    required this.orbitPost,
    required this.favoritedAt,
  });

  factory FavoriteOrbitPost.fromJson(Map<String, dynamic> json) {
    return FavoriteOrbitPost(
      id: json['id'] ?? 0,
      orbitPost: OrbitPost.fromJson(json['orbit_post'] ?? {}, isFavorite: true),
      favoritedAt: json['favorited_at'] ?? '',
    );
  }
}

class OrbitController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isFavoriteLoading = false.obs;
  RxString errorMessage = ''.obs;
  RxList<OrbitPost> posts = <OrbitPost>[].obs;
  RxList<FavoriteOrbitPost> favoritePosts = <FavoriteOrbitPost>[].obs;
  RxSet<int> favoritePostIds = <int>{}.obs;
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
    fetchFavoriteOrbitPosts().then((_) => fetchOrbitPosts());
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
            posts.value = (orbitData['posts'] as List).map((post) {
              final postId = post['id'] ?? 0;
              final isFav = favoritePostIds.contains(postId);
              return OrbitPost.fromJson(post, isFavorite: isFav);
            }).toList();
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

  // Fetch all favorite orbit posts
  Future<void> fetchFavoriteOrbitPosts() async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      return;
    }

    try {
      isFavoriteLoading.value = true;

      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.favoriteOrbitPost}");
      final response = await http.get(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data is List) {
          favoritePosts.value = data
              .map((item) => FavoriteOrbitPost.fromJson(item))
              .toList();

          // Update favorite IDs set
          favoritePostIds.value = favoritePosts
              .map((fav) => fav.orbitPost.id)
              .toSet();

          // Update isFavorite status for existing posts
          _updatePostsFavoriteStatus();
        }
      }
    } catch (e) {
      debugPrint("Error fetching favorite posts: $e");
    } finally {
      isFavoriteLoading.value = false;
    }
  }

  // Toggle favorite status with confirmation popup
  Future<void> toggleFavorite(OrbitPost post, BuildContext context) async {
    final bool currentFavorite = post.isFavorite.value;

    if (!currentFavorite) {
      // Show confirmation popup for adding to favorites
      final result = await _showFavoriteConfirmationDialog(context, post);
      if (result == true) {
        await _addToFavorites(post);
      }
    } else {
      // Show confirmation popup for removing from favorites
      final result = await _showRemoveFavoriteDialog(context, post);
      if (result == true) {
        await _removeFromFavorites(post);
      }
    }
  }

  Future<bool?> _showFavoriteConfirmationDialog(BuildContext context, OrbitPost post) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B4B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD700).withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star,
                    color: Color(0xFFFFD700),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Add to Favorites',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Do you want to add "${post.title}" to your favorite list?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool?> _showRemoveFavoriteDialog(BuildContext context, OrbitPost post) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1B4B),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.star_border,
                    color: Colors.red,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Remove from Favorites',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Do you want to remove "${post.title}" from your favorite list?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(
                              color: Colors.white.withOpacity(0.3),
                            ),
                          ),
                        ),
                        child: const Text(
                          'No',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Yes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _addToFavorites(OrbitPost post) async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Error',
        'Please login again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.favoriteOrbitPost}");
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "orbit_post_id": post.id,
          "favorite": true,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local state
        post.isFavorite.value = true;
        favoritePostIds.add(post.id);

        // Refresh favorite posts list
        await fetchFavoriteOrbitPosts();

        Get.snackbar(
          'Success',
          'Added to favorites',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF6366F1),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add to favorites',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _removeFromFavorites(OrbitPost post) async {
    final token = await local_storage.UserInfo.getAccessToken();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Error',
        'Please login again',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      final uri = Uri.parse("${ApiEndpoint.baseUrl}${ApiEndpoint.favoriteOrbitPost}");
      final response = await http.post(
        uri,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: json.encode({
          "orbit_post_id": post.id,
          "favorite": false,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Update local state
        post.isFavorite.value = false;
        favoritePostIds.remove(post.id);

        // Remove from favorites list
        favoritePosts.removeWhere((fav) => fav.orbitPost.id == post.id);

        Get.snackbar(
          'Success',
          'Removed from favorites',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF6366F1),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove from favorites',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Something went wrong',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void _updatePostsFavoriteStatus() {
    for (var post in posts) {
      post.isFavorite.value = favoritePostIds.contains(post.id);
    }
  }

  // Get gradient colors for a post based on index
  List<Color> getGradientForIndex(int index) {
    return gradientColors[index % gradientColors.length];
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    await fetchFavoriteOrbitPosts();
    await fetchOrbitPosts();
  }
}