import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../repos/models/notification.dart';
import '../../widgets/profile_cached_network_image.dart';

class NotificationItem extends StatelessWidget {
  MyNotification notification;

  NotificationItem(this.notification);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsetsDirectional.fromSTEB(0, 7, 5, 7),
          height: 75,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 6,
                width: 6,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  shape: BoxShape.circle,
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamed('/profile', arguments: notification.target);
                },
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(5, 3, 16, 3),
                  child: ClipOval(
                    child: SizedBox.fromSize(
                      size: Size.fromRadius(25), // Image radius
                      child: notification.target!.photo != null ? ProfileCacheImage(notification.target!.photo) :  SvgPicture.asset('assets/images/drawer/profile2.svg'),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.of(context).pushNamed('/profile', arguments: notification.target);
                },
                child: SizedBox(
                  width: 180,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notification.message??'',
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.w400,
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
      ],
    );
  }
}
