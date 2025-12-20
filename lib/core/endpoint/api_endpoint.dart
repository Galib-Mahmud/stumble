class ApiEndpoint {
  static const String baseUrl = "https://joeapi.dsrt321.online";


  static const String signup = "/api/authentication/register/";
  static const String signin = "/api/authentication/login/";
  static const String forgetPass = "/api/authentication/password/reset/";
  static const String resetPass = "/api/authentication/password/reset/confirm/";
  static const String userName = "/api/authentication/onboarding/steps/username/";
  static const String dateOfBirth = "/api/authentication/onboarding/steps/dob/";
  static const String gender = "/api/authentication/onboarding/steps/gender/";
  static const String getQuestions = "/api/authentication/onboarding/questions/";
  static const String submitAnswer = "/api/authentication/onboarding/steps/question-answer/";
  static const String submitAvatar = "/api/authentication/onboarding/steps/avatar/";
  static const String introduction = "/api/authentication/onboarding/steps/introduction/";
  static const String videoUpload = "/api/authentication/video-upload/";
  static const String videoList = "/api/authentication/video-list/";
  static const String videoDelete = "/api/authentication/video-delete/";
  static const String profile = "/api/authentication/profile/";
  static const String profileUpdate = "/api/authentication/profile/update/";
  static const String onboardingStatus = "/api/authentication/onboarding/status/";
  static const String badge = "/api/reward-system/badges-overview/";
  static const String progressPath = "/api/core-business/progress-path/";
  static const String xpPoints = "/api/reward-system/points-overview/";
  static const String bots = "/api/chatbot/bots/";


}