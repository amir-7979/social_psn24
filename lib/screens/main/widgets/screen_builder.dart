import 'package:flutter/material.dart';
import 'package:social_psn/screens/create_media/create_media_screen.dart';
import 'package:social_psn/screens/interest/interest_screen.dart';
import 'package:social_psn/screens/post_detailed/post_detailed_screen.dart';
import '../../../repos/models/post.dart';
import '../../auth/widgets/login.dart';
import '../../auth/widgets/register.dart';
import '../../auth/widgets/verify.dart';
import '../../charity/charity_screen.dart';
import '../../consultation/consultation_screen.dart';
import '../../home/home_screen.dart';
import '../../profile/profile_screen.dart';
import '../../profile/widgets/normal_user/edit_normal_user.dart';
import '../main_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String verify = '/verify';
  static const String register = '/register';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String consultation = '/consultation';
  static const String charity = '/charity';
  static const String editProfile = '/edit_profile';
  static const String createMedia = '/create_media';
  static const String postDetailed = '/post_detailed';
  static const String interest = '/interest';
}

final Map<String, WidgetBuilder> routes = {
  AppRoutes.login: (BuildContext context) => Login(),
  AppRoutes.verify: (BuildContext context) => Verify(),
  AppRoutes.register: (BuildContext context) => Register(),
  AppRoutes.main: (BuildContext context) => MainScreen(),
  AppRoutes.profile: (BuildContext context) => ProfileScreen(),
  AppRoutes.home: (BuildContext context) => HomeScreen(),
  AppRoutes.consultation: (BuildContext context) => ConsultationScreen(),
  AppRoutes.charity: (BuildContext context) => CharityScreen(),
  AppRoutes.editProfile: (BuildContext context) => EditNormalUser(() {}),
  AppRoutes.createMedia: (BuildContext context) => CreateMediaScreen(),
  AppRoutes.postDetailed: (BuildContext context) => PostDetailedScreen(ModalRoute.of(context)!.settings.arguments as Post),
  AppRoutes.interest: (BuildContext context) => InterestScreen(),
};
