class ApiEndpoint {
  static const String baseUrl = "https://joeapi.dsrt321.online/api";


  static const String signup = "/authentication/register/";
  static const String signin = "/authentication/login/";
  static const String forgetPass = "/authentication/password/reset/";
  static const String resetPass = "/authentication/password/reset/confirm/";
  static const String userName = "/authentication/onboarding/steps/username/";
  static const String dateOfBirth = "/authentication/onboarding/steps/dob/";
  static const String gender = "/authentication/onboarding/steps/gender/";
  static const String getQuestions = "/authentication/onboarding/questions/";
  static const String submitAnswer = "/authentication/onboarding/steps/question-answer/";
  static const String submitAvatar = "/authentication/onboarding/steps/avatar/";
  static const String introduction = "/authentication/onboarding/steps/introduction/";
}