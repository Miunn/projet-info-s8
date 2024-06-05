import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uphf_generative_ai/models/chat.dart';
import 'package:uphf_generative_ai/providers/chat_notifier.dart';
import 'package:uphf_generative_ai/utils/api_interface.dart';

class PromptInput extends StatefulWidget {
  const PromptInput({super.key, required this.conversationId, required this.sendCallback, required this.receiveCallback});

  final int conversationId;
  final void Function(Chat chat) sendCallback;
  final void Function() receiveCallback;

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
            List<Chat> conversation = context.read<ChatProvider>().chatsByConversation[widget.conversationId] ?? [];
            Chat newChat = Chat(
              message: _controller.text,
              isMe: true,
              conversationId: widget.conversationId,
              sentAt: DateTime.now(),
            );
            _controller.clear();
            FocusManager.instance.primaryFocus?.unfocus();

            widget.sendCallback(newChat);
            context.read<ChatProvider>().addChat(newChat);
            APIInterface.instance.askPrompt(newChat, widget.conversationId, conversation).then((Chat? chat) {
              widget.receiveCallback();
              if (chat != null) {
                context.read<ChatProvider>().addChat(chat);
              }
            });
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
