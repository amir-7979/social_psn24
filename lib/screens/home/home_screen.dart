import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/post.dart';
import 'home_bloc.dart';
import 'widgets/main_tab_bar.dart';
import 'widgets/post_list.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late bool seeExpertPost;
  PagingController<int, Post>? _pagingPostController1 =
      PagingController<int, Post>(firstPageKey: 0);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pagingPostController1!.addPageRequestListener((pageKey) {
        HomeBloc.fetchPosts(
            _pagingPostController1!, 10, 0, null, null, null, null);
      });
    });
  }

  void dispose() {
    if (_pagingPostController1 != null) _pagingPostController1!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    seeExpertPost = context.read<SettingBloc>().state.seeExpertPost;

    return Padding(
        padding: const EdgeInsetsDirectional.all(16),
        child: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.background,
          ),
          child: BlocProvider(
              create: (context) => HomeBloc(),
              child: seeExpertPost
                  ? MainTabBar()
                  : PostList(
                      pagingController: _pagingPostController1!,
                      scrollController: ScrollController())),
        ));
  }
}
