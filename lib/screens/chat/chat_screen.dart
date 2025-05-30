import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_core/flutter_chat_core.dart' as flutter_chat_core;
import 'package:flutter_svg/svg.dart';
import 'package:flyer_chat_text_message/flyer_chat_text_message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:social_psn/repos/models/chat_models/chat_message.dart';
import '../../configs/localization/app_localizations.dart';
import '../../repos/models/chat_models/fetch_messages_response.dart';
import '../../repos/repositories/dio/consultation/chat_repository.dart';
import '../main/widgets/screen_builder.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dialogs/my_confirm_dialog.dart';
import '../widgets/profile_cached_network_image.dart';
import 'chat_bloc.dart';
import 'widget/other_message_bubble.dart';

class ChatScreen extends StatefulWidget {
  final String chatUuid;
  final String wsDomain;
  final String wsChannel;
  final String chatTitle;
  final int userId;
  final int currentUserId;
  final String? avatarUrl;

  const ChatScreen({
    Key? key,
    required this.chatUuid,
    required this.wsDomain,
    required this.wsChannel,
    required this.chatTitle,
    required this.userId,
    required this.currentUserId,
    this.avatarUrl,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatRepository chatRepository = ChatRepository();
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  final _chatController = flutter_chat_core.InMemoryChatController();

  late types.User user2;
  late types.User user1;

  @override
  void initState() {
    super.initState();
    print(
        '[ChatScreen] User ID: ${widget.userId}, Current User ID: ${widget.currentUserId}');
    user2 = types.User(
      id: widget.userId.toString(),
      firstName: widget.chatTitle,
      imageUrl: widget.avatarUrl,
    );
    user1 = types.User(id: widget.currentUserId.toString());
  }

  Future<flutter_chat_core.User?> _resolveUser(String userId) async {
    return flutter_chat_core.User(
      id: widget.userId.toString(),
      name: widget.chatTitle,
      imageSource: widget.avatarUrl,
    );
  }

  Future<void> _loadMore() async {
    if (!_hasMore || _isLoading) return;
    _isLoading = true;

    final response = await chatRepository.getMessagesListPagination(
        widget.chatUuid, _currentPage);
    print('[ChatScreen] Loaded page $_currentPage: ${response.data}');

    final parsed = FetchMessagesResponse.fromJson(response.data);
    final List<NewChatMessage> newChatMessages = parsed.messages!.data ?? [];

    if (newChatMessages.isEmpty) {
      _hasMore = false;
      _isLoading = false;
      return;
    }
    final List<flutter_chat_core.TextMessage> chatMessages =
        newChatMessages.map((msg) => msg.toTypesMessage()).toList();

    await _chatController.insertAllMessages(chatMessages, index: 0);
    _currentPage = _currentPage + 1;
    _isLoading = false;
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        currentUser: user1,
        wsDomain: widget.wsDomain,
        chatController: _chatController,
        chatUuid: widget.chatUuid,
      )..add(ChatInitEvent(chatUuid: widget.chatUuid)),
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
            } else if (state is ChatError) {
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
            } else if (state is ChatLoaded) {
              _chatController.setMessages(state.messages);
              return Column(
                children: [
                  buildAppBar(context),
                  Expanded(
                    child: Directionality(
                      textDirection: TextDirection.ltr,
                      child: Chat(
                        theme: flutter_chat_core.ChatTheme.fromThemeData(
                            Theme.of(context)),
                        builders: flutter_chat_core.Builders(
                          chatAnimatedListBuilder: (context, itemBuilder) {
                            return ChatAnimatedList(
                              itemBuilder: itemBuilder,

                              onEndReached: _loadMore,
                            );
                          },
                          textMessageBuilder: (context, message, index) {
                            final isMine = message.authorId == widget.currentUserId.toString();
                            // Only customize "other" messages, use default for yours
                            if (!isMine) {
                              return OtherUserMessageBubble(message: message);
                            } else {
                              // You can also provide a custom bubble for your own messages if you want
                              return FlyerChatTextMessage(message: message, index: index); // or your custom
                            }
                          },
                        ),
                        currentUserId: widget.currentUserId.toString(),
                        resolveUser: (userId) => _resolveUser(userId),
                        chatController: _chatController,
                        onMessageSend: (text) {
                          if (text.trim().isNotEmpty) {
                            BlocProvider.of<ChatBloc>(context).add(SendChatMessageEvent(
                              chatUuid: widget.chatUuid,
                              text: text,
                            ));
                          }
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                ),
              );
            }
          },
        );
      }),
    );
  }

  Container buildAppBar(BuildContext context) {
    return Container(
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
              Navigator.of(context)
                  .pushNamed(AppRoutes.profile, arguments: widget.userId);
            },
            child: Container(
              width: 45,
              height: 45,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.background,
                border:
                    Border.all(color: Theme.of(context).colorScheme.background),
              ),
              child: ClipOval(
                child: (widget.avatarUrl != null)
                    ? FittedBox(
                        fit: BoxFit.cover,
                        child: ProfileCacheImage(
                          widget.avatarUrl,
                        ),
                      )
                    : SvgPicture.asset('assets/images/profile/profile2.svg'),
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
                          padding: EdgeInsetsDirectional.only(top: 4),
                          child: Text(
                            'آخرین بازدید',
                            textDirection: TextDirection.ltr,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                    color:
                                        Theme.of(context).colorScheme.surface,
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
                        onPressed: () async {
                          BuildContext profileContext = context;
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return MyConfirmDialog(
                                title: AppLocalizations.of(context)!
                                    .translateNested(
                                        'consultation', 'cancelConsultation'),
                                description: AppLocalizations.of(context)!
                                    .translateNested('consultation',
                                        'deleteConsultationDescription'),
                                cancelText: AppLocalizations.of(context)!
                                    .translateNested('dialog', 'cancel'),
                                confirmText: AppLocalizations.of(context)!
                                    .translateNested('dialog', 'delete'),
                                onCancel: () {
                                  Navigator.pop(context);
                                },
                                onConfirm: () {
                                  BlocProvider.of<ChatBloc>(profileContext).add(
                                      FinishChatEvent(
                                          chatUuid: widget.chatUuid));
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
                        },
                        child: Text(
                          AppLocalizations.of(context)!.translateNested(
                              "consultation", "cancelConsultation"),
                          style:
                              Theme.of(context).textTheme.bodyLarge!.copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                        ),
                      ),
                      SizedBox(width: 16),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: FaIcon(FontAwesomeIcons.lightArrowLeft,
                            size: 20,
                            color: Theme.of(context).colorScheme.onBackground),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSendPressed(String text) {
    if (text.trim().isNotEmpty) {
      BlocProvider.of<ChatBloc>(context).add(SendChatMessageEvent(
        chatUuid: widget.chatUuid,
        text: text,
      ));
    }
  }
}
