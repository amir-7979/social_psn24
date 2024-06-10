import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configs/setting/setting_bloc.dart';
import '../../../widgets/shimmer.dart';

class ShimmerEditNormalUser extends StatelessWidget {
  const ShimmerEditNormalUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsetsDirectional.only(top: 16.0),
      child: Container(
        width: MediaQuery.of(context).size.height,
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Theme
              .of(context)
              .colorScheme
              .background,
        ),
        child: ListView(
        children: [
          const SizedBox(height: 16),
          Center(child: shimmerCircular(context, size: 150)),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 32),
              shimmerContainer(context,
                  width: 200, height: 25, radius: 16),
              const SizedBox(height: 8),
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme
                          .of(context)
                          .primaryColor
                          .withOpacity(0),
                      Theme
                          .of(context)
                          .primaryColor
                          .withOpacity(1),
                    ],
                    stops: const [0.0, 1.0],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Column(
            children: [
              Padding(
                padding:
                const EdgeInsetsDirectional.only(bottom: 16.0),
                child: shimmerContainer(context, width: double.infinity, height: 50, radius: 8),
              ),
              Padding(
                padding:
                const EdgeInsetsDirectional.only(bottom: 16.0),
                child: shimmerContainer(context, width: double.infinity, height: 50, radius: 8),
              ),
              Padding(
                padding:
                const EdgeInsetsDirectional.only(bottom: 16.0),
                child: shimmerContainer(context, width: double.infinity, height: 50, radius: 8),
              ),
              BlocProvider.of<SettingBloc>(context).state.seeExpertPost ?? false ? Column(
                children: [
                  Padding(
                    padding:
                    const EdgeInsetsDirectional.only(bottom: 16.0),
                    child: shimmerContainer(context, width: double.infinity, height: 50, radius: 8),
                  ),
                  Padding(
                    padding:
                    const EdgeInsetsDirectional.only(bottom: 16.0),
                    child: shimmerContainer(context, width: double.infinity, height: 50, radius: 8),
                  ),
                ],
              ) : const SizedBox(),

      ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsetsDirectional.only(bottom: 16.0),
                  child: shimmerContainer(context, height: 45, radius: 8),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Padding(
                  padding:
                  const EdgeInsetsDirectional.only(bottom: 16.0),
                  child: shimmerContainer(context, height: 45, radius: 8),
                ),
              ),                ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    ),);
  }
}
