import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/widgets/dialogs/my_alert_dialog.dart';

import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/post.dart';
import '../widgets/dialogs/my_confirm_dialog.dart';
import 'home_bloc.dart';
import 'shimmer/shimmer_post_item.dart';
import 'widgets/main_tab_bar.dart';
import 'widgets/normal_user_post_list.dart';
import 'widgets/search_list.dart';

class HomeScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (previous, current) => previous != current && current is! HomeInitialState,
      builder: (context, state) {
        print('HomeScreen ${state}');
    return Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
          ),
          child:  state is SearchParams ? SearchList(query: state.query, tag: state.tag, type: state.type) : state is SearchLoadingState ? SizedBox(
            height: 800,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => RepaintBoundary(
                child: Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                  child: ShimmerPostItem(),
                ),

              ),
            ),
          ) : Container(
              child: context.read<SettingBloc>().state.seeExpertPost
                  ? MainTabBar()
                  : NormalUserPostList()),
        ));
      },
    );
  }
}
