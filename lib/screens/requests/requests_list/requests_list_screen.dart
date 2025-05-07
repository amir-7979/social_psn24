import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:social_psn/screens/requests/requests_list/requests_list_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/liked.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/custom_snackbar.dart';
import 'widget/request_item.dart';
import 'widget/shimmer/request_item_shimmer.dart';

class RequestsListScreen extends StatefulWidget {
  const RequestsListScreen({super.key});

  @override
  State<RequestsListScreen> createState() => _RequestsListScreenState();
}

class _RequestsListScreenState extends State<RequestsListScreen> {


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => RequestsListBloc()..add(FetchRequests()),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.translateNested("drawer", 'drawerHand'),
                    style: iranYekanTheme.displayMedium!.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).pushNamed(AppRoutes.createRequest);
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        FaIcon(
                          FontAwesomeIcons.lightAdd,
                          color: Theme.of(context).primaryColor,
                          size: 15,
                        ),
                        SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!
                              .translateNested(
                              "profileScreen", "add"),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            color:
                            Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),

                      ],
                    ),
                  )
                ],
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
              SizedBox(height: 30),
              BlocConsumer<RequestsListBloc, RequestsListState>(
                  listenWhen: (context, state)=> state is RequestsError,
                  listener: (context, state){
                    if(state is RequestsError)
                    ScaffoldMessenger.of(context).showSnackBar(
                      CustomSnackBar(content: state.message).build(context)
                    );
                  },
                  builder: (context, state) {
                if(state is RequestsLoading){
                  return Expanded(
                    child: ListView(
                      children: [
                        RequestItemShimmer(),
                        RequestItemShimmer(),
                        RequestItemShimmer(),
                        RequestItemShimmer(),
                      ],
                    ),
                  );
                }else if(state is RequestsDataLoaded){
                  return Expanded(
                    child: state.requestsData.length == 0 ? Text(AppLocalizations.of(context)!.translateNested("consultation", 'noRequest'),
                      textAlign: TextAlign.center,

                      style: iranYekanTheme.headlineSmall!.copyWith(
                        color: Theme.of(context).hoverColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ) : ListView.builder(
                      itemCount: state.requestsData.length,
                      itemBuilder: (context, index) {
                        return RequestItem(state.requestsData[index]);
                      },
                    ),
                  );

                }else{
                  return Container();
                }
              }),
              /*Expanded(
                child: Center(
                  child: PagedGridView<int, Liked>(
                    showNewPageProgressIndicatorAsGridChild: false,
                    padding: const EdgeInsetsDirectional.only(bottom: 10),
                    pagingController: pagingController,
                    cacheExtent: 300,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                    ),
                    builderDelegate: PagedChildBuilderDelegate<Liked>(
                      itemBuilder: (context, item, index) => InterestItem(item),
                      firstPageProgressIndicatorBuilder: (context) => SizedBox(
                        height: 400,
                        child: GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            childAspectRatio: 1.0,
                            mainAxisSpacing: 5,
                            crossAxisSpacing: 5,
                          ),
                          itemCount: 20,
                          itemBuilder: (context, index) => ShimmerContentItem(),
                        ),
                      ),
                      newPageProgressIndicatorBuilder: (context) => NewPageProgressIndicator(),
                      newPageErrorIndicatorBuilder: (context) => Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translateNested("profileScreen", "fetchError"),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      firstPageErrorIndicatorBuilder: (context) => Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translateNested("profileScreen", "fetchError"),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Text(
                          AppLocalizations.of(context)!
                              .translateNested("profileScreen", "noInterest"),
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),*/
            ],
          ),
        );
    }
  ),
);

  }
}
