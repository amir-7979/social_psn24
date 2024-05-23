import 'package:flutter/material.dart';

import '../../charity/charity_screen.dart';
import '../../consultation/consultation_screen.dart';
import '../../home/home_screen.dart';
import '../../profile/profile_screen.dart';
import 'base_widget.dart';

Widget buildBody(int index) {
  switch (index) {
    case 0:
      return ProfileScreen(key: ValueKey(DateTime.now()));
    case 1:
      return HomeScreen();
    case 2:
      return BaseWidget();
    case 3:
      return ConsultationScreen();
    case 4:
      return CharityScreen();
    default:
      return HomeScreen();
  }
}