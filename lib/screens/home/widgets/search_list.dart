import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/home/widgets/my_search_bar.dart';
import '../../../repos/models/post.dart';
import '../../post_search/post_search_screen.dart';
import '../home_bloc.dart';
import 'post_list.dart';

class SearchList extends StatefulWidget {
  final String? query;
  final String? tag;
  final int? type;
   SearchList({Key? key, this.query, this.tag, this.type}) : super(key: key);

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  late PagingController<int, Post> _pagingPostController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _pagingPostController = PagingController<int, Post>(firstPageKey: 0);
    _pagingPostController.addPageRequestListener((pageKey) {
      HomeBloc.fetchPosts(_pagingPostController, 10, widget.type, null, null, widget.tag, widget.query);
    });
  }

  @override
  void dispose() {
    _pagingPostController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: PostList(pagingController: _pagingPostController, scrollController: ScrollController()),
    );
  }
}
