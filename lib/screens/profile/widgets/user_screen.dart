import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/setting/setting_bloc.dart';
import '../profile_bloc.dart';
import 'main_tab_bar.dart';
import 'user_info.dart';

class UserScreen extends StatelessWidget {
  final Function refreshIndex;
  UserScreen(this.refreshIndex);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        SizedBox(height: 16),
        UserInfo(refreshIndex),
        SizedBox(height: 16),
        MainTabBar(),
      ],
    );
  }
}
