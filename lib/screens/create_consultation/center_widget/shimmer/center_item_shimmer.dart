import 'package:flutter/material.dart';

import '../../../widgets/shimmer.dart';

class CenterItemShimmer extends StatelessWidget {

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
                          start: 12, end: 12, top: 10, bottom: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsetsDirectional.only(start: 55),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                shimmerContainer(context,
                                    width: 100, height: 10, radius: 16),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
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
                  shape: BoxShape.rectangle,
                  color: Theme.of(context).colorScheme.background,
                  borderRadius: BorderRadius.circular(8),
                  border:
                  Border.all(color: Theme.of(context).colorScheme.background),
                ),
                child: shimmerContainer(context,
                    width: 55, height: 55, radius: 8),

              ),
              const SizedBox(width: 8),
              Padding(
                padding: const EdgeInsetsDirectional.only(top: 4),
                child: shimmerContainer(context,
                    width: 100, height: 13, radius: 8),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
