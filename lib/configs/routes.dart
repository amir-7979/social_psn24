import 'package:flutter/material.dart';
import '../screens/charity/charity_screen.dart';
import '../screens/consultation/consultation_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/interest/interest_screen.dart';
import '../screens/main/main_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/profile/widgets/normal_user/edit_normal_user.dart';


class AppRoutes {
  static const String main = '/main';
  static const String profile = '/profile';
  static const String home = '/home';
  static const String consultation = '/consultation';
  static const String charity = '/charity';
  static const String editProfile = '/editProfile';

  /* static const String login = '/login';
  static const String verify = '/verify';
  static const String register = '/register';*/
  static const String temp = '/temp';
}
final Map<String, WidgetBuilder> routes = {
  AppRoutes.main: (BuildContext context) =>  MainScreen(),
  AppRoutes.profile: (BuildContext context) => ProfileScreen(),
  AppRoutes.home: (BuildContext context) =>  HomeScreen(),
  AppRoutes.consultation: (BuildContext context) =>  ConsultationScreen(),
  AppRoutes.charity: (BuildContext context) =>  CharityScreen(),
  AppRoutes.editProfile: (BuildContext context) =>  EditNormalUser((){}),

  /*AppRoutes.login: (BuildContext context) =>  Login(),
  AppRoutes.verify: (BuildContext context) =>  Verify(),
  AppRoutes.register: (BuildContext context) =>  Register(),*/

  // Add more routes here
};
