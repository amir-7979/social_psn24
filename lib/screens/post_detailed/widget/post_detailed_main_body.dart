import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/post_detailed/widget/post_detailed_body.dart';

import '../../../configs/setting/setting_bloc.dart';
import '../../../repos/models/comment.dart';
import '../../../repos/models/post.dart';
import '../../widgets/custom_snackbar.dart';
import '../post_detailed_bloc.dart';
import '../shimmer/shimmer_post_item.dart';
import 'comment_list.dart';

class PostDetailedMainBody extends StatefulWidget {
  final Post? post;
  final String postId;

  PostDetailedMainBody({this.post, required this.postId});

  @override
  State<PostDetailedMainBody> createState() => _PostDetailedMainBodyState();
}

class _PostDetailedMainBodyState extends State<PostDetailedMainBody> {
  bool? isUserLoggedIn;
  ScrollController _scrollController = ScrollController();
  PagingController<int, Comment> pagingController = PagingController<int, Comment>(firstPageKey: 0);
  late PostDetailedBloc postDetailedBloc;
  Widget lastWidget = Container(); // Initialize with a default widget

  @override
  void initState() {
    super.initState();
    isUserLoggedIn = context.read<SettingBloc>().state.isUserLoggedIn;
    postDetailedBloc = BlocProvider.of<PostDetailedBloc>(context);
    postDetailedBloc.add(IncreasePostViewEvent(postId: widget.postId));
    if (widget.post == null) {
      postDetailedBloc.add(FetchPostEvent(widget.postId));
    }
    pagingController.addPageRequestListener((pageKey) {
      _fetchComments(pageKey);
    });
  }

  void _fetchComments(int pageKey) {
    PostDetailedBloc.fetchComments(pagingController, widget.post?.id ?? '', 10, null);
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
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 16),
        children: [
          BlocBuilder<PostDetailedBloc, PostDetailedState>(
            builder: (context, state) {
              if (state is PostFetchSuccess) {
                lastWidget = PostDetailedBody(state.post, isUserLoggedIn!);
              } else if (state is PostLoading) {
                lastWidget = ShimmerPostItem();
              } else if (state is PostFetchFailure) {
                lastWidget = Container();
              }
              return lastWidget; // Return the last relevant widget
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
    );
  }
}