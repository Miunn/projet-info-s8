import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:uphf_generative_ai/models/emoji_text.dart';
import 'package:uphf_generative_ai/providers/chat_notifier.dart';
import 'package:uphf_generative_ai/providers/conversation_notifier.dart';
import 'package:uphf_generative_ai/widgets/prompt_input.dart';
import 'package:uphf_generative_ai/widgets/rename_conv_dialog.dart';

import '../models/chat.dart';
import '../models/conversation.dart';
import '../widgets/chat_bubble.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  final String title = 'Mon UPHF';

  @override
  createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> with SingleTickerProviderStateMixin {
  OverlayEntry? overlayLegalNoticeEntry;  // Overlay affichant la clause de non-responsabilité
  bool displayLoading = false;  // Indique si un message est en cours d'envoi par le chatbot

  final ScrollController _scrollController = ScrollController();

  _scrollToBottom() {
    _scrollController.jumpTo(_scrollController.position.minScrollExtent);
  }

  /// Rendu de l'écran semi-opaque affichant la clause de non-responsabilité
  void createOverlay() {
    overlayLegalNoticeEntry = OverlayEntry(builder: (BuildContext context) {
      return Positioned(
        top: 0.0,
        left: 0.0,
        child: GestureDetector(
          onTap: () {
            removeOverlay();
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.all(20.0),
            color: Colors.black.withOpacity(0.7),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                DefaultTextStyle(
                  style: TextStyle(fontSize: 22.0, color: Colors.white),
                  child: Text(
                    "Avant d'utiliser le chatbot",
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 20.0),
                DefaultTextStyle(
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                  child: Text(
                    "L'UPHF ne peut être tenue pour responsable des textes fournit par le chatbot. Ces textes sont à usage purement informatif, ne peuvent être utilisés comme source officielle et ne sont pas garantis sans erreur.",
                    overflow: TextOverflow.clip,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });

    // Ajout de l'overlay à l'arbre de rendu
    Overlay.of(context).insert(overlayLegalNoticeEntry!);
  }

  void removeOverlay() {
    overlayLegalNoticeEntry?.remove();
    overlayLegalNoticeEntry?.dispose();
    overlayLegalNoticeEntry = null;
  }

  @override
  void initState() {
    super.initState();

    // Crée l'overlay de manière synchronisé
    SchedulerBinding.instance.addPostFrameCallback((_) {
      createOverlay();
    });
  }

  @override
  void dispose() {
    removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ConversationProvider conversationProvider =
        context.watch<ConversationProvider>();

    // Défilement automatique vers le bas à la création de la page
    if (_scrollController.hasClients) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }

    return DefaultTabController(
      length: conversationProvider.conversations.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Text(
            widget.title,
          ),

          actions: [
            Builder(builder: (context) {
              return IconButton(
                  onPressed: () async {
                    ConversationProvider conversationProvider =
                        context.read<ConversationProvider>();
                    Conversation convToUpdate = conversationProvider
                        .conversations[DefaultTabController.of(context).index];

                    // Affiche la boîte de dialogue pour renommer la conversation
                    // Récupère le nouveau nom lorsque le dialogue est fermé
                    String? newName = await showDialog<String?>(
                        context: context,
                        builder: (BuildContext context) {
                          return const RenameConvDialog();
                        });

                    // Aucun nouveau nom n'a été fourni
                    if (newName == null) {
                      return;
                    }

                    // Mise à jour de la conversation avec le nouveau nom
                    conversationProvider.updateConversation(Conversation(
                      id: convToUpdate.id,
                      name: newName,
                    ));
                  },
                  icon: const Icon(Icons.edit));
            }),
            Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.delete_forever),
                onPressed: () {
                  ConversationProvider conversationProvider =
                      context.read<ConversationProvider>();
                  Conversation convToDelete = conversationProvider
                      .conversations[DefaultTabController.of(context).index];
                  conversationProvider.deleteConversation(convToDelete.id ?? 0);
                },
              );
            }),
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  await conversationProvider.addConversation(Conversation(
                    name: 'Nouvelle conversation',
                  ));

                  // Mise à jour de l'état de l'interface avec la nouvelle conversation
                  setState(() {});
                }),
          ],
          bottom: TabBar(
            isScrollable: false,
            tabs: [
              for (Conversation conversation
                  in conversationProvider.conversations)
                Tab(
                    text:
                        "${EmojiList.list[Random().nextInt(EmojiList.listLength)]} ${conversation.name ?? 'Conversation'}"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            for (Conversation conversation
                in conversationProvider.conversations)
              Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 0.0, 12.0, 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Consumer<ChatProvider>(builder: (BuildContext context,
                        ChatProvider chatProvider, Widget? child) {
                      if (chatProvider
                              .chatsByConversation[conversation.id ?? "0"] ==
                          null) {
                        return const Center(
                          child: null,
                        );
                      }

                      // Liste des messages de la conversation
                      return Expanded(
                        child: ListView(
                            controller: _scrollController,
                            reverse: true,
                            children: [
                              ...chatProvider
                                  .chatsByConversation[conversation.id ?? "0"]!
                                  .map<Widget>((Chat chat) {
                                return ChatBubble(chat: chat);
                              }),
                              Visibility(
                                visible: displayLoading,
                                child: ChatBubble(
                                  chat: Chat(message: "", isMe: false),
                                  loading: true,
                                ),
                              )
                            ].reversed.toList()),
                      );
                    }),

                    // Barre de saisie pour envoyer un message
                    PromptInput(
                      conversationId: conversation.id ?? 0,
                      sendCallback: (Chat chat) {
                        setState(() {
                          displayLoading = true;
                        });
                      },
                      receiveCallback: (Chat? chat) async {
                        if (chat != null) {
                          await context.read<ChatProvider>().addChat(chat);
                        }
                        setState(() {
                          displayLoading = false;
                        });
                      },
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
