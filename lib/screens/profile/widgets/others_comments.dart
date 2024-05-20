import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/repos/models/comment.dart';

import '../../../configs/localization/app_localizations.dart';
import 'comment_item.dart';
import 'others_comment_item.dart';
import 'shimmer/shimmer_comment_item.dart';
import 'shimmer/shimmer_content_item.dart';

class OthersComments extends StatelessWidget {
  final PagingController<int, Comment> pagingController;
  OthersComments({super.key, required this.pagingController,});

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, Comment>(
      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 10),
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<Comment>(
        itemBuilder: (context, item, index) => OthersCommentItem(item),
        firstPageProgressIndicatorBuilder: (context) => SizedBox(
          height: 400,
          child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => ShimmerCommentItem(),
          ),
        ),
        newPageProgressIndicatorBuilder: (context) => Center(
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
        firstPageErrorIndicatorBuilder: (context) => Center(
          child: Text(
            AppLocalizations.of(context)!
                .translateNested("profileScreen", "fetchError"),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
        noItemsFoundIndicatorBuilder: (context) => Center(
          child: Text(
            AppLocalizations.of(context)!
                .translateNested("profileScreen", "noComment"),
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }
}
