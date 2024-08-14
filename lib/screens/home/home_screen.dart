import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/home/widgets/normal_user_post_list.dart';
import 'package:social_psn/screens/home/widgets/search_bar.dart';
import 'package:social_psn/screens/home/widgets/search_list.dart';
import '../../configs/setting/setting_bloc.dart';
import '../../repos/models/post.dart';
import '../post_search/post_search_screen.dart';
import '../widgets/appbar_widget.dart';
import 'home_bloc.dart';
import 'widgets/main_tab_bar.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with AutomaticKeepAliveClientMixin {
  late bool seeExpertPost;
  PagingController<int, Post>? _pagingPostController1 =
      PagingController<int, Post>(firstPageKey: 0);

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _pagingPostController1!.addPageRequestListener((pageKey) {
        HomeBloc.fetchPosts(
            _pagingPostController1!, 10, 0, null, null, null, null);
      });
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeBloc>().resetState();
    });
  }
  void dispose() {
    if (_pagingPostController1 != null) _pagingPostController1!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    seeExpertPost = context.read<SettingBloc>().state.seeExpertPost;
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
    return Scaffold(
      appBar: state is SearchParams ? AppBar(
        title: MySearchBar(state.query),
      ) : buildAppBar(context, (){
        showDialog(
          context: context,
          barrierDismissible: true,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: EdgeInsets.zero,
              elevation: 0,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              insetAnimationDuration: Duration.zero,
              child: PostSearchScreen(),
            );
          },
        );
      }),
      body: Padding(
          padding: const EdgeInsetsDirectional.all(16),
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.background,
            ),
            child:  state is SearchParams ? SearchList(query: state.query, tag: state.tag, type: state.type) : Container(
                child: seeExpertPost
                    ? MainTabBar()
                    : NormalUserPostList()),
          )),
    );
  },
);
  }
}
