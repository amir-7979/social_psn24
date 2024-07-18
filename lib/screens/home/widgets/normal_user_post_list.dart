import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../configs/setting/themes.dart';
import '../../../repos/models/post.dart';
import '../home_bloc.dart';
import 'post_list.dart';

class NormalUserPostList extends StatefulWidget {
  const NormalUserPostList({super.key});

  @override
  State<NormalUserPostList> createState() => _NormalUserPostListState();
}

class _NormalUserPostListState extends State<NormalUserPostList> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  late PagingController<int, Post> _pagingPostController1;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pagingPostController1 = PagingController<int, Post>(firstPageKey: 0);
    _pagingPostController1.addPageRequestListener((pageKey) {
      HomeBloc.fetchPosts(_pagingPostController1, 10, 0 ,null, null, null, null);
    });

  }

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    _pagingPostController1.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PostList(pagingController: _pagingPostController1, scrollController: ScrollController());
  }
}
