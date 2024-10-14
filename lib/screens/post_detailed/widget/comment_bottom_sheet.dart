import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../configs/localization/app_localizations.dart';
import '../../widgets/custom_snackbar.dart';
import '../../widgets/new_page_progress_indicator.dart';
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostDetailedBloc, PostDetailedState>(
      listener: (context, state) {
        if (state is CommentCreated) {
          Navigator.of(context).pop();
        } else if (state is CommentFailure) {
          ScaffoldMessenger.of(context).showSnackBar(CustomSnackBar(
              content: AppLocalizations.of(context)!.translateNested(
                "error",
                "commentError",
              )).build(context));
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
                // Add padding equal to the height of the keyboard
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
                                  hintText: AppLocalizations.of(context)!
                                      .translateNested(
                                      "postScreen", "comment_text"),
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(
                                    fontWeight: FontWeight.w400,
                                    color: Theme.of(context).colorScheme.shadow,
                                  ),
                                  alignLabelWithHint: true,
                                  constraints: BoxConstraints(
                                    minHeight: 120.0,
                                  ),
                                  contentPadding: null,
                                  counterText: '',
                                  border: InputBorder.none, // Add this line
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _currentLength = value.length;
                                  });
                                },
                                onFieldSubmitted: (value) {
                                  FocusScope.of(context).unfocus();
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
                    SizedBox(height: 16),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: BlocBuilder<PostDetailedBloc, PostDetailedState>(
                        builder: (context, state) {
                          return ElevatedButton(
                            onPressed: () {
                              if (_longTextController.text.isNotEmpty && state is! CreatingComment) {
                                widget.function(widget.postId,
                                    _longTextController.text,
                                    widget.replyTo);
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
                              AppLocalizations.of(context)!
                                  .translateNested("postScreen", "send"),
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
                                  .background, // background color
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
                          style:
                          Theme.of(context).textTheme.titleLarge!.copyWith(
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
                          backgroundColor: Theme.of(context)
                              .colorScheme
                              .background, // background color
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
    );
  }
}
