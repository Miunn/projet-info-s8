import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uphf_generative_ai/providers/chat_notifier.dart';
import 'package:uphf_generative_ai/providers/conversation_notifier.dart';
import 'package:uphf_generative_ai/widgets/prompt_input.dart';
import 'package:uphf_generative_ai/widgets/rename_conv_dialog.dart';

import '../models/chat.dart';
import '../models/conversation.dart';
import '../widgets/chat_bubble.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  final String title = 'Mon assistant UPHF';

  @override
  createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ConversationProvider conversationProvider =
        context.watch<ConversationProvider>();

    return DefaultTabController(
      length: conversationProvider.conversations.length,
      child: Scaffold(
        appBar: AppBar(
          // TRY THIS: Try changing the color here to a specific color (to
          // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
          // change color while the other colors stay the same.
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),

          actions: [
            Builder(
              builder: (context) {
                return IconButton(
                    onPressed: () async {
                      ConversationProvider conversationProvider = context.read<ConversationProvider>();
                      Conversation convToUpdate = conversationProvider.conversations[DefaultTabController.of(context).index];

                      String? newName = await showDialog<String?>(context: context, builder: (BuildContext context) {
                        return const RenameConvDialog();
                      });

                      if (newName == null) {
                        return;
                      }

                      conversationProvider.updateConversation(Conversation(
                        id: convToUpdate.id,
                        name: newName,
                      ));
                    },
                    icon: const Icon(Icons.edit)
                );
              }
            ),
            Builder(
              builder: (context) {
                return IconButton(
                  icon: const Icon(Icons.delete_forever),
                  onPressed: () {
                    ConversationProvider conversationProvider = context.read<ConversationProvider>();
                    Conversation convToDelete = conversationProvider.conversations[DefaultTabController.of(context).index];
                    conversationProvider.deleteConversation(convToDelete.id ?? 0);
                  },
                );
              }
            ),
            IconButton(icon: const Icon(Icons.add), onPressed: () {
              conversationProvider.addConversation(Conversation(
                name: 'Nouvelle conversation',
              ));
            }),
          ],

          bottom: TabBar(
            isScrollable: false,
            tabs: [
              for (Conversation conversation
                  in conversationProvider.conversations)
                Tab(text: conversation.name ?? 'Conversation'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (Conversation conversation in conversationProvider.conversations)
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: Consumer<ChatProvider>(
                      builder: (BuildContext context, ChatProvider chatProvider,
                          Widget? child) {

                        if (chatProvider.chatsByConversation[conversation.id ?? "0"] == null) {
                          return const Center(
                            child: null,
                          );
                        }

                        return Column(
                          children:
                              chatProvider.chatsByConversation[conversation.id ?? "0"]!.map<ChatBubble>((Chat chat) {
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
                  PromptInput(
                    conversationId: conversation.id ?? 0,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
