import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/profile/widgets/comments.dart';
import '../../../../configs/localization/app_localizations.dart';
import '../../../../repos/models/comment.dart';
import '../../profile_bloc.dart';
import '../others_comments.dart';

class CommentCustomTabBar extends StatefulWidget {
  const CommentCustomTabBar({super.key});

  @override
  State<CommentCustomTabBar> createState() => _CommentCustomTabBarState();
}

class _CommentCustomTabBarState extends State<CommentCustomTabBar> {
  CustomSegmentedController<int> customSegmentedController =
  CustomSegmentedController(value: 0);
  final _pagingController0 = PagingController<int, Comment>(firstPageKey: 0);
  final _pagingController1 = PagingController<int, Comment>(firstPageKey: 0);

  @override
  void initState() {
    _pagingController0.addPageRequestListener((pageKey) {
      ProfileBloc.fetchComment(_pagingController0, null, null, "my",0, 20);
    });
    _pagingController1.addPageRequestListener((pageKey) {
      ProfileBloc.fetchComment(_pagingController1, null, null, "my",0, 20);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 3),
      child: Column(
        children: [
          CustomSlidingSegmentedControl(
            innerPadding: const EdgeInsets.all(5),
            controller: customSegmentedController,
            isStretch: true,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Theme.of(context).colorScheme.surface,
              ),
            ),
            thumbDecoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary.withAlpha(50),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                  color: Theme.of(context).colorScheme.tertiary, width: 1),
            ),
            children: {
              0: customTabItem(AppLocalizations.of(context)!.translateNested('profileScreen', 'userComments'), 0),
              1: customTabItem(AppLocalizations.of(context)!.translateNested('profileScreen', 'othersComments'), 1),
            },
            onValueChanged: (value) {
              setState(() {
                customSegmentedController.value = value;
              });
            },
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(child: customTabBody(customSegmentedController.value ?? 0))
          // Rest of Tab 1 content...
        ],
      ),
    );
  }

  Widget customTabItem(String text, int index) {
    return SizedBox(

      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.w500,
            color: customSegmentedController.value == index
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.shadow,
          ),
        ),
      ),
    );
  }

  Widget customTabBody(int index) {
    switch (index) {
      case 0:
        return Comments(key: UniqueKey(), pagingController: _pagingController0);
      case 1:
        return Comments(key: UniqueKey(), pagingController: _pagingController1);
      default:
        return Container();
    }
  }

  @override
  void dispose() {
    customSegmentedController.dispose();
    super.dispose();
  }
}
