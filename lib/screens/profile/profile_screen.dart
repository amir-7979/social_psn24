import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/screens/profile/widgets/expert_user/content_expert_tab.dart';

import 'profile_bloc.dart';
import 'widgets/content_info.dart';
import 'widgets/shimmer/shimmer_user_info.dart';
import 'widgets/user_info.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(height: 16),
            UserInfo(),
            SizedBox(height: 16),
            ContentInfo(),
          ],
        ),
      ),
    );
  }
}