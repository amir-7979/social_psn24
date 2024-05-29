import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/screens/profile/widgets/user_screen.dart';
import 'profile_bloc.dart';
import 'widgets/expert_user/edit_expert_user.dart';
import 'widgets/normal_user/edit_normal_user.dart';

class ProfileScreen extends StatefulWidget {
   @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 0;

  void _changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
        child: Container(
          child: Stack(
            children: [
              Visibility(
                visible: _currentIndex == 0,
                child: UserScreen(_changeIndex),
                maintainState: false,
              ),
              Visibility(
                visible: _currentIndex == 1,
                child: EditNormalUser(_changeIndex),
                maintainState: false,
              ),
              Visibility(
                visible: _currentIndex == 2,
                child: EditExpertUser(_changeIndex),
                maintainState: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}