class VideoModel {
  final String id;
  final String videoFile;
  final String videoUrl;
  final String mimeType;
  final DateTime uploadedAt;
  final String? description;
  String? duration;

  VideoModel({
    required this.id,
    required this.videoFile,
    required this.videoUrl,
    required this.mimeType,
    required this.uploadedAt,
    this.description,
    this.duration,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'] ?? '',
      videoFile: json['video_file'] ?? '',
      videoUrl: json['video_url'] ?? '',
      mimeType: json['mime_type'] ?? 'video/mp4',
      uploadedAt: DateTime.parse(json['uploaded_at']),
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_file': videoFile,
      'video_url': videoUrl,
      'mime_type': mimeType,
      'uploaded_at': uploadedAt.toIso8601String(),
      'description': description,
    };
  }

  /// Get filename from URL
  String get fileName {
    final uri = Uri.parse(videoUrl);
    final pathSegments = uri.pathSegments;
    if (pathSegments.isNotEmpty) {
      String name = pathSegments.last;
      // Remove extension if too long
      if (name.length > 25) {
        name = "${name.substring(0, 20)}...${name.split('.').last}";
      }
      return name;
    }
    return 'Video';
  }

  /// Get formatted upload date
  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(uploadedAt);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes}m ago';
      }
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    }

    return '${uploadedAt.day}/${uploadedAt.month}/${uploadedAt.year}';
  }

  /// Get full formatted date with time
  String get fullFormattedDate {
    return '${uploadedAt.day}/${uploadedAt.month}/${uploadedAt.year} at ${uploadedAt.hour}:${uploadedAt.minute.toString().padLeft(2, '0')}';
  }
}

class VideoListResponse {
  final bool success;
  final int count;
  final List<VideoModel> results;

  VideoListResponse({
    required this.success,
    required this.count,
    required this.results,
  });

  factory VideoListResponse.fromJson(Map<String, dynamic> json) {
    return VideoListResponse(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => VideoModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}