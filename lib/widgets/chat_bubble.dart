import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:uphf_generative_ai/providers/chat_notifier.dart';

import '../models/chat.dart';
import 'circle_avatar.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.chat, this.loading = false});

  final Chat chat;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    TextStyle defaultBubbleTextStyle = TextStyle(
      color: (chat.isMe ?? false)
          ? Colors.white
          : Colors.black,
    );

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: (chat.isMe ?? false)
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!(chat.isMe ?? false))
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: Avatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/robot.png')),
                ),
              const SizedBox(width: 10),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: (chat.isMe ?? false)
                      ? Colors.blue[400]
                      : Colors.grey[200],
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular((chat.isMe ?? false) ? 20 : 0),
                    topRight: Radius.circular((chat.isMe ?? false) ? 0 : 20),
                    bottomLeft: const Radius.circular(20),
                    bottomRight: const Radius.circular(20),
                  ),
                ),
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.5,
                  ),
                  child: (loading)
                      ? LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.black, size: 25.0)
                      : MarkdownBody(
                          data: "${chat.message}",
                          styleSheet: MarkdownStyleSheet(
                            p: defaultBubbleTextStyle,
                            h1: defaultBubbleTextStyle,
                            h2: defaultBubbleTextStyle,
                            h3: defaultBubbleTextStyle,
                            a: defaultBubbleTextStyle,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 10),
              if ((chat.isMe ?? false))
                const SizedBox(
                  width: 30,
                  height: 30,
                  child: Avatar(
                      radius: 20,
                      backgroundImage: AssetImage('assets/images/user.png')),
                ),
            ],
          ),
          Row(
            children: <Widget>[
              Visibility(
                  visible: !(chat.isMe ?? false),
                  child: const SizedBox(
                    width: 45,
                  )),
              Visibility(
                  visible: (!(chat.isMe ?? false) && !loading),
                  child: IconButton(
                      onPressed: () {
                        if (chat.id == null || (chat.isMe ?? false)) {
                          return;
                        }

                        context.read<ChatProvider>().toggleLikeChat(chat);
                      },
                      icon: (chat.ratedGood ?? false)
                          ? const Icon(Icons.thumb_up, color: Colors.green)
                          : const Icon(Icons.thumb_up_outlined))),
              Visibility(
                  visible: (!(chat.isMe ?? false) && !loading),
                  child: IconButton(
                      onPressed: () {
                        if (chat.id == null || (chat.isMe ?? false)) {
                          return;
                        }

                        context.read<ChatProvider>().toggleDislikeChat(chat);
                      },
                      icon: (chat.ratedBad ?? false)
                          ? const Icon(Icons.thumb_down, color: Colors.red)
                          : const Icon(Icons.thumb_down_outlined))),
            ],
          )
        ],
      ),
    );
  }
}
