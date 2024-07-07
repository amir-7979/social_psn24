import 'package:flutter/material.dart';

import '../../widgets/TrianglePainter.dart';
import '../../widgets/shimmer.dart';

class CommentItemShimmer extends StatelessWidget {
  const CommentItemShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            shimmerCircular(context, size: 40),
            SizedBox(width: 8),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //rectangular container
                  CustomPaint(
                    size: Size(10, 10), // Specify your size
                    painter: TrianglePainter(
                      strokeColor:
                      Theme.of(context).colorScheme.onPrimaryContainer,
                      strokeWidth: 10,
                      paintingStyle: PaintingStyle.fill,
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 122,
                    constraints: BoxConstraints(
                      minHeight: 80,
                    ),
                    padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: BorderRadiusDirectional.only(
                        topStart: Radius.circular(0),
                        topEnd: Radius.circular(8),
                        bottomEnd: Radius.circular(8),
                        bottomStart: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            shimmerContainer(context,
                                width: 120, height: 12, radius: 16),
                            Spacer(),
                            shimmerContainer(context,
                                width: 75, height: 12, radius: 16),
                          ],
                        ),
                        SizedBox(height: 8),
                        shimmerContainer(context,
                            width: 40, height: 10, radius: 16),
                        SizedBox(height: 13),
                        shimmerContainer(context,
                            width: double.infinity, height: 12, radius: 16),
                        SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            shimmerContainer(context,
                                width: 75, height: 16, radius: 16),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        //for reply in comment , create repliitem
        Padding(
          padding: const EdgeInsetsDirectional.only(start: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              shimmerCircular(context, size: 36),
              SizedBox(width: 8),
              Padding(
                padding: EdgeInsetsDirectional.only(top: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //rectangular container
                    CustomPaint(
                      size: Size(10, 10), // Specify your size
                      painter: TrianglePainter(
                        strokeColor:
                        Theme.of(context).colorScheme.onSurface,
                        strokeWidth: 10,
                        paintingStyle: PaintingStyle.fill,
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 138,
                      constraints: BoxConstraints(
                        minHeight: 80,
                      ),
                      padding: EdgeInsetsDirectional.fromSTEB(8, 8, 8, 0),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSurface,
                        borderRadius: BorderRadiusDirectional.only(
                          topStart: Radius.circular(0),
                          topEnd: Radius.circular(8),
                          bottomEnd: Radius.circular(8),
                          bottomStart: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              shimmerContainer(context,
                                  width: 120, height: 12, radius: 16),
                              Spacer(),
                              shimmerContainer(context,
                                  width: 75, height: 12, radius: 16),
                            ],
                          ),
                          SizedBox(height: 8),
                          shimmerContainer(context,
                              width: 40, height: 10, radius: 16),
                          SizedBox(height: 12),
                          shimmerContainer(context,
                              width: double.infinity, height: 12, radius: 16),
                          SizedBox(height: 35),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

}
