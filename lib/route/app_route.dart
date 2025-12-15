import 'package:get/get.dart';
import 'package:stumble/feature/home/screen/orbit_screen.dart';

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
import '../feature/home/screen/home_dashboard_screen.dart';
import '../feature/home/screen/inner_circle_chat_screen.dart';
import '../feature/home/screen/journals_screen.dart';
import '../feature/home/screen/profile_screen.dart';
import '../feature/home/screen/progress_screen.dart';
import '../feature/home/screen/sos_screen.dart';
import '../feature/home/screen/your_jurnal_screen.dart';
import '../feature/splash/screen/onboarding_screen.dart';
import '../feature/splash/screen/question_screen.dart';
import '../feature/splash/screen/start_quiz_screen.dart';
import '../feature/splash/screen/your_badge_screen.dart';
import '../feature/video/my_videos_screen.dart';

class AppRoute {
  static final List<GetPage> pages = [
  GetPage(
      name: RouteName.onboarding,
      page: () => OnboardingScreen(),
      transition: Transition.noTransition,

    ),



    GetPage(
      name: RouteName.startQuiz,
      page: () => StartQuizScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.question,
      page: () => QuestionScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.termsAndUse,
      page: () => TermsAndUseScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.privacyPolicy,
      page: () => PrivacyPolicyScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.disclaimers,
      page: () => DisclaimersScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.dataRetention,
      page: () => DataRetentionDeletionPolicyScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.mainScreen,
      page: () => MainScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.constellationTora,
      page: () => ConstellationScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.skyTora,
      page: () => YourSkyScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.signIn,
      page: () => SignInScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.signUp,
      page: () => SignUpScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.signUpOtp,
      page: () => SignUpOtpScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.forgetPassword,
      page: () => ForgetPasswordScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.forgetPasswordOtp,
      page: () => ForgetPasswordOtpScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.resetPassword,
      page: () => ResetPasswordScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.settings,
      page: () => SettingsScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.birthday,
      page: () => BirthdayScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.username,
      page: () => UsernameScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.gender,
      page: () => GenderScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.findConstellation,
      page: () => FindConstellationScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.selectAvatar,
      page: () => SelectAvatarScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.terms,
      page: () => TermsScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.shareYourMind,
      page: () => ShareYourMindScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.profile,
      page: () => ProfileScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.editProfile,
      page: () => EditProfileScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.yourBadges,
      page: () => YourBadgesScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.yourJurnal,
      page: () => YourJurnalScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.createJurnal,
      page: () => CreateJournalScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.homeDashboard,
      page: () => HomeDashboardScreen(),
      transition: Transition.noTransition,

    ),

    GetPage(
      name: RouteName.sos,
      page: () => SupportScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.progressPath,
      page: () => ProgressPathScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.orbit,
      page: () => OrbitQuotesScreen(),
      transition: Transition.noTransition,

    ),
    GetPage(
      name: RouteName.innerCircleChat,
      page: () => InnerCircleChatScreen(),
      transition: Transition.noTransition,

    ),  GetPage(
      name: RouteName.videoList,
      page: () => MyVideosScreen(),
      transition: Transition.noTransition,

    ),





//


  ];
}
