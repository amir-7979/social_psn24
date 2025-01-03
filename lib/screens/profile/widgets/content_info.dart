import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:social_psn/screens/profile/widgets/normal_user/comment_widget.dart';
import 'package:social_psn/screens/profile/widgets/normal_user/content_widget.dart';

import '../../../configs/setting/setting_bloc.dart';
import '../profile_bloc.dart';
import 'expert_user/comment_expert_tab.dart';
import 'expert_user/content_expert_tab.dart';

class ContentInfo extends StatefulWidget {
   const ContentInfo({super.key});

  @override
  State<ContentInfo> createState() => _ContentInfoState();
}

class _ContentInfoState extends State<ContentInfo>
    with SingleTickerProviderStateMixin {
  bool seeExpertPost = false;
  bool seeExpertComment = false;
  int? profileId;

  @override
  void initState() {
    super.initState();
    seeExpertPost =  context.read<SettingBloc>().state.seeExpertPost ?? false;
    seeExpertPost =  context.read<SettingBloc>().state.seeExpertPost ?? false;

  }
  @override
  void didChangeDependencies() {
    profileId = ModalRoute.of(context)?.settings.arguments as int?;
    context.read<ProfileBloc>().add(ChangeToPostEvent());
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return SizedBox(

      child: BlocBuilder<ProfileBloc, ProfileState>(
          buildWhen: (previous, current) {
            if (current is ChangeToPostState || current is ChangeToCommentState) {
              return true;
            }
            return false;
          },
          builder: (context, state) {
            if (state is ChangeToPostState && seeExpertPost == true) {
              return ContentExpertTab(profileId: profileId);
            } else if (state is ChangeToPostState && seeExpertPost == false) {
              return ContentWidget(profileId: profileId);
            } else if (state is ChangeToCommentState && seeExpertPost == true) {
              return CommentExpertTab(profileId);
            } else if (state is ChangeToCommentState && seeExpertPost == false) {
              return CommentWidget(profileId: profileId);
            }
            return ContentWidget(profileId: profileId);
          }
      ),
    );
  }
}