import 'package:flutter/material.dart';

import '../../widgets/shimmer.dart';

class ShimmerPostItem extends StatelessWidget {
  const ShimmerPostItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerCircular(context, size: 48),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  shimmerContainer(context, width: 120, height: 10, radius: 16),
                  SizedBox(height: 6),
                  shimmerContainer(context, width: 50, height: 10, radius: 16),
                  SizedBox(height: 6),
                  shimmerContainer(context, width: 70, height: 10, radius: 16),
                ],
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 22, top: 14),
                child: shimmerContainer(context, width: 5, height: 18, radius: 8),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsetsDirectional.symmetric(vertical: 16),
            child: shimmerContainer(context,
                width: 400, height: 220, radius: 8),),
          shimmerContainer(context, width: 150, height: 15, radius: 16),
          SizedBox(height: 16),
          shimmerContainer(context, width: double.infinity, height: 11, radius: 16),
          SizedBox(height: 5),
          shimmerContainer(context, width: double.infinity, height: 11, radius: 16),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsetsDirectional.only(start: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                shimmerContainer(context,width : 36, height: 36, radius: 12),
                SizedBox(width: 15),
                shimmerContainer(context,width : 36, height: 36, radius: 12),
                SizedBox(width: 15),
                shimmerContainer(context,width : 36, height: 36, radius: 12),
                SizedBox(width: 15),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
