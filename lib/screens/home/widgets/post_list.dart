import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:inview_notifier_list/inview_notifier_list.dart';
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

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    print('PostList build');
    return BlocProvider(
      create: (context) => HomeBloc(),
      child: BlocListener<HomeBloc, HomeState>(
        listener: (context, state) {
          if (state is PostRefreshSuccess) {
            widget.pagingController.refresh();
          }
        },
        child: PagedListView<int, Post>(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 10, 10),
          scrollController: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          pagingController: widget.pagingController,
          builderDelegate: PagedChildBuilderDelegate<Post>(
            itemBuilder: (context, item, index) => PostItem(item),
            firstPageProgressIndicatorBuilder: (context) =>
                SizedBox(
                  height: 400,
                  child: ListView.builder(
                    itemCount: 20,
                    itemBuilder: (context, index) => ShimmerPostItem(),
                  ),
                ),
            newPageProgressIndicatorBuilder: (context) =>
                NewPageProgressIndicator(),
            newPageErrorIndicatorBuilder: (context) =>
                Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translateNested("profileScreen", "fetchError"),
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                ),
            firstPageErrorIndicatorBuilder: (context) =>
                Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translateNested("profileScreen", "fetchError"),
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                ),
            noItemsFoundIndicatorBuilder: (context) =>
                Center(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translateNested("profileScreen", "noInterest"),
                    style: Theme
                        .of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      color: Theme
                          .of(context)
                          .primaryColor,
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }

}
