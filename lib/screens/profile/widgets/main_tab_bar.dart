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



  final _pagingContentController = PagingController<int, Content>(firstPageKey: 0);
  final _pagingCommentController = PagingController<int, Comment>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pagingContentController.addPageRequestListener((pageKey) {
      ProfileBloc.fetchContent(_pagingContentController, 0, 20, null);
    });
    _pagingCommentController.addPageRequestListener((pageKey) {
      ProfileBloc.fetchComment(_pagingCommentController, null, null, "my",0, 20);
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
          TabBar(
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(width: 2.0, color: whiteColor),
            ),
            labelColor: whiteColor,
            dividerColor: Colors.transparent,
            padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
            labelStyle: iranYekanTheme.titleLarge!.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.w700,
            ),
            controller: _tabController,
            labelPadding: const EdgeInsetsDirectional.all(0),
            unselectedLabelStyle: iranYekanTheme.titleLarge!.copyWith(
              color: whiteColor,
              fontWeight: FontWeight.w700,
            ),
            tabs: [
              Tab(
                  text: AppLocalizations.of(context)!
                      .translateNested('notifications', 'content')),
              Tab(
                  text: AppLocalizations.of(context)!
                      .translateNested('profileScreen', 'comments')),
            ],
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
                  BlocBuilder<SettingBloc, SettingState>(
                    builder: (context, state) {
                      if(context.read<SettingBloc>().state.isExpert ?? false) {
                        return ContentCustomTabBar();
                      } else {
                        return Contents(pagingController: _pagingContentController);
                      }
                    },
                  ),

                  BlocBuilder<SettingBloc, SettingState>(
                    builder: (context, state) {
                      if(context.read<SettingBloc>().state.isExpert ?? false) {
                        return CommentCustomTabBar();
                      } else {
                        return Comments(pagingController: _pagingCommentController);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
