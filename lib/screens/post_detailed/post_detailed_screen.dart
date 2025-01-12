import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/post/post_bloc.dart';

import '../../repos/models/post.dart';
import 'post_detailed_bloc.dart';
import 'widget/post_detailed_main_body.dart';

class PostDetailedScreen extends StatefulWidget {
  final Post? post;
  final String postId;
  final PostBloc? postBloc;
  final String? commentId;

  PostDetailedScreen({this.post, required this.postId,  this.postBloc, this.commentId});

  @override
  State<PostDetailedScreen> createState() => _PostDetailedScreenState();
}

class _PostDetailedScreenState extends State<PostDetailedScreen> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: BlocProvider(
        create: (context) => PostDetailedBloc(postBloc: widget.postBloc),
        child: PostDetailedMainBody(post: widget.post, postId: widget.postId, commentId: widget.commentId),
      ),
    );
  }
}