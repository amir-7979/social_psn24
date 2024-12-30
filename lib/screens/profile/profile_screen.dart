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

class _ProfileScreenState extends State<ProfileScreen>{
  bool _isRefreshingContent = false;
  late ScrollController _parentController;
  late ScrollController _nestedController;

  @override
  void initState() {
    super.initState();
    _parentController = ScrollController();
    _nestedController = ScrollController();

    // Sync scroll offsets
    _parentController.addListener(() {
      if (_nestedController.hasClients &&
          _parentController.offset != _nestedController.offset) {
        _nestedController.jumpTo(_parentController.offset);
      }
    });

    _nestedController.addListener(() {
      if (_parentController.hasClients &&
          _nestedController.offset != _parentController.offset) {
        _parentController.jumpTo(_nestedController.offset);
      }
    });
  }

  @override
  void dispose() {
    _parentController.dispose();
    _nestedController.dispose();
    super.dispose();
  }


  Future<void> refreshContent() async {
    setState(() {
      _isRefreshingContent = true;
    });
    await Future.delayed(Duration.zero);
    setState(() {
      _isRefreshingContent = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileBloc(BlocProvider.of<SettingBloc>(context)),
      child: Builder(
        builder: (context) {
          return RefreshIndicator(
            color: Theme.of(context).primaryColor,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onRefresh: refreshContent,
            child: ListView(
              controller: _parentController,
              children: [
                SizedBox(height: 16),
                UserInfo(),
                SizedBox(height: 16),
                _isRefreshingContent
                    ? Center(child: CircularProgressIndicator())
                    : ContentInfo(_nestedController),
              ],
            ),
          );

        },
      ),
    );
  }

}
