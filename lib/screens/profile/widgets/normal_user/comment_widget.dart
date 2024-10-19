import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../repos/models/comment.dart';
import '../../profile_bloc.dart';
import '../lists_items/comments.dart';

class CommentWidget extends StatefulWidget {
  final int? profileId;
  CommentWidget({this.profileId, Key? key}) : super(key: key);

  @override
  State<CommentWidget> createState() => _CommentWidgetState();
}

class _CommentWidgetState extends State<CommentWidget> {
  final _pagingController0 = PagingController<int, Comment>(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _pagingController0.addPageRequestListener((pageKey) {
      ProfileBloc.fetchComment(_pagingController0, null, widget.profileId, "my", 20);
    });
  }
  @override

  dispose() {
    _pagingController0.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 16),
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.translateNested("profileScreen", 'comments'),
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                color: Theme.of(context).primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 8),
            Container(
              height: 1,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).primaryColor
                        .withOpacity(0),
                    Theme.of(context).primaryColor
                        .withOpacity(1),
                  ],
                  stops: const [0.0, 1.0],
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(child: Comments(pagingController: _pagingController0)),
          ],
        ),
      ),
    );
  }
}
