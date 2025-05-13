import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/setting/themes.dart';
import '../../../../repos/models/content.dart';
import 'center_widget/center_list.dart';
import 'consultant_widget/consultant_list.dart';
import 'create_consultation_bloc.dart';


class CreateConsultationScreen extends StatefulWidget {

  @override
  State<CreateConsultationScreen> createState() => _CreateConsultationScreenState();
}

class _CreateConsultationScreenState extends State<CreateConsultationScreen> with SingleTickerProviderStateMixin{
  TabController? _tabController;


  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    if (_tabController != null) _tabController!.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => CreateConsultationBloc(),
  child: Builder(
    builder: (context) {
      return DefaultTabController(
          length: 2,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Theme.of(context).colorScheme.primary,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: TabBar(
                    tabAlignment: TabAlignment.center,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2.0, color: whiteColor),
                    ),
                    labelColor: whiteColor,
                    dividerColor: Colors.transparent,
                    labelStyle: iranYekanTheme.headlineMedium!.copyWith(color: whiteColor),
                    unselectedLabelStyle: iranYekanTheme.headlineMedium!.copyWith(color: whiteColor),
                    indicatorPadding: const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 10),
                    tabs: [
                      Tab(
                        text: AppLocalizations.of(context)!
                            .translateNested('consultation', 'consult_list'),
                      ),

                      Tab(
                        text: AppLocalizations.of(context)!
                            .translateNested('consultation', 'consultation_centers'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: Container(
                    padding: const EdgeInsetsDirectional.fromSTEB(10, 16, 10, 0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.transparent),
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.all(Radius.circular(16)),
                    ),
                    child: TabBarView(
                      children: [
                        ConsultantList(),

                        CenterList(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
    }
  ),
);
  }
}
