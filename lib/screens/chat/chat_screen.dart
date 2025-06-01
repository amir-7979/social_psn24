import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_core/flutter_chat_core.dart' as flutter_chat_core;
import 'package:flutter_svg/svg.dart';
import 'package:flyer_chat_text_message/flyer_chat_text_message.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:social_psn/repos/models/chat_models/chat_message.dart';
import '../../configs/localization/app_localizations.dart';
import '../../configs/setting/themes.dart';
import '../../repos/models/chat_models/fetch_messages_response.dart';
import '../../repos/models/consultation_model/consultation.dart';
import '../../repos/repositories/dio/consultation/chat_repository.dart';
import '../../secret.dart';
import '../../services/storage_service.dart';
import '../main/widgets/screen_builder.dart';
import '../widgets/custom_snackbar.dart';
import '../widgets/dialogs/my_confirm_dialog.dart';
import '../widgets/new_page_progress_indicator.dart';
import '../widgets/profile_cached_network_image.dart';
import 'chat_bloc.dart';
import 'widget/composer.dart';
import 'widget/other_message_bubble.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ChatScreen extends StatefulWidget {
  final Consultation consultation;

  const ChatScreen({
    Key? key,
    required this.consultation,
  }) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final ChatRepository chatRepository = ChatRepository();
  int _currentPage = 2;
  bool _hasMore = true;
  bool _isLoading = false;
  final _chatController = flutter_chat_core.InMemoryChatController();
  final StorageService _storageService = StorageService();
  WebSocketChannel? wsChannel;
  StreamSubscription? _wsSubscription;
  late types.User user2;
  late types.User user1;

  @override
  void initState() {
    super.initState();

    textEditingController.addListener(() {
      setState(() {});
    });

    user2 = types.User(
      id: widget.consultation.consultant!.id.toString(),
      firstName: widget.consultation.consultant!.name,
      imageUrl: widget.consultation.consultant!.avatar,
    );
    user1 = types.User(id: widget.consultation.user!.id.toString());
    Future.delayed(Duration.zero, () async {
      await _connectAndListenWebSocket();
    });

  }

  List<flutter_chat_core.Message> insertDateSeparators(List<flutter_chat_core.Message> messages) {
    final List<flutter_chat_core.Message> result = [];
    Jalali? previousDate;

    for (final flutter_chat_core.Message message in messages) {
      final jalali = message.metadata?['jalaliDate'];

      if (jalali != null && jalali is Jalali) {
        if (previousDate == null || !_isSameJalaliDay(previousDate, jalali)) {
          result.add(flutter_chat_core.CustomMessage(
            id: 'separator_${jalali.toString()}',
            authorId: messages.first.authorId,
            createdAt: message.createdAt,
            metadata: {
              'type': 'date-separator',
              'jalali': jalali,
              'formatted': message.metadata?['formattedCreatedAt'],
            },
          ));
          previousDate = jalali;
        }
      }

      result.add(message);
    }

    return result;
  }

  bool _isSameJalaliDay(Jalali a, Jalali b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _connectAndListenWebSocket() async {
    final token = await _storageService.readData('token');
    final wsDomainWithParams = '${widget.consultation.chatInfo!.wsDomain}?token=$token&service-token=$Secret2';
    wsChannel = WebSocketChannel.connect(Uri.parse(wsDomainWithParams));
    print('[ChatBloc] WebSocket connecting to: $wsDomainWithParams');
    _wsSubscription = wsChannel!.stream.listen(
          (data) {
        print('[ChatBloc] WebSocket DATA: $data');
        try {
          final decoded = data is String ? data : data.toString();
          final eventData = jsonDecode(decoded);
          print('[ChatBloc] WebSocket JSON: $eventData');

          if (eventData != null && eventData['event'] == 'message.new') {
            final messageData = eventData['data'];

            if (messageData != null) {
              final newMessage = NewChatMessage.fromJson(messageData);
              final chatMessage = newMessage.toTypesMessage();
              print('[ChatBloc] New message received: $chatMessage');
              /*if(chatMessage.authorId == widget.consultation.user!.id){
                return;
              }*/
              setState(() {
                _chatController.insertMessage(chatMessage, index: 0);
              });
            }
          }
        } catch (err) {
          print('[ChatBloc] WebSocket JSON parse error: $err');
        }
      },
      onError: (error, [stackTrace]) {
        print('[ChatBloc] WebSocket STREAM ERROR: $error');
      },
      onDone: () {
        print('[ChatBloc] WebSocket connection closed');
      },
      cancelOnError: true,
    );
  }


  Future<flutter_chat_core.User?> _resolveUser(String userId) async {
    return flutter_chat_core.User(
      id: widget.consultation.consultant!.id.toString(),
      name: widget.consultation.consultant!.name,
      imageSource: widget.consultation.consultant!.avatar,
    );
  }

  Future<void> _loadMore() async {

    if (!_hasMore || _isLoading){
      print('[ChatScreen] No more messages to load or already loading.');
      return;
    }
    _isLoading = true;

    final response = await chatRepository.getMessagesListPagination(
        widget.consultation.chatInfo!.uuid!, _currentPage);
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

    final withSeparators = insertDateSeparators(chatMessages);
    _chatController.insertAllMessages(withSeparators, index: 0);
    _chatController.insertAllMessages(chatMessages, index: 0);
    _currentPage = _currentPage + 1;
    _isLoading = false;
    if (parsed.messages!.lastPage == _currentPage) {
      setState(() {
        _hasMore = false;
      });
    }
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
  }

  // 1) This method will be called when user taps the microphone icon
  void _onMicPressed() {
    // e.g. open your voice recorder or handle audio input
    print('[Composer] Mic pressed');
  }

  // 2) This method will be called when user taps the paperclip icon
  void _onAttachPressed() async {
    // e.g. open image_picker or file_picker, then insert an ImageMessage or FileMessage:
    // final result = await FilePicker.platform.pickFiles(type: FileType.any);
    // if (result != null && result.files.single.path != null) {
    //   final path = result.files.single.path!;
    //   final file = File(path);
    //   final message = types.FileMessage(
    //     author: user1,
    //     createdAt: DateTime.now().millisecondsSinceEpoch,
    //     id: DateTime.now().millisecondsSinceEpoch.toString(),
    //     name: result.files.single.name,
    //     size: result.files.single.size,
    //     uri: path,
    //   );
    //   setState(() {
    //     _chatController.insertMessage(message, index: 0);
    //   });
    // }
    print('[Composer] Attach pressed');
  }

  // 3) This method will be called when user taps send arrow
  void _onSendPressed(String text) {
        (text) {
      if (text.trim().isNotEmpty) {
        BlocProvider.of<ChatBloc>(context)
            .add(SendChatMessageEvent(
          chatUuid: widget.consultation.chatInfo!.uuid!,
          text: text,
        ));
        final trimmed = textEditingController.text.trim();
        if (trimmed.isEmpty) return;
        textEditingController.clear();
        setState(() {});
      }
    };
  }

  // 4) This method will be called when user taps the emoji icon
  void _onEmojiPressed() {
    // e.g. open your emoji picker dialog
    print('[Composer] Emoji pressed');
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatBloc(
        currentUser: user1,
        chatUuid: widget.consultation.chatInfo!.uuid!,
      )..add(ChatInitEvent(chatUuid: widget.consultation.chatInfo!.uuid!)),
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
          buildWhen: (previous, current) {
            return current is ChatLoading ||
                current is ChatError ||
                current is ChatLoaded;
          },
          builder: (context, state) {
            if (state is ChatLoading) {
              return NewPageProgressIndicator();

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
                            FetchChatHistoryEvent(
                                chatUuid: widget.consultation.chatInfo!.uuid!));
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
              final withSeparators = insertDateSeparators(state.messages);
              _chatController.insertAllMessages(withSeparators, index: 0);
              return Column(
                children: [
                  buildAppBar(context),
                  Expanded(
                    child: Chat(
                      backgroundColor:
                      Theme.of(context).colorScheme.background,
                      decoration: BoxDecoration(

                        color: Theme.of(context).colorScheme.background,
                        image: const DecorationImage(
                          image: AssetImage('assets/images/chat/chat_background.png'),
                          opacity: 0.1,
                          fit: BoxFit.cover,
                        ),

                      ),
                      theme: flutter_chat_core.ChatTheme.fromThemeData(
                          Theme.of(context)),

                      builders: flutter_chat_core.Builders(
                        customMessageBuilder: (context, message, index) {
                          if (message.metadata?['type'] == 'date-separator') {
                            final formatted = message.metadata?['formatted'] as String? ?? '';

                            return Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onPrimaryContainer
                                      .withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  formatted, // Already localized like "12 خرداد 1403"
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onBackground,
                                    fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            );
                          }

                          return const SizedBox.shrink();
                        },
                        composerBuilder: (context) {
                          return Composer(
                            maxLines: 5,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            padding: EdgeInsetsDirectional.only(bottom: 16),
                            textInputAction: TextInputAction.send,
                            hintText: AppLocalizations.of(context)!
                                .translateNested('consultation', 'writeMessage'),
                            attachmentIconColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            attachmentIcon: FaIcon( FontAwesomeIcons.thinPaperclip,
                                color: Theme.of(context)
                                    .primaryColor),
                            hintColor: Theme.of(context)
                                .hoverColor,
                            sendIconColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            textColor: Theme.of(context)
                                .hoverColor,
                            sendIcon: (textEditingController.value.text.isNotEmpty) ? Directionality(
                              textDirection: TextDirection.rtl,
                              child: FaIcon(FontAwesomeIcons.solidSend,
                                  color: Theme.of(context)
                                      .primaryColor),
                            ): null,
                            inputFillColor: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                            textEditingController: textEditingController,
                            handleSafeArea: true,
                          );
                        },
                        loadMoreBuilder: (context) {
                          return _hasMore ? SizedBox.shrink(): SizedBox.shrink();
                        },

                        chatAnimatedListBuilder: (context, itemBuilder) {
                          return ChatAnimatedList(
                            itemBuilder: itemBuilder,
                            onEndReached: (_hasMore)?_loadMore: null,
                            reversed: true,
                            handleSafeArea: true,
                            physics: const BouncingScrollPhysics(),




                          );
                        },
                        textMessageBuilder: (context, message, index) {
                          return FlyerChatTextMessage(
                            message: message,
                            index: index,
                            showStatus: true,
                            showTime: true,



                            borderRadius: BorderRadius.circular(4),
                            timeAndStatusPosition: flutter_chat_core.TimeAndStatusPosition.start,
                            timeAndStatusPositionInlineInsets:  EdgeInsetsDirectional.zero,
                            padding: EdgeInsetsDirectional.all(10),
                            timeStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(

                              color: Theme.of(context)
                                  .primaryColor,
                              fontWeight: FontWeight.w400,
                            ),
                            receivedBackgroundColor: chatReceive,
                            //i want this primary color with alpha rgba(204, 242, 240, 1)
                            sentBackgroundColor: chatSent.withOpacity(0.8),
                            sentTextStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground,
                              fontWeight: FontWeight.w400,
                            ),
                            receivedTextStyle: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onBackground,
                              fontWeight: FontWeight.w400,
                            ),
                          );
                        },
                      ),
                      currentUserId: widget.consultation.user!.id.toString(),
                      resolveUser: (userId) => _resolveUser(userId),
                      chatController: _chatController,
                      onMessageSend: (text) {
                        if (text.trim().isNotEmpty) {
                          BlocProvider.of<ChatBloc>(context)
                              .add(SendChatMessageEvent(
                            chatUuid: widget.consultation.chatInfo!.uuid!,
                            text: text,
                          ));
                        }
                      },
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
              Navigator.of(context).pushNamed(AppRoutes.profile,
                  arguments: widget.consultation.user!.id);
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
                child: (widget.consultation.user!.avatar != null)
                    ? FittedBox(
                  fit: BoxFit.cover,
                  child: ProfileCacheImage(
                    widget.consultation.user!.avatar,
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
                            widget.consultation.consultant!.name!,
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
                      if (widget.consultation.status == "processing")
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
                                    _handleFinishPressed(profileContext, context);
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

  void _handleFinishPressed(BuildContext profileContext, BuildContext context) {

    BlocProvider.of<ChatBloc>(profileContext)
        .add(FinishChatEvent(
        chatUuid: widget
            .consultation.chatInfo!.uuid!));
    Navigator.pop(context);

  }

}