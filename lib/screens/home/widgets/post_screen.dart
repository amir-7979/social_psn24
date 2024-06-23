import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/home/widgets/main_tab_bar.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/post.dart';
import '../home_bloc.dart';
import 'post_list.dart';

class PostScreen extends StatefulWidget {
  final Function refreshIndex;

  PostScreen(this.refreshIndex);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> with AutomaticKeepAliveClientMixin{
  late bool seeExpertPost;
  PagingController<int, Post>?_pagingPostController1 = PagingController<int, Post>(firstPageKey: 0);

  @override
  bool get wantKeepAlive => true;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pagingPostController1!.addPageRequestListener((pageKey) {
        HomeBloc.fetchPosts(_pagingPostController1!, 10, 0 ,null, null, null, null);
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
    return seeExpertPost ? MainTabBar() : PostList(pagingController: _pagingPostController1!, scrollController: ScrollController());
  }
}
