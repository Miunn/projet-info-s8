import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uphf_generative_ai/models/chat.dart';
import 'package:uphf_generative_ai/providers/chat_notifier.dart';

class PromptInput extends StatefulWidget {
  const PromptInput({super.key});

  @override
  State<PromptInput> createState() => _PromptInputState();
}

class _PromptInputState extends State<PromptInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: TextInputType.multiline,
      minLines: 1,
      maxLines: 5,
      autofocus: false,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(50),
          borderSide: BorderSide.none,
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.send),
          onPressed: () {
            context.read<ChatProvider>().addChat(Chat(
              message: _controller.text,
              isMe: true,
              sentAt: DateTime.now(),
            ));
            _controller.clear();
          },
        ),
        contentPadding: const EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 20.0),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        hintText: 'Ma question...',
      ),
      controller: _controller,
    );
  }
}