

import 'package:get/get.dart';
import 'package:stumble/feature/home/main_screen.dart';
import 'package:stumble/feature/splash/screen/onboarding_screen1.dart';
import 'package:stumble/route/route_name.dart';

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
  name: RouteName.mainScreen,
  page: () => MainScreen(),
  transition: Transition.rightToLeft,
  transitionDuration: Duration(milliseconds: 300),
  ),



];
}