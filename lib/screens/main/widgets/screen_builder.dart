import 'package:flutter/material.dart';
import 'package:social_psn/configs/setting/settings_screen.dart';
import 'package:social_psn/screens/create_post/create_post_screen.dart';
import 'package:social_psn/screens/interest/interest_screen.dart';
import 'package:social_psn/screens/post_detailed/post_detailed_screen.dart';

import '../../auth/login/login.dart';
import '../../auth/register/register.dart';
import '../../auth/verify/verify.dart';
import '../../center_consultant/center_consultant_screen.dart';
import '../../charity/charity_screen.dart';
import '../../cooperation/cooperation_screen.dart';
import '../../create_consultation/create_consultation_screen.dart';
import '../../edit_profile/edit_profile_screen.dart';
import '../../home/home_screen.dart';
import '../../my_consultation/my_consultation_screen.dart';
import '../../profile/profile_screen.dart';
import '../../requests/create_request/create_request_screen.dart';
import '../../requests/requests_list/requests_list_screen.dart';
import '../main_screen.dart';

class AppRoutes {
  static const String login = '/login';
  static const String verify = '/verify';
  static const String register = '/register';
  static const String main = '/main';
  static const String profile = '/profile';
  static const String myProfile = '/my_profile';
  static const String home = '/';
  static const String myConsultation = '/my_consultation';
  static const String charity = '/charity';
  static const String editProfile = '/edit_profile';
  static const String createMedia = '/create_media';
  static const String postDetailed = '/post_detailed';
  static const String interest = '/interest';
  static const String requestsList = '/requests_list';
  static const String createRequest = '/create_requests';
  static const String settings = '/settings';
  static const String createConsult = '/create_consult';
  static const String centerConsultants = '/center_consultants';


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
  AppRoutes.myConsultation: (BuildContext context) => MyConsultationScreen(),
  AppRoutes.charity: (BuildContext context) => CharityScreen(),
  AppRoutes.editProfile: (BuildContext context) => EditProfileScreen(),
  AppRoutes.createMedia: (BuildContext context) => CreatePostScreen(),
  AppRoutes.postDetailed: (BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return PostDetailedScreen(
      post: args['post'],
      postId: args['postId'],
      postBloc: args['postBloc'],
      commentId: args['commentId'],
    );
  },
  AppRoutes.interest: (BuildContext context) => InterestScreen(),
  AppRoutes.requestsList: (BuildContext context) => RequestsListScreen(),
  AppRoutes.createRequest: (BuildContext context) => CreateRequestScreen(),
  AppRoutes.settings: (BuildContext context) => SettingScreen(),
  AppRoutes.createConsult: (BuildContext context) => CreateConsultationScreen(),
  AppRoutes.centerConsultants: (BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    return CenterConsultantScreen(
      consultants: args['consultants'],
    );

  },

};
