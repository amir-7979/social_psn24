import 'package:flutter/material.dart';
import 'package:social_psn/screens/create_media/create_media_screen.dart';
import 'package:social_psn/screens/interest/interest_screen.dart';
import 'package:social_psn/screens/post_detailed/post_detailed_screen.dart';

import '../../auth/login/login.dart';
import '../../auth/register/register.dart';
import '../../auth/verify/verify.dart';
import '../../charity/charity_screen.dart';
import '../../consultation/consultation_screen.dart';
import '../../cooperation/cooperation_screen.dart';
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
  static const String myProfile = '/my_profile';
  static const String home = '/home';
  static const String consultation = '/consultation';
  static const String charity = '/charity';
  static const String editProfile = '/edit_profile';
  static const String createMedia = '/create_media';
  static const String postDetailed = '/post_detailed';
  static const String interest = '/interest';
  static const String cooperate = '/cooperate';
}

final Map<String, WidgetBuilder> routes = {
  AppRoutes.login: (BuildContext context) => Login(),
  AppRoutes.verify: (BuildContext context){
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return Verify(
      phone: args['phone'],
      LoginId: args['loginId'],
    );
  },
  AppRoutes.register: (BuildContext context) => Register(),
  AppRoutes.main: (BuildContext context) => MainScreen(),
  AppRoutes.profile: (BuildContext context) => ProfileScreen(),
  AppRoutes.myProfile: (BuildContext context) => ProfileScreen(),
  AppRoutes.home: (BuildContext context) => HomeScreen(),
  AppRoutes.consultation: (BuildContext context) => ConsultationScreen(),
  AppRoutes.charity: (BuildContext context) => CharityScreen(),
  AppRoutes.editProfile: (BuildContext context) => EditNormalUser(() {}),
  AppRoutes.createMedia: (BuildContext context) => CreateMediaScreen(),
  AppRoutes.postDetailed: (BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return PostDetailedScreen(
      post: args['post'],
      postId: args['postId'],
    );
  },
  AppRoutes.interest: (BuildContext context) => InterestScreen(),
  AppRoutes.cooperate: (BuildContext context) => CooperationScreen(),

};