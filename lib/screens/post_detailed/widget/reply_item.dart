import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/repos/models/reply.dart';

import '../../main/widgets/screen_builder.dart';
import '../../widgets/TrianglePainter.dart';
import '../../widgets/profile_cached_network_image.dart';

class ReplyItem extends StatelessWidget {
  final Reply reply;

  ReplyItem(this.reply);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 35, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).pushNamed(AppRoutes.profile,
                  arguments: reply.sender?.globalId);
            },
            child: ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(18), // Image radius
                child: reply.sender?.photo != null
                    ? ProfileCacheImage(reply.sender?.photo)
                    : SvgPicture.asset('assets/images/drawer/profile2.svg'),
              ),
            ),
          ),
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
                  width: MediaQuery.of(context).size.width - 153,
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
                          Flexible(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Flexible(
                                  child: Text(
                                    '${reply.sender?.name} ${reply.sender?.family}',
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .shadow,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 3),
                                if(reply.sender?.username != null)
                                  Text(
                                    '(${reply.sender?.username})',
                                    textDirection: TextDirection.ltr,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .tertiary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          SizedBox(width: 3),
                          SvgPicture.asset(
                            'assets/images/profile/calendar.svg',
                            width: 10,
                            height: 12,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '${reply.persianDate ?? ''}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                              color:
                              Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 8),
                      Text(
                        reply.message?.trim() ?? '',
                        style:
                        Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Theme.of(context).colorScheme.shadow,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 32),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
