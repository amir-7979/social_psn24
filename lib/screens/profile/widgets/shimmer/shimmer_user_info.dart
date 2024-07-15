import 'package:flutter/material.dart';

import '../../../widgets/shimmer.dart';

class ShimmerUserInfo extends StatelessWidget {
  const ShimmerUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 346,
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(end: 30),
                child: Container(
                  width: 150,
                  height: 150,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 15),
                      shimmerContainer(context,
                          width: 150, height: 17, radius: 16),
                      SizedBox(height: 18),
                      shimmerContainer(context,
                          width: 150, height: 17, radius: 16),
                      SizedBox(height: 18),
                      shimmerContainer(context,
                          width: 150, height: 17, radius: 16),
                      SizedBox(height: 18),
                      shimmerContainer(context,
                          width: 150, height: 17, radius: 16),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(end: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        shimmerCircular(context, size: 100),
                        SizedBox(height: 12),
                        shimmerContainer(context,
                            width: 150, height: 15, radius: 16),
                        SizedBox(height: 14),
                        shimmerContainer(context,
                            width: 90, height: 13, radius: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 45),
          shimmerContainer(context,
              width: double.infinity, height: 45, radius: 8),
          SizedBox(height: 40),
          shimmerContainer(context,
              width: 180, height: 30, radius: 16),
        ],
      ),
    );
  }
}
