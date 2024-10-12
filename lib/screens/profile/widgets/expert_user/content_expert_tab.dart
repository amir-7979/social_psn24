import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/themes.dart';
import '../../../../repos/models/content.dart';
import '../../profile_bloc.dart';
import '../lists_items/contents.dart';


class ContentExpertTab extends StatefulWidget {
   int? profileId;
  ContentExpertTab({this.profileId});

  @override
  State<ContentExpertTab> createState() => _ContentExpertTabState();
}

class _ContentExpertTabState extends State<ContentExpertTab> with SingleTickerProviderStateMixin{
  TabController? _tabController;
  final _pagingController0 = PagingController<int, Content>(firstPageKey: 0);
  final _pagingController1 = PagingController<int, Content>(firstPageKey: 0);


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _pagingController0.addPageRequestListener((pageKey) {
      ProfileBloc.fetchContent(_pagingController0, 0, 20, widget.profileId);
    });
    _pagingController1.addPageRequestListener((pageKey) {
      ProfileBloc.fetchContent(_pagingController1, 1, 20, widget.profileId);
    });
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
                        .translateNested('profileScreen', 'normalContent')),
                Tab(
                    text: AppLocalizations.of(context)!
                        .translateNested('profileScreen', 'expertContent')),
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
                  Contents(pagingController: _pagingController0),
                  Contents(pagingController: _pagingController1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }


}
