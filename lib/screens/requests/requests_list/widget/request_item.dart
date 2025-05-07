import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:social_psn/repos/models/request_data.dart';

import '../../../../configs/localization/app_localizations.dart';
import '../../../../configs/utilities.dart';
import '../../../main/widgets/screen_builder.dart';
import 'shimmer/request_item_shimmer.dart';

class RequestItem extends StatelessWidget {
  final RequestData requestData;

  RequestItem(this.requestData);

  Color getStatusColor(BuildContext context, String? status) {
    switch (status) {
      case 'approved':
        return Theme.of(context).primaryColor;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'paying':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding:  EdgeInsetsDirectional.only(bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding:  EdgeInsetsDirectional.symmetric(horizontal: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      requestData.type ?? '',
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            color: Theme.of(context).hoverColor,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.circle,
                            size: 8,
                            color: getStatusColor(context, requestData.status)),
                        const SizedBox(width: 4),
                        Text(
                          requestData.statusFa ?? '',
                          // You can change this dynamically if needed
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: getStatusColor(context, requestData.status),
                                fontWeight: FontWeight.w400,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Theme.of(context).colorScheme.surface),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          'assets/images/profile/calendar.svg',
                          width: 10,
                          height: 12,
                        ),
                        SizedBox(width: 2),
                        Text(
                          requestData.createdAt ?? '',
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          AppLocalizations.of(context)!
                              .translateNested("consultation", "userDescription"),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                color: Theme.of(context).colorScheme.surface,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        SizedBox(width: 50),
                        Expanded(
                          child: Text(
                            requestData.description ?? '',
                            maxLines: 1,
                            textDirection: detectDirection(requestData.description),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                              color: Theme.of(context).hoverColor,
                              fontWeight: FontWeight.w400,
                            ),

                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsetsDirectional.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(113, 34),
                          shadowColor: Colors.transparent,
                          //foregroundColor: Theme.of(context).colorScheme.tertiary,
                          backgroundColor: Color(0x3300A6ED),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, AppRoutes.createRequest,
                              arguments: requestData);
                        },
                        child: Text(
                          AppLocalizations.of(context)!
                              .translateNested("consultation", "showRequest"),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                            fontWeight: FontWeight.w400,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
