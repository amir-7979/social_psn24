import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/comment.dart';
import '../../repos/models/post.dart';
import 'post_detailed_bloc.dart';
import 'widget/post_detailed_main_body.dart';

class PostDetailedScreen extends StatelessWidget {
  final Post? post;
  final String postId;

  PostDetailedScreen({this.post, required this.postId});

  @override
  build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.all(16),
      child: Container(
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.background,
        ),
        child: BlocProvider(
          create: (context) => PostDetailedBloc()..add(FetchPostEvent(postId)),
          child: PostDetailedMainBody(post: post, postId: postId),
        ),
      ),
    );
  }
}