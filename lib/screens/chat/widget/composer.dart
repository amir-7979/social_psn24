import 'package:flutter/material.dart';

typedef OnSubmitText = void Function(String text);
typedef OnAttachPressed = void Function();
typedef OnMicPressed = void Function();

/// A custom composer that:
///  1. Allows Enter (newline) without sending.
///  2. Hides mic & attach icons once the user starts typing.
///  3. Has no emoji icon (it’s removed entirely).
class CustomComposer extends StatefulWidget {
  /// Called when the user taps the “send” arrow.
  final OnSubmitText onSubmit;

  /// Called when the user taps the paperclip/attachment icon.
  final OnAttachPressed onAttachPressed;

  /// Called when the user taps the microphone icon.
  final OnMicPressed onMicPressed;

  const CustomComposer({
    Key? key,
    required this.onSubmit,
    required this.onAttachPressed,
    required this.onMicPressed,
  }) : super(key: key);

  @override
  State<CustomComposer> createState() => _CustomComposerState();
}

class _CustomComposerState extends State<CustomComposer> {
  final TextEditingController _textController = TextEditingController();
  bool _isComposing = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  /// Called whenever the text field changes.
  /// Enables/disables “send” and hides/shows the other icons.
  void _handleTextChanged(String text) {
    final trimmed = text.trim();
    setState(() {
      _isComposing = trimmed.isNotEmpty;
    });
  }

  /// Called when the user taps the send arrow.
  void _handleSendPressed() {
    final trimmed = _textController.text.trim();
    if (trimmed.isEmpty) return;
    widget.onSubmit(trimmed);
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Light gray background behind the entire row; adjust to match your theme.
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Row(
        children: [
          // 1) Only show mic & attach if NOT composing (i.e. field is empty or whitespace).
          if (!_isComposing) ...[
            IconButton(
              icon: const Icon(Icons.mic_none),
              color: Theme.of(context).primaryColor,
              onPressed: widget.onMicPressed,
              tooltip: 'ضبط صدا', // “Record Voice” in Persian
            ),
            IconButton(
              icon: const Icon(Icons.attach_file),
              color: Theme.of(context).primaryColor,
              onPressed: widget.onAttachPressed,
              tooltip: 'ضمیمه کردن فایل', // “Attach File” in Persian
            ),
          ],

          // 2) Expanded TextField: multi‐line, Enter inserts newline
          Expanded(
            child: TextField(
              controller: _textController,
              textAlign: TextAlign.right, // right‐to‐left alignment for Persian
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 5, // allow up to 5 lines of text before scrolling
              onChanged: _handleTextChanged,
              // NB: NO onSubmitted → Enter simply adds a newline
              style: const TextStyle(fontSize: 16, color: Colors.black87),
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                hintText: 'پیام خود را بنویسید...', // “Write your message...” in Persian
                hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          const SizedBox(width: 8),

          // 3) Send arrow: only enabled/visible when there is actual text (_isComposing)
          IconButton(
            icon: const Icon(Icons.send),
            color: _isComposing
                ? Theme.of(context).primaryColor
                : Colors.grey.shade400,
            onPressed: _isComposing ? _handleSendPressed : null,
            tooltip: 'ارسال پیام', // “Send Message” in Persian
          ),
        ],
      ),
    );
  }
}
