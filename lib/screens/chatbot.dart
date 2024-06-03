import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uphf_generative_ai/widgets/prompt_input.dart';

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
            const SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  ChatBubble(
                    text: 'Bonjour, comment puis-je vous aider ?',
                    isMe: false,
                  ),
                  ChatBubble(
                    text: 'Je voudrais savoir si je peux m\'inscrire à l\'UPHF',
                    isMe: true,
                  ),
                ],
              ),
            ),
            PromptInput(onSubmitted: (String value) {
              debugPrint(value);
            }),
          ],
        ),
      ),
    );
  }
}