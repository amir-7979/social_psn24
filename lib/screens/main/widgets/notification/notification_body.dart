import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/themes.dart';
import 'notification_item.dart';

class NotificationBody extends StatefulWidget {
  @override
  State<NotificationBody> createState() => _NotificationBodyState();
}

class _NotificationBodyState extends State<NotificationBody>
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
    return SizedBox(
      width: 330,
      height: 612,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 30,
                color: Colors.transparent, // Changed color to transparent
              ),
              Container(
                width: 330,
                height: 562,
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
                      padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
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
                      tabs: [
                        Tab(
                            text: AppLocalizations.of(context)!.translateNested(
                                'notifications', 'myNotification')),
                        Tab(
                            text: AppLocalizations.of(context)!.translateNested(
                                'notifications', 'systemNotification')),
                      ],
                    ),
                    SizedBox(height: 12),
                    Expanded(
                      child: Container(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 16, 10, 0),
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
                      offset: const Offset(0, -5), // Adjust the offset as needed
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
    );
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
          children: {
            0: secondaryTabItem(
                AppLocalizations.of(context)!
                    .translateNested('notifications', 'all'),
                0),
            1: secondaryTabItem(
                AppLocalizations.of(context)!
                    .translateNested('notifications', 'content'),
                1),
            2: secondaryTabItem(
                AppLocalizations.of(context)!
                    .translateNested('bottomBar', 'consultation'),
                2),
            3: secondaryTabItem(
                AppLocalizations.of(context)!
                    .translateNested('bottomBar', 'charity'),
                3),
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

  Widget buildBody(int index) {
    switch (index) {
      case 0:
        return listItems();
      case 1:
        return Container();
      default:
        return listItems();
    }
  }

  Widget listItems() {
    return Expanded(
      child: ListView(
        children: [
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Alert.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Danger.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=image.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Sound.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Success.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Text.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Video.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Alert.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Danger.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=image.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Sound.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Success.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Text.png'),
          NotificationItem('assets/images/notification/user.png',
              'assets/images/notification/Type=Video.png'),
        ],
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
