import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../../../configs/localization/app_localizations.dart';
import '../../../../repos/models/content.dart';
import '../../profile_bloc.dart';
import '../contents.dart';

class ContentCustomTabBar extends StatefulWidget {
  @override
  State<ContentCustomTabBar> createState() => _ContentCustomTabBarState();
}

class _ContentCustomTabBarState extends State<ContentCustomTabBar> {
  CustomSegmentedController<int> customSegmentedController =
  CustomSegmentedController(value: 0);
  final _pagingController0 = PagingController<int, Content>(firstPageKey: 0);
  final _pagingController1 = PagingController<int, Content>(firstPageKey: 0);

  @override
  void initState() {
    _pagingController0.addPageRequestListener((pageKey) {
      ProfileBloc.fetchContent(_pagingController0, 0, 20, null);
    });
    _pagingController1.addPageRequestListener((pageKey) {
      ProfileBloc.fetchContent(_pagingController1, 1, 20, null);
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(end: 3),
      child: Column(
        children: [
          CustomSlidingSegmentedControl(
            innerPadding: const EdgeInsets.all(5),
            isStretch: true,
            controller: customSegmentedController,
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
              0: customTabItem(
                  AppLocalizations.of(context)!
                      .translateNested('profileScreen', 'normalContent'),
                  0),
              1: customTabItem(
                  AppLocalizations.of(context)!
                      .translateNested('profileScreen', 'expertContent'),
                  1),
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
                color: customSegmentedController.value == index
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.shadow,
                fontWeight: FontWeight.w500,
              ),
        ),
      ),
    );
  }

  Widget customTabBody(int index) {
    switch (index) {
      case 0:
        return Contents(key: UniqueKey(), pagingController: _pagingController0,);
      case 1:
        return Contents(key: UniqueKey(), pagingController: _pagingController1,);
      default:
        return Container();
    }
  }

  @override
  void dispose() {
    _pagingController0.dispose();
    _pagingController1.dispose();
    customSegmentedController.dispose();
    super.dispose();
  }
}
