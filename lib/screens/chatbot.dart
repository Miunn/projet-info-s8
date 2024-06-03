import 'package:flutter/material.dart';

import '../widgets/chat_bubble.dart';

class ChatBot extends StatefulWidget {
   const ChatBot({super.key});

  @override
  createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 0.0),
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
    );
  }
}