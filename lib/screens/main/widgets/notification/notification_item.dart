import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class NotificationItem extends StatelessWidget {
  String path1 = '';
  String path2 = '';

  NotificationItem(this.path1, this.path2);

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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(5, 3, 16, 3),
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage(path1),
                ),
              ),
              SizedBox(
                width: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'کاربر۱ محتوای جدید منتشر کرد.کاربر۱ محتوای جدید منتشر کرد.',
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    Padding(
                      padding: const EdgeInsetsDirectional.only(top: 3),
                      child: Text(
                        '۱۴۰۱/۰۱/۰۱',
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: Theme.of(context).colorScheme.surface,
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
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
            ],
          ),
        ),
        Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.surface.withOpacity(0),
                Theme.of(context).colorScheme.surface.withOpacity(0.1),
                Theme.of(context).colorScheme.surface.withOpacity(0.2),
                Theme.of(context).colorScheme.surface.withOpacity(0.3),
                Theme.of(context).colorScheme.surface.withOpacity(0.4),
              ],
              stops: [0.0, 0.25, 0.5, 0.75, 1.0],
            ),
          ),
        ),
      ],
    );
  }
}
