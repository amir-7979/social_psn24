import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/profile/widgets/interest_item.dart';
import 'package:social_psn/screens/profile/widgets/shimmer/shimmer_content_item.dart';
import '../../../configs/localization/app_localizations.dart';
import '../../../repos/models/liked.dart';
import '../profile_bloc.dart';

class Interests extends StatefulWidget {

  @override
  State<Interests> createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  final _pagingController = PagingController<int, Liked>(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener((pageKey) {
      ProfileBloc.fetchLikedContent(_pagingController, 0, 20, null);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(top: 16),
      child: Container(
        padding: const EdgeInsetsDirectional.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme.of(context).colorScheme.background,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text(AppLocalizations.of(context)!.translateNested("profileScreen", 'interest'),
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
            Expanded(
              child: PagedGridView<int, Liked>(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 10),
                pagingController: _pagingController,
                cacheExtent: 300,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1.0,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                builderDelegate: PagedChildBuilderDelegate<Liked>(
                  itemBuilder: (context, item, index) => InterestItem(item),
                  firstPageProgressIndicatorBuilder: (context) => SizedBox(
                    height: 400,
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1.0,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: 20,
                      itemBuilder: (context, index) => ShimmerContentItem(),
                    ),
                  ),
                  newPageProgressIndicatorBuilder: (context) => Center(
                    child: Container(
                      child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  newPageErrorIndicatorBuilder: (context) => Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("profileScreen", "fetchError"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  firstPageErrorIndicatorBuilder: (context) => Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("profileScreen", "fetchError"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                  noItemsFoundIndicatorBuilder: (context) => Center(
                    child: Text(
                      AppLocalizations.of(context)!
                          .translateNested("profileScreen", "noInterest"),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
