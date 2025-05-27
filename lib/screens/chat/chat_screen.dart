import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_core/flutter_chat_core.dart' as flutter_chat_core;
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../configs/localization/app_localizations.dart';
import '../main/widgets/screen_builder.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dialogs/my_confirm_dialog.dart';
import '../widgets/profile_cached_network_image.dart';
import 'chat_bloc.dart';

class ChatScreen extends StatefulWidget {
  final String chatUuid;
  final String wsDomain;
  final String wsChannel;
  final String chatTitle;
  final int userId;
  final String? avatarUrl;


  const ChatScreen({
    Key? key,
    required this.chatUuid,
    required this.wsDomain,
    required this.wsChannel,
    required this.chatTitle,
    required this.userId,
    this.avatarUrl,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _chatController = flutter_chat_core.InMemoryChatController();

  late types.User _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = types.User(id: widget.userId.toString());

  }


  Future<flutter_chat_core.User?> _resolveUser(String userId) async {
    final user = types.User(
      id: userId,
      firstName: 'User $userId', // Example: Replace with actual user data
    );
    return flutter_chat_core.User(
      id: user.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        currentUser: _currentUser,
        wsDomain: widget.wsDomain,
        chatUuid: widget.chatUuid,)..add(ChatInitEvent(chatUuid: widget.chatUuid)),
      child: Builder(builder: (context) {
        return BlocConsumer<ChatBloc, ChatState>(
          listenWhen: (context, state) {
            return state is ChatMessageSent || state is ChatError;
          },
          listener: (context, state) {
            if (state is ChatMessageSent) {

            } else if (state is ChatError) {
              ScaffoldMessenger.of(context).showSnackBar(
                CustomSnackBar(content: state.message).build(context),
              );
            }
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                ),
              );
            }else if (state is ChatError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<ChatBloc>(context).add(
                            FetchChatHistoryEvent(chatUuid: widget.chatUuid));

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE91E63),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('تلاش مجدد'),
                    ),
                  ],
                ),
              );
            }
            else if (state is ChatLoaded) {
              return Column(
                children: [
                  Container(
                    height: 60,
                    padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 24, 8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushNamed(AppRoutes.profile,
                                arguments: widget.userId);
                          },
                          child: Container(
                            width: 45,
                            height: 45,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Theme.of(context).colorScheme.background,
                              border: Border.all(
                                  color: Theme.of(context).colorScheme.background),
                            ),
                            child: ClipOval(
                              child: (widget.avatarUrl != null)
                                  ? FittedBox(
                                fit: BoxFit.cover,
                                child: ProfileCacheImage(
                                  widget.avatarUrl,
                                ),
                              )
                                  : SvgPicture.asset(
                                  'assets/images/profile/profile2.svg'),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.only(start: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Flexible(
                                        child: Text(
                                          widget.chatTitle,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .onBackground,
                                              //fontSize: 14,
                                              fontWeight: FontWeight.w200),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.only(
                                            top: 4),
                                        child: Text(
                                          'آخرین بازدید',
                                          textDirection: TextDirection.ltr,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium!
                                              .copyWith(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .surface,
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsetsDirectional.symmetric(
                                            horizontal: 8, vertical: 0),
                                        minimumSize: const Size(80, 30),
                                        shadowColor: Colors.transparent,
                                        //foregroundColor: Theme.of(context).colorScheme.tertiary,
                                        backgroundColor: Theme.of(context)
                                            .colorScheme
                                            .error
                                            .withOpacity(0.2),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                      ),
                                      onPressed: () async{
                                        BuildContext profileContext = context;
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return MyConfirmDialog(
                                              title: AppLocalizations.of(context)!.translateNested(
                                                  'consultation', 'cancelConsultation'), description: AppLocalizations.of(context)!.translateNested(
                                                'consultation', 'deleteConsultationDescription'), cancelText: AppLocalizations.of(context)!.translateNested(
                                                'dialog', 'cancel'),confirmText: AppLocalizations.of(context)!.translateNested(
                                                'dialog', 'delete'),
                                              onCancel: () {
                                                Navigator.pop(context);
                                              },
                                              onConfirm: () {
                                                BlocProvider.of<ChatBloc>(profileContext)
                                                    .add(FinishChatEvent(chatUuid: widget.chatUuid));
                                                Navigator.pop(context);
                                              },
                                            );
                                          },
                                        );
                                      },
                                      child: Text(
                                        AppLocalizations.of(context)!.translateNested(
                                            "consultation", "cancelConsultation"),
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                          fontWeight: FontWeight.w400,
                                          color:
                                          Theme.of(context).colorScheme.error,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 16),
                                    InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: FaIcon(

                                          FontAwesomeIcons.lightArrowLeft,

                                          size: 20,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onBackground),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Background pattern (optional)
                  Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFF5F5F5),
                    ),
                  ),

                  // Chat UI
                 /* Chat(
          currentUserId: _currentUser.id,
          resolveUser: (userId) => _resolveUser(userId),
          chatController: _chatController,

        )*/
                ],
              );
            } else {
              return const Center(
                child: Text('خطا در بارگذاری چت'),
              );
            }

          },
        );
      }),
    );
  }

  Widget _buildCustomInput(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Voice message button
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () {
                  // Implement voice message functionality
                  _showVoiceMessageDialog();
                },
                icon: const Icon(
                  Icons.mic,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ),

            // Attachment button
            Container(
              margin: const EdgeInsets.only(left: 8),
              child: IconButton(
                onPressed: () {
                  // Implement file attachment functionality
                  _showAttachmentDialog();
                },
                icon: const Icon(
                  Icons.attach_file,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ),

            // Text input
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: TextField(
                  enabled: !isLoading,
                  decoration: const InputDecoration(
                    hintText: 'پیام خود را بنویسید...',
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  onSubmitted: (text) {
                    if (text.trim().isNotEmpty) {
                      _handleSendPressed(types.PartialText(text: text.trim()));
                    }
                  },
                ),
              ),
            ),

            // Emoji button
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                onPressed: () {
                  // Implement emoji picker functionality
                  _showEmojiPicker();
                },
                icon: const Icon(
                  Icons.sentiment_satisfied_alt_outlined,
                  color: Colors.grey,
                  size: 24,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    if (message.text.trim().isEmpty) return;

    BlocProvider.of<ChatBloc>(context).add(
      SendChatMessageEvent(
        chatUuid: widget.chatUuid,
        text: message.text.trim(),
      ),
    );
  }

  void _showVoiceMessageDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('پیام صوتی'),
          content: const Text(
              'قابلیت ارسال پیام صوتی در نسخه آینده اضافه خواهد شد.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('باشه'),
            ),
          ],
        );
      },
    );
  }

  void _showAttachmentDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo, color: Color(0xFFE91E63)),
                title: const Text('تصویر'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement image picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.insert_drive_file,
                    color: Color(0xFFE91E63)),
                title: const Text('فایل'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement file picker
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Color(0xFFE91E63)),
                title: const Text('دوربین'),
                onTap: () {
                  Navigator.pop(context);
                  // Implement camera
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEmojiPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          height: 300,
          padding: const EdgeInsets.all(20),
          child: const Center(
            child: Text(
              'انتخابگر ایموجی در نسخه آینده اضافه خواهد شد',
              style: TextStyle(fontSize: 16),
            ),
          ),
        );
      },
    );
  }
}
