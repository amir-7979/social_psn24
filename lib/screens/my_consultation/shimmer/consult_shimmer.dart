import 'package:flutter/material.dart';
import '../../widgets/shimmer.dart';

class ConsultationShimmer extends StatelessWidget {
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
                  border:
                      Border.all(color: Theme.of(context).colorScheme.surface),
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
                                    width: 70, height: 16, radius: 16),
                              ],
                            ),
                          ),
                          SizedBox(height: 23),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              shimmerContainer(context,
                                  width: 40, height: 12, radius: 16),
                              shimmerContainer(context,
                                  width: 100, height: 12, radius: 16),
                            ],
                          ),
                          SizedBox(height: 2),
                        ],
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Theme.of(context).primaryColor.withOpacity(0.2),
                            Theme.of(context)
                                .colorScheme
                                .background
                                .withOpacity(0.0),
                          ],
                        ),
                      ),
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          shimmerContainer(context,
                              width: 80, height: 25, radius: 4),
                          SizedBox(width: 8),
                          shimmerContainer(context,
                              width: 80, height: 25, radius: 4),
                        ],
                      ),
                    )
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
                  border: Border.all(
                      color: Theme.of(context).colorScheme.background),
                ),
                child: shimmerCircular(context, size: 55),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(top: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      shimmerContainer(context,
                          width: 100, height: 13, radius: 8),
                      shimmerContainer(context,
                          width: 75, height: 12, radius: 8),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
