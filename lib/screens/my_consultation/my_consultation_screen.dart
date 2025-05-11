import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/screens/my_consultation/shimmer/consult_shimmer.dart';
import 'package:social_psn/screens/my_consultation/widget/consult_item.dart';

import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
import '../main/widgets/screen_builder.dart';
import '../requests/requests_list/widget/shimmer/request_item_shimmer.dart';
import '../widgets/custom_snackbar.dart';
import 'my_consultation_bloc.dart';

class MyConsultationScreen extends StatelessWidget {
  const MyConsultationScreen({super.key});

        @override
        Widget build(BuildContext context) {
      return BlocProvider(
        create: (context) => MyConsultationBloc()..add(FetchMyConsultationEvent()),
        child: Builder(
            builder: (context) {
              return Container(
                padding: const EdgeInsetsDirectional.fromSTEB(16, 16, 16, 0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Theme.of(context).colorScheme.background,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.translateNested("consultation", 'myConsultation'),
                      style: iranYekanTheme.displayMedium!.copyWith(
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
                    SizedBox(height: 16),

                    BlocConsumer<MyConsultationBloc, MyConsultationState>(
                        listenWhen: (context, state)=> state is MyConsultationError,
                        listener: (context, state){
                          if(state is MyConsultationError)
                            ScaffoldMessenger.of(context).showSnackBar(
                                CustomSnackBar(content: state.message).build(context)
                            );
                        },
                        builder: (context, state) {
                          if(state is MyConsultationLoading){
                            return Expanded(
                              child: ListView(
                                children: [
                                  ConsultationShimmer(),
                                  ConsultationShimmer(),
                                  ConsultationShimmer(),
                                  ConsultationShimmer(),
                                ],
                              ),
                            );
                          }else if(state is MyConsultationLoaded){
                            return Expanded(
                              child: state.consultations.length == 0 ? Text(AppLocalizations.of(context)!.translateNested("consultation", 'noRequest'),
                                textAlign: TextAlign.center,

                                style: iranYekanTheme.headlineSmall!.copyWith(
                                  color: Theme.of(context).hoverColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ) : ListView.builder(
                                itemCount: state.consultations.length,
                                itemBuilder: (context, index) {
                                  return ConsultationItem(state.consultations[index]);
                                },
                              ),
                            );

                          }else{
                            return Container();
                          }
                        }),

                  ],
                ),
              );
            }
        ),
      );

    }
  }
