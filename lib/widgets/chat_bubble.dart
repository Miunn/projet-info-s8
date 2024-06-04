import 'package:flutter/material.dart';

import 'circle_avatar.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.text, required this.isMe});

  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isMe)
            const SizedBox(
              width: 30,
              height: 30,
              child: Avatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/robot.png')
              ),
            ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isMe ? Colors.blue : Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isMe ? 20 : 0),
                topRight: Radius.circular(isMe ? 0 : 20),
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
              ),
            ),
            child: SizedBox(
              width: 200,
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          if (isMe)
            const SizedBox(
              width: 30,
              height: 30,
              child: Avatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/user.png')
              ),
            ),
        ],
      ),
    );
  }
}