import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh_notification/pull_to_refresh_notification.dart';
import 'package:social_psn/configs/setting/setting_bloc.dart';
import 'profile_bloc.dart';
import 'widgets/content_info.dart';
import 'widgets/user_info.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isRefreshing = false;

  Future<bool> refreshContent() async {
    setState(() {
      _isRefreshing = true;
    });
    try {
      await Future.delayed(Duration(milliseconds: 200)); // Simulate a network call
      return true;
    } catch (e) {
      return false;
    } finally {
      setState(() {
        _isRefreshing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: Scaffold(
        body: PullToRefreshNotification(
          onRefresh: refreshContent,
          maxDragOffset: 100,
          child: Stack(
            children: [
              Column(
                children: [
                  PullToRefreshContainer((info) {
                    double dragOffset = info?.dragOffset ?? 0.0;
                    return Container(
                      height: dragOffset,
                      alignment: Alignment.center,
                      child: info!= null && info.mode == PullToRefreshIndicatorMode.armed
                          ? Container(

                        height: 40,
                          width: 40,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Theme.of(context).colorScheme.surface,),
                          child: Padding(
                            padding: EdgeInsetsDirectional.all(5),
                            child: CircularProgressIndicator(color: Theme.of(context).primaryColor, strokeWidth: 2),
                          ))
                          : null
                    );
                  }),
                  Expanded(
                    child: ExtendedNestedScrollView(
                      headerSliverBuilder: (context, innerBoxIsScrolled) {
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
                      body: _isRefreshing
                          ? Container()
                          : ContentInfo(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
