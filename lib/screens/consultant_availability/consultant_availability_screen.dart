import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../widgets/custom_snackbar.dart';
import 'consultant_availability_bloc.dart';
import 'widget/availability_tab.dart';

class ConsultantAvailabilityScreen extends StatelessWidget {
  final int id;
  final String? avatar;

  const ConsultantAvailabilityScreen({super.key, required this.id, required this.avatar});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConsultantAvailabilityBloc()
        ..add(FetchConsultantAvailabilityEvent(consultantId: id)),
      child: Builder(builder: (context) {
        return BlocConsumer<ConsultantAvailabilityBloc, ConsultantAvailabilityState>(
            listenWhen: (context, state) =>
                state is ConsultantAvailabilityError,
            listener: (context, state) {
              if (state is ConsultantAvailabilityError)
                ScaffoldMessenger.of(context).showSnackBar(
                    CustomSnackBar(content: state.message).build(context));
            },
            buildWhen: (context, state) =>
                state is ConsultantAvailabilityLoading ||
                state is ConsultantAvailabilityLoaded ||
                state is ConsultantAvailabilityError,
            builder: (context, state) {
              if (state is ConsultantAvailabilityLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ConsultantAvailabilityLoaded) {
                state.consultantAvailability!.consultant.infoUrl = avatar;
                return AvailabilityTab(consultantAvailability: state.consultantAvailability!,);
              } else if (state is ConsultantAvailabilityError) {
                return Center(child: Text(state.message));
              }
              return const Center(child: Text('خطا در دریافت اطلاعات'));
            });
      }),
    );
  }
}
