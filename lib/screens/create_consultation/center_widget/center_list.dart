import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/create_consultation/center_widget/center_item.dart';
import 'package:social_psn/screens/create_consultation/center_widget/shimmer/center_item_shimmer.dart';

import '../create_consultation_bloc.dart';

class CenterList extends StatefulWidget {
  const CenterList({super.key});

  @override
  State<CenterList> createState() => _CenterListState();
}

class _CenterListState extends State<CenterList> {

  initState() {
    super.initState();
    BlocProvider.of<CreateConsultationBloc>(context).add(GetCounselingCentersEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateConsultationBloc, CreateConsultationState>(
      buildWhen: (_, current) {
        return current is FetchCounselingCentersSuccess ||
            current is FetchCounselingCentersFailure ||
            current is FetchCounselingCentersLoading;
      },
      builder: (context, state) {
        if (state is FetchCounselingCentersSuccess) {
          return ListView.builder(
            itemCount: state.centers.length,
            itemBuilder: (context, index) {
              return CenterItem(state.centers[index]);
            },
          );
        } else if (state is FetchCounselingCentersFailure) {
          return Center(child: Text('خطا در دریافت اطلاعات'));
        } else {
          return ListView(
            children: [
              CenterItemShimmer(),
              CenterItemShimmer(),
              CenterItemShimmer(),
              CenterItemShimmer(),
              CenterItemShimmer(),
            ],
          );
        }
      },
    );
  }
}

