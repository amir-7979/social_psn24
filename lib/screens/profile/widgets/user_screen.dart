import 'package:flutter/material.dart';

import 'main_tab_bar.dart';
import 'user_info.dart';

class UserScreen extends StatelessWidget {
  UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16),
        UserInfo(),
        SizedBox(height: 16),
        MainTabBar(),
      ],
    );
  }
}
