import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'package:social_psn/screens/profile/widgets/user_screen.dart';
import 'profile_bloc.dart';
import 'widgets/expert_user/edit_expert_user.dart';
import 'widgets/normal_user/edit_normal_user.dart';

class ProfileScreen extends StatelessWidget {
  Widget? _lastWidget;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    SettingState settingState = BlocProvider.of<SettingBloc>(context).state;
    return BlocProvider<ProfileBloc>(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          Widget? currentWidget = profileWidget(state, settingState);
          if (currentWidget != null) {
            _lastWidget = currentWidget;
          }
          return Padding(
            padding: EdgeInsetsDirectional.fromSTEB(16, 0, 16, 16),
            child: Container(
              child: _lastWidget,
            ),
          );
        },
      ),
    );
  }

  Widget? profileWidget(ProfileState state, SettingState settingState) {
    final bool isUserExpert = settingState.isUserExpert; // Replace with actual property
    if (state is ProfileInitial || state is EditProfileInfoLoaded) {
      return UserScreen(); // Replace with actual widgets
    } else if (state is NavigationToEditScreenState) {
      return isUserExpert ? EditExpertUser() : EditNormalUser(); // Replace with actual widgets
    }
  }
}