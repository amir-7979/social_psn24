import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/screens/consultant_availability/widget/in_person.dart';
import 'package:social_psn/screens/widgets/custom_snackbar.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../configs/utilities.dart';
import '../../../repos/models/consultation_model/consultant_availability.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../consultant_availability_bloc.dart';

class AvailabilityTab extends StatefulWidget {
  final ConsultantAvailability consultantAvailability;

  AvailabilityTab({super.key, required this.consultantAvailability});

  @override
  State<AvailabilityTab> createState() => _AvailabilityTabState();
}

class _AvailabilityTabState extends State<AvailabilityTab>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  List<String> availableTabs = [];

  @override
  void initState() {
    super.initState();

    // Dynamically determine available tabs based on AvailabilityType
    if (widget.consultantAvailability.availabilities.inPerson.isNotEmpty)
      availableTabs.add('Chat');
    // if (widget.consultantAvailability.availabilities!.video != null)
    //   availableTabs.add('Video');
    // if (widget.consultantAvailability.availabilities!.audio != null)
    //   availableTabs.add('Audio');
    // if (widget.consultantAvailability.availabilities!.chat != null)
    //   availableTabs.add('Chat');

    _tabController = TabController(length: availableTabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 662,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 22,
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
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 10, 0),
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
                    SizedBox(height: 8),
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
                      onTap: (index) {
                        setState(() {
                          _tabController!.index = 0;
                        });
                      },
                      tabs: [
                        for (int i = 0;
                            i <
                                widget.consultantAvailability.consultant!
                                    .consultationTypes!.length;
                            i++)
                          Tab(
                            child: Text(
                              widget.consultantAvailability.consultant!
                                  .consultationTypes![i].description!,
                            ),
                          ),
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
                            for (int i = 0;
                                i <
                                    widget.consultantAvailability
                                        .consultant!.consultationTypes!.length;
                                i++)
                              if (widget.consultantAvailability
                                  .consultant!.consultationTypes![i].name == "in_person") InPerson(consultantAvailability: widget.consultantAvailability,)
                            else Container()

                              ]
                              ),

                        ),
                      ),

                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 15),
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Row(
                children: [
                  Container(
                    height: 65,
                    width: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 5,
                          blurRadius: 10,
                          offset: const Offset(
                              0, -5), // Adjust the offset as needed
                        ),
                      ],
                    ),
                    child: InkWell(
                      child: ClipOval(
                        child: (widget.consultantAvailability.consultant!
                                    .infoUrl !=
                                null)
                            ? FittedBox(
                                fit: BoxFit.cover,
                                child: ProfileCacheImage(widget
                                    .consultantAvailability
                                    .consultant!
                                    .infoUrl),
                              )
                            : SvgPicture.asset(
                                'assets/images/profile/profile2.svg'),
                      ),
                      overlayColor: WidgetStateProperty.all(Colors.transparent),
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () {
                        Navigator.of(context).pop();
                        navigatorKey.currentState
                          ?..pushNamed(AppRoutes.profile,
                              arguments:
                                  widget.consultantAvailability.consultant!.id);
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsetsDirectional.only(top: 25, start: 10),
                    child: Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.consultantAvailability.consultant?.name ??
                                "",
                            style: iranYekanTheme.headlineMedium!.copyWith(
                                color: whiteColor,
                                //fontSize: 14,
                                fontWeight: FontWeight.w500),
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              FaIcon(FontAwesomeIcons.lightGraduationCap,
                                  size: 12, color: whiteColor),
                              SizedBox(width: 2),
                              Text(
                                AppLocalizations.of(context)!.translateNested(
                                    "consultation", 'consultant'),
                                style: iranYekanTheme.titleLarge!.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: whiteColor,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
