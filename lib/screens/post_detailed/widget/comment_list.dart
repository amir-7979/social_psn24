import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/repos/models/comment.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../widgets/new_page_progress_indicator.dart';
import '../post_detailed_bloc.dart';
import 'comment_item.dart';
import 'comment_shimmer.dart';

class CommentList extends StatefulWidget {
  final String postId;
  final ScrollController scrollController;
  final PagingController<int, Comment> pagingController;

  CommentList({
    required this.postId,
    required this.scrollController,
    required this.pagingController,
  });

  @override
  State<CommentList> createState() => _CommentListState();
}

class _CommentListState extends State<CommentList> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostDetailedBloc, PostDetailedState>(
      listener: (context, state) {
        print(state);
        if (state is CommentCreated) {
          setState(() {
            widget.pagingController.refresh();
          });
        }
      },
      child: PagedListView<int, Comment>(
        padding: EdgeInsets.zero,
        pagingController: widget.pagingController,
        scrollController: widget.scrollController,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        builderDelegate: PagedChildBuilderDelegate<Comment>(
          itemBuilder: (context, item, index) => CommentItem(item, widget.postId),
          firstPageProgressIndicatorBuilder: (context) =>
              SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: (context, index) => CommentItemShimmer(),
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
                      .translateNested("profileScreen", "noComment"),
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

    );
  }
}
