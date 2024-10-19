import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/themes.dart';
import '../../../../repos/models/comment.dart';
import '../../profile_bloc.dart';
import '../lists_items/comments.dart';

class CommentExpertTab extends StatefulWidget {
  int? profileId;

  CommentExpertTab(this.profileId);

  @override
  State<CommentExpertTab> createState() => _CommentExpertTabState();
}

class _CommentExpertTabState extends State<CommentExpertTab> with SingleTickerProviderStateMixin {
  CustomSegmentedController<int> customSegmentedController = CustomSegmentedController(value: 0);
  TabController? _tabController;

  final _pagingController0 = PagingController<int, Comment>(firstPageKey: 0);
  final _pagingController1 = PagingController<int, Comment>(firstPageKey: 0);

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    _pagingController0.addPageRequestListener((pageKey) {
      ProfileBloc.fetchComment(_pagingController0, null, widget.profileId, "my", 20);
    });
    _pagingController1.addPageRequestListener((pageKey) {
      ProfileBloc.fetchComment(_pagingController1, null, widget.profileId, "other", 20);
    });
    super.initState();
  }





  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    _pagingController0.dispose();
    _pagingController1.dispose();
    super.dispose();
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
                        .translateNested('profileScreen', widget.profileId == null ? 'myComments' : 'userComments')),
                Tab(
                    text: AppLocalizations.of(context)!
                        .translateNested('profileScreen', widget.profileId == null ? 'othersComments' : 'othersUserComments')),
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
                  Comments(pagingController: _pagingController0),
                  Comments(pagingController: _pagingController1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

}
