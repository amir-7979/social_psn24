import 'package:flutter/material.dart';

import '../../../widgets/shimmer.dart';

class ShimmerEditExpertUser extends StatelessWidget {
  const ShimmerEditExpertUser({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsetsDirectional.all(16),
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
                const SizedBox(height: 24),
                shimmerContainer(context,
                    width: 150, height: 20, radius: 16),
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
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                shimmerContainer(context,
                    width: 150, height: 20, radius: 16),
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
            Padding(
              padding:
              const EdgeInsetsDirectional.only(bottom: 16.0),
              child: shimmerContainer(context, width: double.infinity, height: 40, radius: 8),
            ),
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
