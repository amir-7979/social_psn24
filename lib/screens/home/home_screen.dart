import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configs/setting/setting_bloc.dart';
import 'home_bloc.dart';
import 'shimmer/shimmer_post_item.dart';
import 'widgets/main_tab_bar.dart';
import 'widgets/normal_user_post_list.dart';
import 'widgets/search_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true; // Keeps the widget alive

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is SearchParams) {
          return SearchList(query: state.query, tag: state.tag, type: state.type);
        } else if (state is SearchLoadingState) {
          return SizedBox(
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
          );
        }

        final seeExpertPost = context.read<SettingBloc>().state.seeExpertPost;
        return seeExpertPost ? MainTabBar() : NormalUserPostList();
      },
    );
  }
}
