import 'package:flutter/material.dart';
import '../../../widgets/shimmer.dart';

class ShimmerUserInfo extends StatelessWidget {
  const ShimmerUserInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 345,
      padding: const EdgeInsetsDirectional.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.background,
      ),
      child: Column(
        children: [
          Row(
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
                      SizedBox(height: 20),
                      shimmerContainer(context,
                          width: 150, height: 17, radius: 16),
                      SizedBox(height: 20),
                      shimmerContainer(context,
                          width: 150, height: 17, radius: 16),
                      SizedBox(height: 20),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        shimmerCircular(context,
                            size: 100),
                        SizedBox(height: 8),
                        shimmerContainer(context,
                            width: 100, height: 15, radius: 16),
                        SizedBox(height: 5),
                        shimmerContainer(context,
                            width: 70, height: 10, radius: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          shimmerContainer(context,
              width: double.infinity, height: 45, radius: 8),
          SizedBox(height: 16),
          shimmerContainer(context,
              width: 180, height: 25, radius: 16),
        ],
      ),
    );
  }
}
