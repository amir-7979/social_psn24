import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/repos/models/consultation_model/consultation.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../widgets/profile_cached_network_image.dart';

class ConsultationItem extends StatelessWidget {
  final Consultation consultation;
  ConsultationItem( this.consultation); // e.g., 'paying'


  Color getStatusColor(BuildContext context) {
    switch (consultation.status) {
      case 'approved':
        return Theme.of(context).primaryColor;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'status':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: (consultation.consultant?.avatar != null)
                    ? FittedBox(
                  fit: BoxFit.cover,
                  child: Container(
                      child:
                      ProfileCacheImage("https://media.psn24.ir/avatars/Goz0JKmWmQKwj2VdfuL3qlPZnRzeGp39Y0yVKUvZ.jpg")),
                )
                    : SvgPicture.asset(
                    'assets/images/profile/profile2.svg'),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(bottom: 16),
              child: Row(
                children: [
                  Text(
                    consultation.consultant?.name??"",
                    style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  Text(
                    '(${consultation.counselingCenter?.name})',
                    textDirection: TextDirection.ltr,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary,
                    ),
                  ),
                ],
              ),
            ),

          ],

        ),
        Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 24),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.surface),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Header Row
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                      AppLocalizations.of(context)!.translateNested("consultation", 'consultant'),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w400,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.circle, size: 8, color: getStatusColor(context)),
                          const SizedBox(width: 4),
                          Text(
                            consultation.statusPersian??"",
                            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: getStatusColor(context),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Time Row
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/profile/calendar.svg',
                      width: 10,
                      height: 12,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      consultation.date?.jalaliDate??"",

                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Consultant Info
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'مشاور',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Text(
                      'aaaa',
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Actions
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFDCF4FF),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                      onPressed: () {
                        // TODO: navigate to route
                      },
                      child: const Text("مسیر‌یابی مرکز"),
                    ),
                    TextButton(
                      onPressed: () {
                        // TODO: show more
                      },
                      child: const Text("نمایش بیشتر"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
