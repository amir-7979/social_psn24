import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/cooperation/cooperation_bloc.dart';
import 'package:social_psn/screens/cooperation/widget/expert_user_cooperation.dart';
import 'package:social_psn/screens/cooperation/widget/normal_user_cooperation.dart';

import '../../configs/setting/setting_bloc.dart';

class CooperationScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    SettingState settingState = BlocProvider.of<SettingBloc>(context).state;
    return BlocProvider(
      create: (context) => CooperationBloc(),
      child: settingState.isExpert ? ExpertUserCooperation() : ExpertUserCooperation(),
    );
  }
}
