import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_psn/configs/setting/themes.dart';

import '../../../repos/models/content.dart';
import '../../../repos/models/liked.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/selectImge.dart';

class InterestItem extends StatelessWidget {
  final Liked liked;
  InterestItem(this.liked);


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(AppRoutes.postDetailed, arguments: <String, dynamic>{
          'postId': liked.id,
        },);
      },
      child: Stack(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 1.0, // to make it square
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: selectImage(liked.medias ?? [])

            ),
          ),
          Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x00000000), // transparent color
                  Color(0xB2000000), // semi-transparent black color
                ],
              ),
            ),
            child: Align(
                alignment: AlignmentDirectional.bottomStart,
                child: Container(
                  padding: const EdgeInsetsDirectional.fromSTEB(7, 3, 0, 3),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          liked.name?? '',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                            color: whiteColor,
                            fontWeight: FontWeight.w400,
                          ),),
                      ), // white text
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}