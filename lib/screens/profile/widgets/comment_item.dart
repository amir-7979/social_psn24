import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_psn/repos/models/comment.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../repos/models/reply.dart';
import '../../widgets/cached_network_image.dart';
import '../../widgets/selectImge.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  CommentItem(this.comment);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 50,
            width: 50,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: selectImage(comment.post.medias??[]),
            ),
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
                        comment.post.name,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.w500,
                            ),
                        maxLines: null,
                      ),
                    ),
                    //svg : assets/images/profile/calendar.svg
                    SvgPicture.asset(
                      'assets/images/profile/calendar.svg',
                      width: 10,
                      height: 12,
                    ),
                    SizedBox(width: 6),
                    Text(
                      comment.persianDate,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.w400,
                        fontFamily: 'IRANSansXV',

                          ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
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

                SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget replyWidget(BuildContext context, Reply reply){
    return Column(
      children: [
        SizedBox(height: 8),
        Row(
          children: [
            SvgPicture.asset(
              'assets/images/profile/reply.svg',
              width: 10,
              height: 12,
            ),
            SizedBox(width: 8),
            Text(
              AppLocalizations.of(context)!
                  .translateNested('profileScreen', 'reply'),
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).hoverColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
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
                    reply.message,
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
      ],
    );
  }
}
