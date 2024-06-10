import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../../configs/setting/themes.dart';
import '../../../repos/models/post.dart';
import '../../widgets/profile_cached_network_image.dart';

class PostItem extends StatelessWidget {
  final Post post;
  PostItem(this.post);


  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
       Row(children: [
         ClipOval(
           child: SizedBox.fromSize(
             size: Size.fromRadius(60), // Image radius
             child: post.creator?.photo != null ? ProfileCacheImage(post.creator?.photo) :  SvgPicture.asset('assets/images/drawer/profile2.svg'),
           ),
         ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                Text('${ post.creator!.name!} ${ post.creator!.family!}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.shadow,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                  SizedBox(width: 3),
                  Text('(${post.creator!.username!})',
                  style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SvgPicture.asset(
                    'assets/images/profile/calendar.svg',
                    width: 10,
                    height: 12,
                  ),
                  SizedBox(width: 6),
                  Text('${post.createdAt!}',
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.surface,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],),


            ],
          ),
         Spacer(),
         PopupMenuButton<int>(
           padding: EdgeInsets.zero,
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8),
           ),
           color: Theme.of(context).colorScheme.background,
           surfaceTintColor: Theme.of(context).colorScheme.background,
           shadowColor: Colors.transparent,
           icon: Container(
               height: 25,
               width: 25,
               padding: const EdgeInsets.all(2),
               decoration: BoxDecoration(
                 color: Colors.black.withOpacity(0.3),
                 // semi-transparent background
                 shape: BoxShape.circle,
               ),
               child: SvgPicture.asset(
                   'assets/images/profile/three_dots.svg',
                   width: 6,
                   height: 14,
                   color: Theme.of(context).hoverColor),),
           // white icon
           itemBuilder: (context) => [
             PopupMenuItem(
               onTap: () {},
               value: 1,
               padding: EdgeInsets.symmetric(horizontal: 10),
               child: Row(
                 children: [
                   SvgPicture.asset('assets/images/post/heart.svg',
                       height: 20,
                       width: 20,
                       color: Theme.of(context).colorScheme.shadow),
                   SizedBox(width: 12),
                   Text(
                     AppLocalizations.of(context)!
                         .translateNested("posScreen", "addInterest"),
                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
                       color: Theme.of(context).colorScheme.shadow,
                     ),
                   ),
                 ],
               ),
             ),
             PopupMenuItem(
               onTap: () {},
               value: 2,
               padding: EdgeInsets.symmetric(horizontal: 10),
               child: Row(
                 children: [
                   SvgPicture.asset('assets/images/post/bell.svg',
                       height: 20,
                       width: 20,
                       color: Theme.of(context).colorScheme.shadow),
                   SizedBox(width: 12),
                   Text(
                     AppLocalizations.of(context)!
                         .translateNested("postScreen", "interest"),
                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
                       color: Theme.of(context).colorScheme.shadow,
                     ),
                   ),
                 ],
               ),
             ),
             PopupMenuItem(
               onTap: () {},
               value: 3,
               padding: EdgeInsets.symmetric(horizontal: 10),
               child: Row(
                 children: [
                   SvgPicture.asset('assets/images/post/share.svg',
                       height: 20,
                       width: 20,
                       color: Theme.of(context).colorScheme.shadow),
                   SizedBox(width: 12),
                   Text(
                     AppLocalizations.of(context)!
                         .translateNested("postScreen", "share"),
                     style: Theme.of(context).textTheme.titleLarge!.copyWith(
                       color: Theme.of(context).colorScheme.shadow,
                     ),
                   ),
                 ],
               ),
             ),
           ],
           onSelected: (value) {
             if (value == 1) {
               // Handle edit action
             } else if (value == 2) {
               // Handle delete action
             }
           },
         ),
       ]),
        Row(
          children: [
           Container(height: 200)
          ],
        ),
        Row(
          children: [
            Text('${post.name}',
              overflow: TextOverflow.ellipsis,

              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                color: Theme.of(context).colorScheme.shadow,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text('${post.description}',
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.shadow,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                IconButton(onPressed: (){}, icon: SvgPicture.asset('assets/images/post/like.svg', color: Theme.of(context).colorScheme.shadow,),),
                Text('${post.viewCount}',
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.shadow,
                    fontWeight: FontWeight.w400,
                  ),
                ),

              ],
            ),
            Row(
              children: [
                IconButton(onPressed: (){}, icon: SvgPicture.asset('assets/images/post/dislike.svg', color: Theme.of(context).colorScheme.shadow,),),
                SizedBox(width: 32),
                IconButton(onPressed: (){}, icon: SvgPicture.asset('assets/images/post/dislike.svg', color: Theme.of(context).colorScheme.shadow,),),
                SizedBox(width: 32),
                IconButton(onPressed: (){}, icon: SvgPicture.asset('assets/images/post/like.svg', color: Theme.of(context).colorScheme.shadow,),),
                SizedBox(width: 8),

              ],
            ),
          ],
        ),
      ],
    );
  }
}
