import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uphf_generative_ai/providers/chat_notifier.dart';
import 'package:uphf_generative_ai/widgets/prompt_input.dart';

import '../models/chat.dart';
import '../widgets/chat_bubble.dart';

class ChatBot extends StatefulWidget {
   const ChatBot({super.key});

  @override
  createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Consumer<ChatProvider>(
                builder: (BuildContext context, ChatProvider chatProvider, Widget? child) {
                  return Column(
                    children: chatProvider.chats.map<ChatBubble>((Chat chat) {
                      if (chat.message == null || chat.message!.isEmpty) {
                        return const ChatBubble(
                          text: '...',
                          isMe: false,
                        );
                      }
                      return ChatBubble(
                        text: chat.message!,
                        isMe: chat.isMe ?? false,
                      );
                    }).toList(),
                  );
                },
              ),
            ),
            PromptInput(),
          ],
        ),
      ),
    );
  }
}