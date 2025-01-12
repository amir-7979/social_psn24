import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/repos/models/reply.dart';
import 'package:social_psn/screens/post_detailed/widget/post_detailed_body.dart';

import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/comment.dart';
import '../../../repos/models/post.dart';
import '../../widgets/custom_snackbar.dart';
import '../post_detailed_bloc.dart';
import '../shimmer/shimmer_post_item.dart';
import 'comment_list.dart';

class PostDetailedMainBody extends StatefulWidget {
  Post? post;
  final String postId;
  final int? index;
   String? commentId;

  PostDetailedMainBody({this.post, required this.postId, this.index, this.commentId});

  @override
  State<PostDetailedMainBody> createState() => _PostDetailedMainBodyState();
}

class _PostDetailedMainBodyState extends State<PostDetailedMainBody> {
  bool? isUserLoggedIn;
  ScrollController _scrollController = ScrollController();
  PagingController<int, Comment> pagingController =
  PagingController<int, Comment>(firstPageKey: 0);
  late PostDetailedBloc postDetailedBloc;
  Widget lastWidget = Container();
  bool isCommentFound = false;

  @override
  void initState() {
    super.initState();
    isUserLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn;
    postDetailedBloc = BlocProvider.of<PostDetailedBloc>(context);
    postDetailedBloc.add(IncreasePostViewEvent(postId: widget.postId));
    if (widget.post == null) {
      postDetailedBloc.add(FetchPostEvent(widget.postId));
    } else {
      widget.post!.viewCount = widget.post!.viewCount! + 1;
      lastWidget = widget.post != null ? PostDetailedBody(widget.post!, isUserLoggedIn!) : Container();
    }
    pagingController.addPageRequestListener((pageKey) async {
      await PostDetailedBloc.fetchComments(pagingController, widget.postId, 10);
      if (widget.commentId != null) {
        await _checkForComment(widget.commentId);
      }
    });
  }

  Future<void> _checkForComment(String? commentId) async {
    if (commentId == null || pagingController.itemList == null || pagingController.itemList!.isEmpty) return;

    final comments = pagingController.itemList!;
    for (int i = 0; i < comments.length; i++) {
      if (comments[i].id == commentId) {
        _scrollToComment(i);
        return;
      }
      final replyIndex = _searchInReplies(comments[i].replies??[], commentId);
      if (replyIndex != null) {
        _scrollToComment(i, replyIndex: replyIndex);
        return;
      }
    }

    // If not found, load the next page if available
    if (!isCommentFound && pagingController.nextPageKey != null) {
      pagingController.notifyPageRequestListeners(pagingController.nextPageKey!);
    }
  }

  int? _searchInReplies(List<Reply> replies, String commentId) {
    if (replies.isEmpty) return null;
    for (int j = 0; j < replies.length; j++) {
      if (replies[j].id == commentId) {
        return j;
      }
    }
    return null;
  }

  void _scrollToComment(int commentIndex, {int? replyIndex}) {
    isCommentFound = true;
    widget.commentId = null; // Clear the commentId to stop further searches

    // Assume each comment and reply has a height of 100
    const double itemHeight = 100.0;

    // Calculate the position by summing the heights of all items before the target
    double position = 0;

    for (int i = 0; i < commentIndex; i++) {
      // Add the height of the comment itself
      position += itemHeight;

      // Add the height of all replies to the comment
      position += (pagingController.itemList![i].replies?.length ?? 0) * itemHeight;
    }

    // Add the height of the target comment
    position += itemHeight;

    // If targeting a specific reply, add its position within the replies
    if (replyIndex != null) {
      position += (replyIndex + 1) * itemHeight;
    }

    // Scroll to the calculated position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        position,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }


  Future<void> _refresh() async {
    postDetailedBloc.add(FetchPostEvent(widget.postId));
    pagingController.refresh();
    await Future.delayed(Duration.zero);
  }

  dispose() {
    super.dispose();
    postDetailedBloc.close();
    pagingController.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostDetailedBloc, PostDetailedState>(
      listener: (context, state) {
        if (state is PostFetchFailure) {
          CustomSnackBar(
            function: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            content: state.message,
            backgroundColor: Theme.of(context).colorScheme.error,
          ).build(context);
        }
      },
      child: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView(
          padding: EdgeInsetsDirectional.symmetric(horizontal: 10),
          controller: _scrollController, // Attach the scroll controller
          children: [
            BlocBuilder<PostDetailedBloc, PostDetailedState>(
              builder: (context, state) {
                if (state is PostFetchSuccess) {
                  lastWidget = PostDetailedBody(state.post, isUserLoggedIn!);
                  widget.post = state.post;
                } else if (state is PostLoading) {
                  lastWidget = ShimmerPostItem();
                } else if (state is PostFetchFailure) {
                  lastWidget = Container();
                }
                return lastWidget;
              },
            ),
            CommentList(
              pagingController: pagingController,
              scrollController: _scrollController,
              postId: widget.postId,
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
