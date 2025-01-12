import 'dart:ui';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../widgets/custom_snackbar.dart';
import '../post_detailed_bloc.dart';

class CommentBottomSheet extends StatefulWidget {
  final Function function;
  final String postId;
  final String? replyTo;

  const CommentBottomSheet({required this.function, required this.postId, this.replyTo});

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _longTextController = TextEditingController();
  final int _maxLength = 1000;
  int _currentLength = 0;
  bool _showEmojiPicker = false;
  double _keyboardHeight = 250;

  void _toggleEmojiPicker() {
    setState(() {
      _showEmojiPicker = !_showEmojiPicker;

      if (_showEmojiPicker) {
        // Close the keyboard when opening emoji picker
        FocusScope.of(context).unfocus();

        // Ensure fallback height if keyboard height is 0
        if (_keyboardHeight == 0) {
          _keyboardHeight = 250; // Fallback to default
        }
      } else {
        // Open the keyboard when closing emoji picker
        FocusScope.of(context).requestFocus();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_showEmojiPicker) {
          setState(() {
            _showEmojiPicker = false;
          });
          return false; // Prevent closing the dialog
        }
        return true; // Allow default back button behavior
      },
      child: BlocListener<PostDetailedBloc, PostDetailedState>(
        listener: (context, state) {
          if (state is CommentCreated) {
            Navigator.of(context).pop();
          } else if (state is CommentFailure) {
            print(state.error);
            ScaffoldMessenger.of(context).showSnackBar(
              CustomSnackBar(
                content: AppLocalizations.of(context)!.translateNested(
                  "error",
                  "commentError",
                ),
              ).build(context),
            );
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.all(16),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: 170.0,
                        padding: EdgeInsetsDirectional.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              reverse: true,
                              child: ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: 130.0,
                                ),
                                child: TextFormField(
                                  scrollController: ScrollController(),
                                  scrollPhysics: BouncingScrollPhysics(),
                                  controller: _longTextController,
                                  maxLength: _maxLength,
                                  minLines: 1,
                                  maxLines: null,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    color: Theme.of(context).colorScheme.shadow,
                                  ),
                                  decoration: InputDecoration(

                                    suffixIcon: IconButton(
                                      padding: EdgeInsets.zero,
                                      alignment: AlignmentDirectional.centerEnd,
                                      icon: Icon(
                                        _showEmojiPicker
                                            ? Icons.keyboard
                                            : Icons.emoji_emotions_outlined,
                                      ),
                                      onPressed: _toggleEmojiPicker,
                                    ),
                                    hintText: AppLocalizations.of(context)!
                                        .translateNested(
                                        "postScreen", "comment_text"),
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge!
                                        .copyWith(
                                      fontWeight: FontWeight.w400,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .shadow,
                                    ),
                                    alignLabelWithHint: true,
                                    constraints: BoxConstraints(
                                      minHeight: 120.0,
                                    ),
                                    contentPadding: null,
                                    counterText: '',
                                    border: InputBorder.none,
                                  ),
                                  onChanged: (value) {
                                    setState(() {
                                      _currentLength = value.length;
                                    });
                                  },
                                  onTap: () {
                                    if (_showEmojiPicker) {
                                      setState(() {
                                        _longTextController.selection = TextSelection.fromPosition(
                                          TextPosition(offset: _longTextController.text.length),

                                        );
                                        _showEmojiPicker = false;

                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: Text(
                                '$_maxLength/$_currentLength',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        height: _showEmojiPicker ? _keyboardHeight : 0,
                        child: _showEmojiPicker ? _buildEmojiPicker() : null,
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: BlocBuilder<PostDetailedBloc, PostDetailedState>(
                          builder: (context, state) {
                            return ElevatedButton(
                              onPressed: () {
                                if (_longTextController.text.isNotEmpty &&
                                    state is! CreatingComment) {
                                  widget.function(widget.postId,
                                      _longTextController.text, widget.replyTo);
                                  _longTextController.clear();
                                  FocusScope.of(context).unfocus();
                                }
                              },
                              child: (state is CreatingComment)
                                  ? SizedBox(
                                height: 23,
                                width: 23,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Theme.of(context).primaryColor,
                                ),
                              )
                                  : Text(
                                AppLocalizations.of(context)!.translateNested(
                                    "postScreen", "send"),
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge!
                                    .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                shadowColor: Colors.transparent,
                                splashFactory: NoSplash.splashFactory,
                                overlayColor: Colors.transparent,
                                surfaceTintColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                backgroundColor: Theme.of(context)
                                    .colorScheme
                                    .background,
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16),
                      SizedBox(
                        height: 50,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            AppLocalizations.of(context)!
                                .translateNested("auth", "close"),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.error,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            shadowColor: Colors.transparent,
                            splashFactory: NoSplash.splashFactory,
                            overlayColor: Colors.transparent,
                            surfaceTintColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            backgroundColor: Theme.of(context).colorScheme.background,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return Padding(
      padding: const EdgeInsetsDirectional.only(top: 8),
      child: ClipRect(
        child: SizedBox(
          height: _keyboardHeight,
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              final cursorPos = _longTextController.selection;

              final newText = _longTextController.text.replaceRange(
                cursorPos.start,
                cursorPos.end,
                emoji.emoji,
              );

              setState(() {
                _longTextController.text = newText;

                // Move the cursor to the right after the inserted emoji
                _longTextController.selection = TextSelection.collapsed(
                  offset: cursorPos.start + emoji.emoji.length,
                );

                // Update the current length
                _currentLength = _longTextController.text.length;
              });
            },
            config: Config(
              height: 250,
              checkPlatformCompatibility: true,
              categoryViewConfig: CategoryViewConfig(
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
              emojiViewConfig: EmojiViewConfig(),
              bottomActionBarConfig: BottomActionBarConfig(
                enabled: false,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
