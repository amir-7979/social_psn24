import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/screens/profile/widgets/user_screen.dart';
import 'profile_bloc.dart';
import 'widgets/expert_user/edit_expert_user.dart';
import 'widgets/normal_user/edit_normal_user.dart';

class ProfileScreen extends StatefulWidget {
  int index = 0;
  List<Widget> widgets = [];
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {


  @override
  void initState() {
    super.initState();
    widget.widgets = [
      UserScreen(refreshIndex),
      EditNormalUser(refreshIndex),
      EditExpertUser(refreshIndex),
    ];
  }

  void refreshIndex(int i) {
    setState(() {
      widget.index = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
        child: Container(
          child:  widget.widgets[widget.index],
        ),
      ),
    );
  }
}