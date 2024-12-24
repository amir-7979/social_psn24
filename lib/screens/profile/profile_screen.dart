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

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // Keeps the widget alive
  bool _isRefreshingContent = false;

  Future<void> _refreshContent() async {
    setState(() {
      _isRefreshingContent = true;
    });

    // Simulate data fetching or replace with your own logic
    await Future.delayed(Duration(seconds: 1));

    setState(() {
      _isRefreshingContent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            notificationPredicate: (notification) => notification.depth == 2,
            triggerMode: RefreshIndicatorTriggerMode.anywhere,
            displacement: 10.0,
            edgeOffset: 10.0,
            onRefresh: () async {
              int? profileId =
              ModalRoute.of(context)?.settings.arguments as int?;
              if (profileId != null) {
                context.read<ProfileBloc>().add(FetchProfileEvent(id: profileId));
              } else {
                context.read<ProfileBloc>().add(FetchMyProfileEvent());
              }
              await _refreshContent();
            },
            child: NestedScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                return [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        SizedBox(height: 16),
                        UserInfo(),
                        SizedBox(height: 16),
                      ],
                    ),
                  ),
                ];
              },
              body: _isRefreshingContent
                  ? Center(child: CircularProgressIndicator())
                  : ContentInfo(),
            ),
          );
        },
      ),
    );
  }

}
