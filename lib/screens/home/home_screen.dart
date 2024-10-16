import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../configs/setting/setting_bloc.dart';
import 'home_bloc.dart';
import 'shimmer/shimmer_post_item.dart';
import 'widgets/main_tab_bar.dart';
import 'widgets/normal_user_post_list.dart';
import 'widgets/search_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late bool seeExpertPost;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    seeExpertPost = context.read<SettingBloc>().state.seeExpertPost;
    return BlocBuilder<HomeBloc, HomeState>(

      builder: (context, state) {
        return Padding(
            padding: const EdgeInsetsDirectional.all(16),
            child: Container(
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.background,
              ),
              child: state is SearchParams
                  ? SearchList(
                      query: state.query, tag: state.tag, type: state.type)
                  : state is SearchLoadingState
                      ? SizedBox(
                          height: 800,
                          child: ListView.builder(
                            itemCount: 20,
                            itemBuilder: (context, index) =>
                                RepaintBoundary(
                              child: Padding(
                                padding:
                                    const EdgeInsetsDirectional.fromSTEB(
                                        10, 0, 10, 10),
                                child: ShimmerPostItem(),
                              ),
                            ),
                          ),
                        )
                      : Container(
                          child: seeExpertPost
                              ? MainTabBar()
                              : NormalUserPostList()),
            ));
      },
    );
  }
}
