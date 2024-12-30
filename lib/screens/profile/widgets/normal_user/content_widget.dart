import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../repos/models/content.dart';
import '../../profile_bloc.dart';
import '../lists_items/contents.dart';

class ContentWidget extends StatefulWidget {
  final int? profileId;
  ContentWidget({this.profileId, Key? key}) : super(key: key);

  @override
  State<ContentWidget> createState() => _ContentWidgetState();
}

class _ContentWidgetState extends State<ContentWidget> {
  final _pagingController0 = PagingController<int, Content>(firstPageKey: 0);
  @override
  void initState() {
    super.initState();
    _pagingController0.addPageRequestListener((pageKey) {
      ProfileBloc.fetchContent(_pagingController0, 0, 20, widget.profileId);
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
            Text(AppLocalizations.of(context)!.translateNested("bottomBar", 'content'),
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
            //Expanded(child: Contents(pagingController: _pagingController0),),
          ],
        ),
      ),
    );
  }
}