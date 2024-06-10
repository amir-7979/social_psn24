import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_psn/repos/models/comment.dart';

import '../../../repos/models/reply.dart';
import '../../widgets/cached_network_image.dart';

class OthersCommentItem extends StatelessWidget {
  final Comment comment;
  OthersCommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child : false == false
              ? CacheImage('')
              : SvgPicture.asset('assets/images/profile/profile.svg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'مسعود عظیمی'
                      /*comment.post.name*/,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.w500,
                          ),
                      maxLines: null,
                    ),
                  ),
                  //svg : assets/images/profile/calendar.svg

                  Text(
                    'شش روز پیش',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Theme.of(context).colorScheme.surface,
                          fontWeight: FontWeight.w400,
                      fontFamily: 'IRANSansXV',

                        ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/profile/media.svg',
                    width: 10,
                    height: 12,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم',
                   /* AppLocalizations.of(context)!
                        .translateNested('profileScreen', 'reply'),*/
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).hoverColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Container(
                padding: const EdgeInsetsDirectional.only(start: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  border: Border.all(
                    color: Theme.of(context).colorScheme.background,
                    width: 0,
                  ),
                  boxShadow: null,
                  backgroundBlendMode: null,
                  gradient: null,
                  color: Theme.of(context).primaryColor,
                ),
                child: Container(
                  padding: const EdgeInsetsDirectional.only(start: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    border: null,
                    boxShadow: null,
                    backgroundBlendMode: null,
                    gradient: null,
                    color: Theme.of(context).colorScheme.background,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          comment.message,
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    color: Theme.of(context).hoverColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (comment.replies != null)
                for (Reply reply in comment.replies!)
                  replyWidget(context, reply),

              SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }

  Widget replyWidget(BuildContext context, Reply reply){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          height: 35,
          width: 35,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child : false == false
              ? CacheImage('')
              : SvgPicture.asset('assets/images/profile/profile.svg'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'مسعود عظیمی'
                      /*comment.post.name*/,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).hoverColor,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: null,
                    ),
                  ),
                  //svg : assets/images/profile/calendar.svg

                  Text(
                    'شش روز پیش',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'IRANSansXV',

                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/images/profile/media.svg',
                    width: 10,
                    height: 12,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم',
                    /* AppLocalizations.of(context)!
                        .translateNested('profileScreen', 'reply'),*/
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).hoverColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

            ],
          ),
        ),
      ],
    );
  }
}
