import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/utilities.dart';
import '../../../repos/models/notification.dart';
import '../../main/widgets/screen_builder.dart';
import '../../widgets/profile_cached_network_image.dart';
import '../notification_bloc.dart';

class NotificationItem extends StatelessWidget {
  MyNotification notification;

  NotificationItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        navigatorKey.currentState?.pushNamed(
          AppRoutes.postDetailed,
          arguments: <String, dynamic>{
            'postId': notification.data?.postId,
          },
        );
        Navigator.of(context).pop();
        BlocProvider.of<NotificationBloc>(context).add(NotificationMarked(notification.id.toString()));
      },
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 5, 7),
        height: 75,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 3, 8, 3),
              child: ClipOval(
                child: SizedBox.fromSize(
                  size: Size.fromRadius(20), // Image radius
                  child: notification.data?.userPhoto != null ? InkWell(
                      onTap:(){navigatorKey.currentState?.pushNamed(AppRoutes.profile,
                          arguments: notification.data?.commentUserGlobalId?.toInt());
                      Navigator.of(context).pop();},
                      child: ProfileCacheImage(notification.data?.userPhoto)) :  Container(),
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${notification.body??''}',
                    maxLines: 1,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall!.copyWith(
                          color: Theme.of(context).hoverColor,
                          fontWeight: notification.seen == 1 ? FontWeight.w400 : FontWeight.bold ,
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/profile/calendar.svg',
                          width: 10,
                          height: 12,
                        ),
                        SizedBox(width: 6),
                        Text(
                          notification.createdAt??'',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),

                  ),
                ],
              ),
            ),
      /*
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(16, 3, 0, 3),
              child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.circular(16),
                    //borderRadius: BorderRadius.circular(25),
                  ),
                 child:
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(path2),
                  ),
              ),
            )
      */
          ],
        ),
      ),
    );
  }
}
