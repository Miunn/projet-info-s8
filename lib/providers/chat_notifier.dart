import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:uphf_generative_ai/utils/chat_db_interface.dart';

import '../models/chat.dart';

class ChatProvider extends ChangeNotifier {
  // Interface de la base de données des messages
  final ChatDatabaseInterface _chatDBInterface = ChatDatabaseInterface.instance;

  List<Chat> _chats = [];     // Liste des messages
  Map<int, List<Chat>> _chatsByConversation = {}; // Messages regroupés par conversation

  List<Chat> get chats => _chats;
  Map<int, List<Chat>> get chatsByConversation => _chatsByConversation;

  ChatProvider() {
    loadChats();
  }

  // Récupère un message par son identifiant
  Chat? getChatById(int id) {
    return _chats.firstWhereOrNull((chat) => chat.id == id);
  }

  // Récupère tous les messages
  Future<void> loadChats() async {
    _chats = await _chatDBInterface.chats;

    _chatsByConversation.clear();
    for (Chat chat in _chats) {
      if (chat.conversationId == null) {
        continue;
      }

      if (!_chatsByConversation.containsKey(chat.conversationId!)) {
        _chatsByConversation[chat.conversationId!] = [];
      }

      _chatsByConversation[chat.conversationId!]!.add(chat);
    }

    notifyListeners();
  }

  Future<void> addChat(Chat chat) async {
    await _chatDBInterface.insertChat(chat);
    loadChats();
  }

  Future<void> toggleLikeChat(Chat chat) async {
    chat.ratedGood = !(chat.ratedGood ?? false);

    if (chat.ratedGood == true) {
      chat.ratedBad = false;
    }

    await _chatDBInterface.updateChat(chat);
    loadChats();
  }

  Future<void> toggleDislikeChat(Chat chat) async {
    chat.ratedBad = !(chat.ratedBad ?? false);

    if (chat.ratedBad == true) {
      chat.ratedGood = false;
    }

    await _chatDBInterface.updateChat(chat);
    loadChats();
  }
}