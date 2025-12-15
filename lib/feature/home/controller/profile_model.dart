class UserProfileResponse {
  final bool success;
  final UserProfileData data;

  UserProfileResponse({
    required this.success,
    required this.data,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      success: json['success'] ?? false,
      data: UserProfileData.fromJson(json['data'] ?? {}),
    );
  }
}

class UserProfileData {
  final UserInfo user;
  final ProfileInfo profile;

  UserProfileData({
    required this.user,
    required this.profile,
  });

  factory UserProfileData.fromJson(Map<String, dynamic> json) {
    return UserProfileData(
      user: UserInfo.fromJson(json['user'] ?? {}),
      profile: ProfileInfo.fromJson(json['profile'] ?? {}),
    );
  }
}

class UserInfo {
  final String id;
  final String email;
  final String role;
  final bool isVerified;

  UserInfo({
    required this.id,
    required this.email,
    required this.role,
    required this.isVerified,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'user',
      isVerified: json['is_verified'] ?? false,
    );
  }
}

class ProfileInfo {
  final String? fullName;
  final String? username;
  final String? phoneNumber;
  final String? dateOfBirth;
  final String? gender;
  final int? age;
  final String? ageRange;
  final String? ageRangeDisplay;
  final String? avatar;
  final String? profilePicture;
  final String? profileImageUrl;
  final String? introduction;
  final String? displayName;
  final bool onboardingCompleted;
  final int progressPercentage;

  ProfileInfo({
    this.fullName,
    this.username,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.age,
    this.ageRange,
    this.ageRangeDisplay,
    this.avatar,
    this.profilePicture,
    this.profileImageUrl,
    this.introduction,
    this.displayName,
    this.onboardingCompleted = false,
    this.progressPercentage = 0,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      fullName: json['full_name'],
      username: json['username'],
      phoneNumber: json['phone_number'],
      dateOfBirth: json['date_of_birth'],
      gender: json['gender'],
      age: json['age'],
      ageRange: json['age_range'],
      ageRangeDisplay: json['age_range_display'],
      avatar: json['avatar'],
      profilePicture: json['profile_picture'],
      profileImageUrl: json['profile_image_url'],
      introduction: json['introduction'],
      displayName: json['display_name'],
      onboardingCompleted: json['onboarding_completed'] ?? false,
      progressPercentage: json['progress_percentage'] ?? 0,
    );
  }

  // Get display gender
  String get displayGender {
    if (gender == null) return 'Select';
    switch (gender!.toLowerCase()) {
      case 'male':
        return 'Male';
      case 'female':
        return 'Female';
      case 'other':
        return 'Other';
      default:
        return 'Select';
    }
  }

  // Get display age range
  String get displayAgeRange {
    return ageRangeDisplay ?? 'Select';
  }
}