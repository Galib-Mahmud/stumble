import 'package:get/get.dart';
import 'package:stumble/feature/splash/screen/onboarding_screen1.dart';
import 'package:stumble/route/route_name.dart';

import '../feature/auth/screen/birthday_screen.dart';
import '../feature/auth/screen/find_constellation_screen.dart';
import '../feature/auth/screen/forget_password_otp_screen.dart';
import '../feature/auth/screen/forget_password_screen.dart';
import '../feature/auth/screen/gender_screen.dart';
import '../feature/auth/screen/reset_password_screen.dart';
import '../feature/auth/screen/select_avatar_screen.dart';
import '../feature/auth/screen/share_your_mind.dart';
import '../feature/auth/screen/sign_in_screen.dart';
import '../feature/auth/screen/sign_up_otp_screen.dart';
import '../feature/auth/screen/sign_up_screen.dart';
import '../feature/auth/screen/terms_screen.dart';
import '../feature/auth/screen/username_screen.dart';
import '../feature/condition/screen/data_retention_screen.dart';
import '../feature/condition/screen/disclaimers_screen.dart';
import '../feature/condition/screen/privacy_policy_screen.dart';
import '../feature/condition/screen/settings.dart';
import '../feature/condition/screen/terms_and_use_screen.dart';
import '../feature/constellation/screen/constellation_tora.dart';
import '../feature/constellation/screen/sky_tora_screen.dart';
import '../feature/home/main_screen.dart';
import '../feature/home/screen/edit_profile_screen.dart';
import '../feature/home/screen/profile_screen.dart';
import '../feature/splash/screen/onboarding_screen2.dart';
import '../feature/splash/screen/onboarding_screen3.dart';
import '../feature/splash/screen/question_screen.dart';
import '../feature/splash/screen/start_quiz_screen.dart';

class AppRoute {
  static final List<GetPage> pages = [
    GetPage(
      name: RouteName.onboarding1,
      page: () => OnboardingScreen1(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.onboarding2,
      page: () => OnboardingScreen2(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.onboarding3,
      page: () => OnboardingScreen3(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.startQuiz,
      page: () => StartQuizScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.question,
      page: () => QuestionScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.termsAndUse,
      page: () => TermsAndUseScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    GetPage(
      name: RouteName.privacyPolicy,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    GetPage(
      name: RouteName.disclaimers,
      page: () => DisclaimersScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.dataRetention,
      page: () => DataRetentionDeletionPolicyScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.mainScreen,
      page: () => MainScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    GetPage(
      name: RouteName.constellationTora,
      page: () => ConstellationScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    GetPage(
      name: RouteName.skyTora,
      page: () => YourSkyScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.signIn,
      page: () => SignInScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.signUp,
      page: () => SignUpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.signUpOtp,
      page: () => SignUpOtpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.forgetPassword,
      page: () => ForgetPasswordScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.forgetPasswordOtp,
      page: () => ForgetPasswordOtpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.resetPassword,
      page: () => ResetPasswordScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),

    GetPage(
      name: RouteName.settings,
      page: () => SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.birthday,
      page: () => BirthdayScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.username,
      page: () => UsernameScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.gender,
      page: () => GenderScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.findConstellation,
      page: () => FindConstellationScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.selectAvatar,
      page: () => SelectAvatarScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.terms,
      page: () => TermsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.shareYourMind,
      page: () => ShareYourMindScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.profile,
      page: () => ProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
    GetPage(
      name: RouteName.editProfile,
      page: () => EditProfileScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: Duration(milliseconds: 300),
    ),
//


  ];
}
