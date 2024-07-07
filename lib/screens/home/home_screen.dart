import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/home/widgets/post_screen.dart';
import '../../repos/models/post.dart';
import '../post_detailed/post_detailed_screen.dart';
import '../post_detailed/widget/comment_list.dart';
import 'home_bloc.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 0;
  Post? _currentPost;

  void changeIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => HomeBloc(),
  child: Builder(
    builder: (context) {
      return BlocListener<HomeBloc, HomeState>(
      listener: (context, state) {
        if (state is goToDetailedPostState) {
          _currentPost = state.post;
          changeIndex(1);
        }
      },
      child: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.background,
            ),
      //        child:  CommentList(postId: '664d086ed515d5ecc80094b6'),
            child: Stack(
              children: [
                Visibility(
                  visible: _currentIndex == 0,
                  child: PostScreen(), // Pass _changeIndex to PostDetailScreen
                  maintainState: false,
                ),

                Visibility(
                  visible: _currentIndex == 1,
                  child: _currentPost == null ? Container() : PostDetailedScreen(_currentPost!),
                  maintainState: false,
                ),
              ],
            ),
          ),
        ),
      );
    }
  ),
);
  }
}