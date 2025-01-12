import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';

class Test extends StatefulWidget {
  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  final TextEditingController _textController = TextEditingController();
  bool _showEmojiPicker = false;
  double _keyboardHeight = 250; // Default keyboard height
  bool isEnglish = true; // Dynamic language flag (English or Farsi)

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
          // Close the emoji picker when back button is pressed
          setState(() {
            _showEmojiPicker = false;
          });
          return false; // Prevent closing the dialog
        }
        return true; // Allow default back button behavior
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Column(
          children: [
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.background,
                child: Center(
                  child: Text(
                    'Chat Messages Here',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            _buildInputBar(context),
            AnimatedContainer(
              duration: Duration(milliseconds: 200),
              height: _showEmojiPicker ? _keyboardHeight : 0,
              child: _showEmojiPicker ? _buildEmojiPicker() : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              _showEmojiPicker ? Icons.keyboard : Icons.emoji_emotions_outlined,
            ),
            onPressed: _toggleEmojiPicker,
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.background,
                borderRadius: BorderRadius.circular(25),
              ),
              child: TextField(
                controller: _textController,
                textInputAction: TextInputAction.newline,
                maxLines: 4, // Show a maximum of 4 lines
                minLines: 1, // Start with 1 line
                scrollPhysics: BouncingScrollPhysics(), // Add smooth scrolling
                textDirection: TextDirection.rtl, // Dynamic text direction
                decoration: InputDecoration(
                  hintText:  'پیام بنویسید...',
                  hintTextDirection: TextDirection.rtl,
                  border: InputBorder.none,
                ),
                onTap: () {
                  if (_showEmojiPicker) {
                    setState(() {
                      _showEmojiPicker = false;
                    });
                  }

                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    setState(() {
                      final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                      if (bottomInset > 0) {
                        _keyboardHeight = bottomInset; // Cache keyboard height
                      }
                    });
                  });
                },
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            color: Theme.of(context).colorScheme.primary,
            onPressed: () {

              print('Message Sent: ${_textController.text}');
              _textController.clear();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmojiPicker() {
    return ClipRect(
      child: SizedBox(
        height: _keyboardHeight, // Match keyboard height
        child: SingleChildScrollView(
          child: EmojiPicker(
            onEmojiSelected: (category, emoji) {
              _textController.text += emoji.emoji;
              _textController.selection = TextSelection.fromPosition(
                TextPosition(offset: _textController.text.length),
              );
            },
            config: Config(
              height: 250,
              checkPlatformCompatibility: true,
              categoryViewConfig: CategoryViewConfig(
                backgroundColor: Theme.of(context).primaryColor,
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
