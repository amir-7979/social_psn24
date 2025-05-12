import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../../widgets/shimmer.dart';

class ConsultItemShimmer extends StatelessWidget {
  const ConsultItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            SizedBox(height: 25),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 24),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.surface),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsetsDirectional.only(
                          start: 12, end: 12, top: 12, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsetsDirectional.only(start: 55),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                shimmerContainer(context,
                                    width: 50, height: 10, radius: 16),
                                shimmerContainer(context,
                                    width: 30, height: 16, radius: 16),
                              ],
                            ),
                          ),
                          SizedBox(height: 32),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  shimmerCircular(context, size: 22),
                                  const SizedBox(width: 4),
                                  shimmerCircular(context, size: 22),
                                  const SizedBox(width: 4),
                                  shimmerCircular(context, size: 22),
                                  const SizedBox(width: 4),
                                  shimmerCircular(context, size: 22),
                                  const SizedBox(width: 4),
                                ],
                              ),
                              shimmerContainer(context,
                                  width: 73, height: 26, radius: 4),
                            ],
                          )

                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ],
        ),

        Padding(
          padding: const EdgeInsetsDirectional.only(start: 10),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context).colorScheme.background,
                  border:
                  Border.all(color: Theme.of(context).colorScheme.background),
                ),
                child: shimmerCircular(context, size: 55),

              ),
              const SizedBox(width: 8),
              shimmerContainer(context,
                  width: 100, height: 13, radius: 8),
            ],
          ),
        ),
      ],
    );
  }
}
