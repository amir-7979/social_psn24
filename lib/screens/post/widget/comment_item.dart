import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../repos/models/creator.dart';
import '../../../repos/models/post.dart';
import '../../widgets/profile_cached_network_image.dart';

class CommentItem extends StatelessWidget {
  CommentItem({super.key});
  final Post post = Post(
      id: '1',
      name:
      'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است.',
      description:
      'لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از صنعت چاپ و با استفاده از طراحان گرافیک است. چاپگرها و متون بلکه روزنامه و مجله در ستون و سطرآنچنان که لازم است و برای شرایط فعلی تکنولوژی مورد نیاز و کاربردهای متنوع با هدف بهبود ابزارهای کاربردی می باشد. کتابهای زیادی در شصت و سه درصد گذشته، حال و آینده شناخت فراوان جامعه و متخصصان را می طلبد تا با نرم افزارها شناخت بیشتری را برای طراحان رایانه ای علی الخصوص طراحان خلاقی و فرهنگ پیشرو در زبان فارسی ایجاد کرد. در این صورت می توان امید داشت که تمام و دشواری موجود در ارائه راهکارها و شرایط سخت تایپ به پایان رسد وزمان مورد نیاز شامل حروفچینی دستاوردهای اصلی و جوابگوی سوالات پیوسته اهل دنیای موجود طراحی اساسا مورد استفاده قرار گیرد.',
      creator: Creator(
          name: 'name',
          family: 'family',
          username: 'username',
          displayName: 'displayName'),
      persianDate: '1399/01/01',
      viewCount: 100,
      voteUp: false,
      voteDown: false,
      currentUserUpVotes: false,
      currentUserDownVotes: false,
      currentUserLiked: false,
      currentUserNotificationEnabled: false,
      isLiked: false,
      isNotificationEnabled: false,
      medias: []);

  String? photo = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: Size.fromRadius(20), // Image radius
                child: photo != null ? ProfileCacheImage(photo) :  SvgPicture.asset('assets/images/drawer/profile2.svg'),
              ),
            ),
            SizedBox(width: 15),
            Padding(
              padding: EdgeInsetsDirectional.only(top: 20),
              child: Container(
                padding: EdgeInsetsDirectional.all(8),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /*Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${post.creator?.name??''} ${post.creator?.family??''}',
                          overflow: TextOverflow.ellipsis,
                          style:
                          Theme.of(context).textTheme.bodyLarge!.copyWith(
                            color: Theme.of(context).colorScheme.shadow,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 3),
                        Text(
                          '(${post.creator?.username??''})',
                          textDirection: TextDirection.ltr,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        Spacer(),
                        SvgPicture.asset(
                          'assets/images/profile/calendar.svg',
                          width: 10,
                          height: 12,
                        ),
                        SizedBox(width: 6),
                        Text(
                          '${post.persianDate??''}',
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).colorScheme.surface,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),*/
                    Expanded(
                      child: Text(
                        post.description ?? '',
                        maxLines: null,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
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
        ),
      ],
    );
  }
}
