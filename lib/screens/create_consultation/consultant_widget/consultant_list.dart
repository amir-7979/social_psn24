import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../my_consultation/shimmer/consult_shimmer.dart';
import '../create_consultation_bloc.dart';
import 'consultant_item.dart';
import 'shimmer/consult_item_shimmer.dart';

class ConsultantList extends StatefulWidget {
  const ConsultantList({super.key});

  @override
  State<ConsultantList> createState() => _ConsultantListState();
}

class _ConsultantListState extends State<ConsultantList> {

  initState() {
    super.initState();
    BlocProvider.of<CreateConsultationBloc>(context).add(GetConsultantsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateConsultationBloc, CreateConsultationState>(
      buildWhen: (_, current) {
        return current is FetchConsultantsSuccess ||
            current is FetchConsultantsFailure ||
            current is FetchConsultantsLoading;
      },
      builder: (context, state) {
        if (state is FetchConsultantsSuccess) {
          return ListView.builder(
            itemCount: state.consultants.length,
            itemBuilder: (context, index) {
              return ConsultantItem(state.consultants[index]);
            },
          );
        } else if (state is FetchConsultantsFailure) {
          return Center(child: Text('خطا در دریافت اطلاعات'));
        } else {
          return ListView(
            children: [
              ConsultItemShimmer(),
              ConsultItemShimmer(),
              ConsultItemShimmer(),
              ConsultItemShimmer(),

            ],
          );
        }
      },
    );
  }
}
