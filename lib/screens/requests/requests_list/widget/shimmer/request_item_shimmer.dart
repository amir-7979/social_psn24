import 'package:flutter/material.dart';

import '../../../../widgets/shimmer.dart';


class RequestItemShimmer extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  EdgeInsetsDirectional.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding:  EdgeInsetsDirectional.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                shimmerContainer(context, width: 120, height: 14, radius: 4),
                shimmerContainer(context, width: 50, height: 11, radius: 4),

              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.surface),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                shimmerContainer(context, width: 90, height: 12, radius: 4),

                const SizedBox(height: 20),
                Row(

                  children: [
                    shimmerContainer(context, width: 50, height: 12, radius: 4),
                    SizedBox(width: 50),
                    Expanded(child: shimmerContainer(context, width: double.infinity, height: 12, radius: 4)),

                  ],
                ),


                const SizedBox(height: 26),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    shimmerContainer(context, width: 113, height: 34, radius: 8),
                  ],
                ),
                const SizedBox(height: 8),


              ],
            ),
          ),
        ],
      ),
    );
  }
}
