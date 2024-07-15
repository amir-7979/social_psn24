import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';

import 'profile_bloc.dart';
import 'widgets/main_tab_bar.dart';
import 'widgets/user_info.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
      child: BlocProvider(
        create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
        child: ListView(
          children: [
            SizedBox(height: 16),
            UserInfo(),
            SizedBox(height: 16),
            MainTabBar(),
          ],
        ),
      )

    );
  }
}