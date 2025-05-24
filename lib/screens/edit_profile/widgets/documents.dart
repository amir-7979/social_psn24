import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/widgets/profile_attachment/profile_attachment_bloc.dart';

import '../../../configs/localization/app_localizations.dart';

class Documents extends StatefulWidget {
  const Documents({super.key});

  @override
  State<Documents> createState() => _DocumentsState();
}

class _DocumentsState extends State<Documents> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {


      },
      child: Container() /*SizedBox(
        width: double.infinity,
        child: DottedBorder(
          color: Theme.of(context).colorScheme.surface,
          strokeWidth: 1,
          dashPattern: [8, 4],
          padding: EdgeInsets.all(8),
          borderType: BorderType.RRect,
          radius: Radius.circular(16),
          child: BlocConsumer<ProfileAttachmentBloc, ProfileAttachmentState>(
            listenWhen: (previous, current) =>
                current is ProfileAttachmentFailure,
            listener: (context, state) {
              if (state is ProfileAttachmentFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.error ?? 'خطا در بارگذاری'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            buildWhen: (previous, current) => current is RebuildMediaListState,
            builder: (context, state) {
              return _buildContent(context, createPostBloc.mediaItems.length);
            },
          ),
        ),
      )*/,
    );
  }
}
