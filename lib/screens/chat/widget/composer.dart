import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_core/flutter_chat_core.dart'; // For ChatTheme
import 'package:flutter_chat_ui/flutter_chat_ui.dart'; // For ComposerHeightNotifier & other context items
import 'package:provider/provider.dart';

/// A custom message composer widget positioned at the bottom of the chat screen.
///
/// Includes a text input field, an optional attachment button, and a send button.
/// Modified to accept custom TextStyles for input and hint text,
/// and direct callbacks for sending messages and handling attachments.
class MyCustomComposer extends StatefulWidget {
  // ... (all existing properties from your previous version like textEditingController, styles, etc.)
  final TextEditingController? textEditingController;
  final double? left;
  final double? right;
  final double? top;
  final double? bottom;
  final double? sigmaX;
  final double? sigmaY;
  final EdgeInsetsGeometry? padding;
  final Widget? attachmentIcon;
  final Widget? sendIcon;
  final double? gap;
  final InputBorder? inputBorder;
  final bool? filled;
  final Widget? topWidget;
  final bool? handleSafeArea;
  final Color? backgroundColor;
  final Color? attachmentIconColor;
  final Color? sendIconColor;
  final Color? hintColor;
  final Color? textColor;
  final Color? inputFillColor;
  final String? hintText;
  final Brightness? keyboardAppearance;
  final bool? autocorrect;
  final bool autofocus;
  final TextCapitalization textCapitalization;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final int? maxLength;
  final int? minLines;
  final int? maxLines;
  final TextStyle? customInputTextStyle;
  final TextStyle? customHintStyle;

  // New direct callback arguments
  /// Callback for when the send button is pressed or text is submitted.
  final void Function(String text)? onSendPressed;
  /// Callback for when the attachment button is pressed.
  final void Function()? onAttachmentPressed;

  const MyCustomComposer({
    super.key,
    this.textEditingController,
    this.left = 0,
    this.right = 0,
    this.top,
    this.bottom = 0,
    this.sigmaX = 20,
    this.sigmaY = 20,
    this.padding = const EdgeInsets.all(8.0),
    this.attachmentIcon = const Icon(Icons.attachment),
    this.sendIcon = const Icon(Icons.send),
    this.gap = 8,
    this.inputBorder = const OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(24)),
    ),
    this.filled = true,
    this.topWidget,
    this.handleSafeArea = true,
    this.backgroundColor,
    this.attachmentIconColor,
    this.sendIconColor,
    this.hintColor,
    this.textColor,
    this.inputFillColor,
    this.hintText = 'Type a message',
    this.keyboardAppearance,
    this.autocorrect,
    this.autofocus = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.keyboardType,
    this.textInputAction = TextInputAction.newline,
    this.focusNode,
    this.maxLength,
    this.minLines = 1,
    this.maxLines = 3,
    this.customInputTextStyle,
    this.customHintStyle,
    // Add new callback parameters to the constructor
    this.onSendPressed,
    this.onAttachmentPressed,
  });

  @override
  State<MyCustomComposer> createState() => _MyCustomComposerState();
}

class _MyCustomComposerState extends State<MyCustomComposer> {
  final _key = GlobalKey();
  late final TextEditingController _textController;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _textController = widget.textEditingController ?? TextEditingController();
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.onKeyEvent = _handleKeyEvent;
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  KeyEventResult _handleKeyEvent(FocusNode node, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.enter &&
        HardwareKeyboard.instance.isShiftPressed) {
      _handleSubmitted(_textController.text);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void didUpdateWidget(covariant MyCustomComposer oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance.addPostFrameCallback((_) => _measure());
  }

  @override
  void dispose() {
    if (widget.textEditingController == null) {
      _textController.dispose();
    }
    if (widget.focusNode == null) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomSafeArea =
    widget.handleSafeArea == true ? MediaQuery.of(context).padding.bottom : 0.0;
    final theme = context.watch<ChatTheme>();
    // No longer reading onAttachmentTap from context for the button's primary action

    final TextStyle finalInputTextStyle = widget.customInputTextStyle ??
        theme.typography.bodyMedium.copyWith(
          color: widget.textColor ?? theme.colors.onSurface,
        );

    final TextStyle finalHintTextStyle = widget.customHintStyle ??
        theme.typography.bodyLarge.copyWith(
          color: widget.hintColor ?? theme.colors.onSurface.withValues(alpha: 0.5),
        );

    return Positioned(
      left: widget.left,
      right: widget.right,
      top: widget.top,
      bottom: widget.bottom,
      child: ClipRect(
        child: Container(
          key: _key,
          color: widget.backgroundColor ?? theme.colors.surfaceContainerLow,
          child: Column(
            children: [
              if (widget.topWidget != null) widget.topWidget!,
              Padding(
                padding: widget.handleSafeArea == true
                    ? (widget.padding?.add(
                  EdgeInsets.only(bottom: bottomSafeArea),
                ) ??
                    EdgeInsets.only(bottom: bottomSafeArea))
                    : (widget.padding ?? EdgeInsets.zero),
                child: Row(
                  children: [
                    // Use widget.onAttachmentPressed for the IconButton
                    widget.attachmentIcon != null && widget.onAttachmentPressed != null
                        ? IconButton(
                      icon: widget.attachmentIcon!,
                      color: widget.attachmentIconColor ??
                          theme.colors.onSurface.withValues(alpha: 0.5),
                      onPressed: widget.onAttachmentPressed, // Use direct callback
                    )
                        : const SizedBox.shrink(),
                    SizedBox(width: widget.gap),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(
                          hintText: widget.hintText,
                          hintStyle: finalHintTextStyle,
                          border: widget.inputBorder,
                          filled: widget.filled,
                          fillColor: widget.inputFillColor ??
                              theme.colors.surfaceContainerHigh.withValues(
                                alpha: 0.8,
                              ),
                          hoverColor: Colors.transparent,
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                        ),
                        style: finalInputTextStyle,
                        onSubmitted: _handleSubmitted, // This already calls our internal _handleSubmitted
                        textInputAction: widget.textInputAction,
                        keyboardAppearance: widget.keyboardAppearance,
                        autocorrect: widget.autocorrect ?? true,
                        autofocus: widget.autofocus,
                        textCapitalization: widget.textCapitalization,
                        keyboardType: widget.keyboardType,
                        focusNode: _focusNode,
                        maxLength: widget.maxLength,
                        minLines: widget.minLines,
                        maxLines: widget.maxLines,
                      ),
                    ),
                    SizedBox(width: widget.gap),
                    widget.sendIcon != null
                        ? IconButton(
                      icon: widget.sendIcon!,
                      color: widget.sendIconColor ??
                          theme.colors.onSurface.withValues(alpha: 0.5),
                      onPressed: () => _handleSubmitted(_textController.text),
                    )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _measure() {
    if (!mounted) return;
    final renderBox = _key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final height = renderBox.size.height;
      final bottomSafeArea = MediaQuery.of(context).padding.bottom;
      context.read<ComposerHeightNotifier>().setHeight(
        widget.handleSafeArea == true ? height - bottomSafeArea : height,
      );
    }
  }

  void _handleSubmitted(String text) {
    final trimmedText = text.trim(); // Trim the text before checking if it's empty
    if (trimmedText.isNotEmpty) {
      // Use the onSendPressed callback passed as a widget parameter
      widget.onSendPressed?.call(trimmedText);
      _textController.clear();
    }
  }
}