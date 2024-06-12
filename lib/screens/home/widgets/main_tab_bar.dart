import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/home/home_bloc.dart';
import 'package:social_psn/screens/home/widgets/post_list.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/post.dart';

class MainTabBar extends StatefulWidget {
  const MainTabBar({super.key});

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late PagingController<int, Post> _pagingPostController1;
  late PagingController<int, Post> _pagingPostController2;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pagingPostController1 = PagingController<int, Post>(firstPageKey: 0);
    _pagingPostController2 = PagingController<int, Post>(firstPageKey: 0);
    _pagingPostController1.addPageRequestListener((pageKey) {
      HomeBloc.fetchPosts(_pagingPostController1, 10, 0 ,null, 1, null, null, pageKey);
    });
    _pagingPostController2.addPageRequestListener((pageKey) {
      HomeBloc.fetchPosts(_pagingPostController2, 10, 1 ,null, 1, null, null, pageKey);
    });
  }

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    _pagingPostController1.dispose();
    _pagingPostController2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 60,
            child: TabBar(
              tabAlignment: TabAlignment.center,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: whiteColor),
              ),
              labelColor: whiteColor,
              dividerColor: Colors.transparent,
              labelStyle: iranYekanTheme.displaySmall!.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w700,
              ),
              controller: _tabController,
              labelPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              unselectedLabelStyle: iranYekanTheme.displaySmall!.copyWith(
                color: whiteColor,
                fontWeight: FontWeight.w700,
              ),
              indicatorPadding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
              tabs: [
                Tab(
                    text: AppLocalizations.of(context)!
                        .translateNested('profileScreen', 'normalContent'),),
                Tab(
                    text: AppLocalizations.of(context)!
                        .translateNested('profileScreen', 'expertContent')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                color: Theme.of(context).colorScheme.background,
                borderRadius: const BorderRadius.all(
                  Radius.circular(16),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                   PostList(key: UniqueKey(), pagingController: _pagingPostController1),
                   PostList(key: UniqueKey(), pagingController: _pagingPostController2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
