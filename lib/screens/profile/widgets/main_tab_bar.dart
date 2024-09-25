import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/repos/models/comment.dart';
import 'package:social_psn/screens/profile/widgets/expert_user/comment_custom_tab_bar.dart';
import 'package:social_psn/screens/profile/widgets/expert_user/content_custom_tab_bar.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/setting_bloc.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/content.dart';
import '../profile_bloc.dart';
import 'comments.dart';
import 'contents.dart';

class MainTabBar extends StatefulWidget {
  const MainTabBar({super.key});

  @override
  State<MainTabBar> createState() => _MainTabBarState();
}

class _MainTabBarState extends State<MainTabBar>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  late PagingController<int, Content> _pagingContentController;
  late PagingController<int, Comment> _pagingCommentController;
  bool seeExpertPost = false;
  int? profileId;

  @override
  void initState() {
    super.initState();
     seeExpertPost =  context.read<SettingBloc>().state.seeExpertPost ?? false;

    _tabController = TabController(length: 2, vsync: this);
     _pagingContentController = PagingController<int, Content>(firstPageKey: 0);
     _pagingCommentController = PagingController<int, Comment>(firstPageKey: 0);

  }

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    _pagingContentController.dispose();
    _pagingCommentController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    profileId = ModalRoute.of(context)?.settings.arguments as int?;
    print("profileId: $profileId");

    _pagingContentController.addPageRequestListener((pageKey) {
      ProfileBloc.fetchContent(_pagingContentController, 0, 20, profileId);
    });
    _pagingCommentController.addPageRequestListener((pageKey) {
      ProfileBloc.fetchComment(_pagingCommentController, null, profileId, "my", 20);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height - 170,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.primary,
      ),
      child: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 60,
            child: TabBar(
              tabAlignment: TabAlignment.center,
              indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(width: 2.0, color: whiteColor),
              ),
              labelColor: whiteColor,
              dividerColor: Colors.transparent,
              labelStyle: iranYekanTheme.headlineMedium!.copyWith(
                color: whiteColor,
              ),
              controller: _tabController,
              labelPadding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              unselectedLabelStyle: iranYekanTheme.headlineMedium!.copyWith(
                color: whiteColor,
              ),
              indicatorPadding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
              tabs: [
                Tab(
                    text: AppLocalizations.of(context)!
                        .translateNested('bottomBar', 'content')),
                Tab(
                    text: AppLocalizations.of(context)!
                        .translateNested('profileScreen', 'comments')),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 16, 10, 0),
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
                  seeExpertPost? ContentCustomTabBar(profileId): Contents(pagingController: _pagingContentController),
                  seeExpertPost? CommentCustomTabBar(profileId): Comments(pagingController: _pagingCommentController),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
