import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';

import 'profile_bloc.dart';
import 'widgets/content_info.dart';
import 'widgets/user_info.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isRefreshingContent = false;

  Future<void> _refreshContent() async {
    setState(() {
      _isRefreshingContent = true; // Show the placeholder
    });

    // Simulate a delay to refresh content or wait for actual data fetch
    await Future.delayed(Duration.zero);

    setState(() {
      _isRefreshingContent = false; // Show the ContentInfo again
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor, // Foreground color of the progress bar
            backgroundColor: Theme.of(context).scaffoldBackgroundColor, // Background color
            onRefresh: () async {
              int? profileId = ModalRoute.of(context)?.settings.arguments as int?;
              if (profileId != null) {
                context.read<ProfileBloc>().add(FetchProfileEvent(id: profileId));
              } else {
                context.read<ProfileBloc>().add(FetchMyProfileEvent());
              }

              // Trigger content refresh
              await _refreshContent();
            },
            child: ListView(
              physics: ClampingScrollPhysics(),
              children: [
                SizedBox(height: 16),
                UserInfo(),
                SizedBox(height: 16),
                // Conditionally show placeholder or ContentInfo
                _isRefreshingContent
                    ? Container(
                  height: 1000, // Adjust height based on your ContentInfo
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(), // Or any placeholder widget
                )
                    : ContentInfo(),
              ],
            ),
          );
        },
      ),
    );
  }
}