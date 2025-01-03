import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/notification.dart';
import '../../widgets/custom_snackbar.dart';
import '../notification_bloc.dart';
import 'notification_item.dart';

class NotificationList extends StatefulWidget {
  @override
  State<NotificationList> createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  CustomSegmentedController<int> customSegmentedController =
      CustomSegmentedController(value: 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
      if (state is NotificationError) {
        ScaffoldMessenger.of(context).showSnackBar(
          CustomSnackBar(content: state.message).build(context),
        );
      }
    }, builder: (context, state) {
      return state is NotificationLoaded ? SizedBox(
        height: 662,
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  height: 30,
                  color: Colors.transparent, // Changed color to transparent
                ),
                Container(
                  height: 612,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 10, 10, 0),
                            child: GestureDetector(
                              child: SvgPicture.asset(
                                'assets/images/bottom_navbar/cross.svg',
                                width: 30,
                                height: 30,
                                fit: BoxFit.fill,
                              ),
                              onTap: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      TabBar(
                        indicator: UnderlineTabIndicator(
                          borderSide: BorderSide(width: 2.0, color: whiteColor),
                        ),
                        labelColor: whiteColor,
                        dividerColor: Colors.transparent,
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                        labelStyle: iranYekanTheme.headlineMedium!.copyWith(
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                        controller: _tabController,
                        labelPadding: const EdgeInsetsDirectional.all(0),
                        unselectedLabelStyle:
                            iranYekanTheme.headlineMedium!.copyWith(
                          color: whiteColor,
                          fontWeight: FontWeight.w700,
                        ),
                        onTap: (index) {
                          setState(() {
                            _tabController!.index = 0;
                          });
                        },
                        tabs: [
                          Tab(
                              text: AppLocalizations.of(context)!
                                  .translateNested(
                                      'notifications', 'myNotification')),
                          Tab(
                            child: Text(
                              AppLocalizations.of(context)!
                                  .translateNested('notifications', 'systemNotification'),
                              style: iranYekanTheme.headlineMedium!.copyWith(
                                color: Colors.grey, // Make Tab 2 gray
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsetsDirectional.fromSTEB(
                              10, 16, 10, 0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.transparent),
                            color: Theme.of(context).colorScheme.background,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(16),
                            ),
                          ),
                          child: TabBarView(
                            controller: _tabController,
                            children: [
                              mainTabBar(),
                              const Center(child: Text('Tab 2')),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 30),
              child: Align(
                alignment: AlignmentDirectional.topStart,
                child: Container(
                  height: 90,
                  width: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 0,
                        blurRadius: 10,
                        offset:
                            const Offset(0, -5), // Adjust the offset as needed
                      ),
                    ],
                  ),
                  child: SvgPicture.asset(
                    'assets/images/notification/notification.svg',
                    height: 90,
                    width: 90,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ) : const Center(child: CircularProgressIndicator());
    });
  }

  Widget mainTabBar() {
    return Column(
      children: [
        CustomSlidingSegmentedControl(
          innerPadding: const EdgeInsets.all(5),
          height: 40,
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
          padding: 8,
          children: {
            0: secondaryTabItem(
                AppLocalizations.of(context)!
                    .translateNested('notifications', 'all'),
                0),
            1: secondaryTabItem(
                AppLocalizations.of(context)!
                    .translateNested('bottomBar', 'content'),
                1),
            2: secondaryTabItem2(
                AppLocalizations.of(context)!
                    .translateNested('bottomBar', 'consultation'),
                2),
            3: secondaryTabItem2(
                AppLocalizations.of(context)!
                    .translateNested('bottomBar', 'charity'),
                3),
          },
          onTapSegment: (index) {
            if (index == 2 || index == 3) {
             return false;
            }
            return true;
          },
          onValueChanged: (value) {
            if (value == 0 || value == 1) {
              setState(() {
                customSegmentedController.value = value;
              });

            }
          },
        ),
        const SizedBox(
          height: 15,
        ),
        buildBody(customSegmentedController.value ?? 0)
        // Rest of Tab 1 content...
      ],
    );
  }

  Widget secondaryTabItem(String text, int index) {
    return SizedBox(
      width: 50,
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: customSegmentedController.value == index
                    ? Theme.of(context).colorScheme.tertiary
                    : Theme.of(context).colorScheme.shadow,
              ),
        ),
      ),
    );
  }

  Widget secondaryTabItem2(String text, int index) {
    return SizedBox(
      width: 50,
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget buildBody(int index) {
    switch (index) {
      case 0:
        return listItems(
            BlocProvider.of<NotificationBloc>(context).notifications);
      case 1:
        return listItems(
            BlocProvider.of<NotificationBloc>(context).notifications);
      default:
        return listItems([]);
    }
  }

  Widget listItems(List<MyNotification> notifications) {
    return Expanded(
      child: ListView.separated(
        separatorBuilder: (context, index) => Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpacity(0),
                Theme.of(context).colorScheme.surface.withOpacity(0.1),
                Theme.of(context).colorScheme.surface.withOpacity(0.2),
                Theme.of(context).colorScheme.surface.withOpacity(0.3),
                Theme.of(context).colorScheme.surface.withOpacity(0.4),
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        ),
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return NotificationItem(notifications[index]);
        },
      ),
    );
  }

  @override
  void dispose() {
    _tabController?.dispose();
    customSegmentedController.dispose();
    super.dispose();
  }
}
