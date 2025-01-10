import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../repos/models/post.dart';
import '../../post/post_item.dart';
import '../../widgets/new_page_progress_indicator.dart';
import '../home_bloc.dart';
import '../shimmer/shimmer_post_item.dart';

class PostList extends StatefulWidget {
  final PagingController<int, Post> pagingController;
  final ScrollController scrollController;

  const PostList({super.key, required this.pagingController, required this.scrollController});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> with AutomaticKeepAliveClientMixin {
  late ScrollController _customScrollController;

  @override
  void initState() {
    super.initState();
    _customScrollController = ScrollController();
  }

  @override
  void dispose() {
    _customScrollController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is PostRefreshSuccess) {
          widget.pagingController.refresh();
        }
      },
      child: RefreshIndicator(
        color: Theme.of(context).primaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        onRefresh: _onRefresh,
        child: PagedListView<int, Post>(
          padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
          scrollController: _customScrollController,
          physics: const CustomScrollPhysics(), // Custom scroll physics for better control
          pagingController: widget.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, item, index) => RepaintBoundary(
              child: PostItem(item),
            ),
            firstPageProgressIndicatorBuilder: (context) => SizedBox(
              height: 400,
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => RepaintBoundary(
                  child: ShimmerPostItem(),
                ),
              ),
            ),
            newPageProgressIndicatorBuilder: (context) => NewPageProgressIndicator(),
            newPageErrorIndicatorBuilder: (context) => Center(
              child: Text(
                AppLocalizations.of(context)!.translateNested("profileScreen", "fetchError"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => Center(
              child: Text(
                AppLocalizations.of(context)!.translateNested("profileScreen", "fetchError"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => Center(
              child: Text(
                AppLocalizations.of(context)!.translateNested("profileScreen", "noPost"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    widget.pagingController.refresh();
  }

  void scrollToTop() {
    _customScrollController.animateTo(
      0.0,
      duration: const Duration(seconds: 1), // Adjust duration to control speed
      curve: Curves.easeInOut, // Smooth animation curve
    );
  }
}

class CustomScrollPhysics extends ScrollPhysics {
  const CustomScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  CustomScrollPhysics applyTo(ScrollPhysics? ancestor) {
    return CustomScrollPhysics(parent: buildParent(ancestor));
  }

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    return offset * 0.8;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) {
    return super.applyBoundaryConditions(position, value);
  }
}
