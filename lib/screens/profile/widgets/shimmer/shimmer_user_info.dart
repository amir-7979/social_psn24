import 'dart:ffi';

import 'package:flutter/material.dart';

import '../../../widgets/shimmer.dart';

class ShimmerUserInfo extends StatelessWidget {
  final int? id;
  ShimmerUserInfo({this.id});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              shimmerCircular(context, size: 100),
              SizedBox(width: 16),
              Column(
                children: [
                  shimmerContainer(context,
                      width: 120, height: 18, radius: 16),
                  SizedBox(height: 8),
                  shimmerContainer(context,
                      width: 100, height: 15, radius: 16),
                  id == null ? SizedBox(height: 25) : SizedBox(),
                ],
              ),

            ],
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsetsDirectional.all(16),
            child: buildSeparator(context),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
            child: Center(
              child: shimmerContainer(context,
                  width: 200, height: 20, radius: 16),
            ),
          ),

          Padding(
            padding: EdgeInsetsDirectional.all(16),
            child: buildSeparator(context),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 10),
            child: Center(
              child: shimmerContainer(context,
                  width: 200, height: 20, radius: 16),
            ),
          ),

          SizedBox(height: 18),
          Row(children: [
            Expanded(
              flex: 1,
              child: shimmerContainer(context,
                  width: double.infinity, height: 48, radius: 8),
            ),
            SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: shimmerContainer(context,
                  width: double.infinity, height: 48, radius: 8),
            ),
          ],),
          SizedBox(height: 8),
          id == null ? shimmerContainer(context,
              width: double.infinity, height: 48, radius: 8) : SizedBox(),
        ],
      ),
    );
  }
  Container buildSeparator(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface.withOpacity(0),
            Theme.of(context).colorScheme.surface.withOpacity(01),
            Theme.of(context).colorScheme.surface.withOpacity(0),
          ],
          stops: [0.0, 0.5, 1.0],
        ),
      ),
    );
  }
}
