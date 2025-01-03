import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../repos/models/content.dart';
import '../../../widgets/new_page_progress_indicator.dart';
import '../../profile_bloc.dart';
import 'content_item.dart';
import '../shimmer/shimmer_content_item.dart';

class Contents extends StatefulWidget {
  final PagingController<int, Content> pagingController;
   Contents({super.key, required this.pagingController});

  @override
  State<Contents> createState() => _ContentsState();
}

class _ContentsState extends State<Contents> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is PostDeleteSuccess) {
          setState(() {
            widget.pagingController.refresh();
          });
        }
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height,

        child: PagedGridView<int, Content>(
          showNewPageProgressIndicatorAsGridChild: false,
          padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
          pagingController: widget.pagingController,

                   cacheExtent: 300,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1.0,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
          ),
          builderDelegate: PagedChildBuilderDelegate<Content>(
            itemBuilder: (context, item, index) {
              return ContentItem(item);
            },
            firstPageProgressIndicatorBuilder: (context) => SizedBox(
              height: 400,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                ),
                itemCount: 20,
                itemBuilder: (context, index) => ShimmerContentItem(),
              ),
            ),
            newPageProgressIndicatorBuilder: (context) => NewPageProgressIndicator(),
            newPageErrorIndicatorBuilder: (context) => Center(
              child: Text(
                AppLocalizations.of(context)!
                    .translateNested("profileScreen", "fetchError"),
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            firstPageErrorIndicatorBuilder: (context) => Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: Text(
                  AppLocalizations.of(context)!
                      .translateNested("profileScreen", "fetchError"),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
            noItemsFoundIndicatorBuilder: (context) => Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0, 30, 0, 0),
                child: Text(
                  AppLocalizations.of(context)!
                      .translateNested("profileScreen", "noPost"),
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}