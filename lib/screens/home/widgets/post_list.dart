import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../repos/models/post.dart';
import '../home_bloc.dart';
import '../shimmer/shimmer_post_item.dart';
import 'post_item.dart';

class PostList extends StatelessWidget {
  final PagingController<int, Post> pagingController;

  const PostList({super.key, required this.pagingController});

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is PostRefreshSuccess) {
          pagingController.refresh();
        }
      },
      child: PagedListView<int, Post>(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 10),
        pagingController: pagingController,
        builderDelegate: PagedChildBuilderDelegate<Post>(
          itemBuilder: (context, item, index) => PostItem(item),
          firstPageProgressIndicatorBuilder: (context) => SizedBox(
            height: 400,
            child: ListView.builder(
              itemCount: 20,
              itemBuilder: (context, index) => ShimmerPostItem(),
            ),
          ),
          newPageProgressIndicatorBuilder: (context) => Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 10),
            child: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          newPageErrorIndicatorBuilder: (context) => Center(
            child: Text(
              AppLocalizations.of(context)!
                  .translateNested("profileScreen", "fetchError"),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          firstPageErrorIndicatorBuilder: (context) => Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
              child: Text(
                AppLocalizations.of(context)!
                    .translateNested("profileScreen", "fetchError"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
          noItemsFoundIndicatorBuilder: (context) => Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
              child: Text(
                AppLocalizations.of(context)!
                    .translateNested("profileScreen", "noPost"),
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
}
