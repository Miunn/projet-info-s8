import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:uphf_generative_ai/utils/chat_db_interface.dart';

import '../models/chat.dart';

class ChatProvider extends ChangeNotifier {
  final ChatDatabaseInterface _chatDBInterface = ChatDatabaseInterface.instance;

  List<Chat> _chats = [];
  Map<int, List<Chat>> _chatsByConversation = {};

  List<Chat> get chats => _chats;
  Map<int, List<Chat>> get chatsByConversation => _chatsByConversation;

  ChatProvider() {
    loadChats();
  }

  Chat? getChatById(int id) {
    return _chats.firstWhereOrNull((chat) => chat.id == id);
  }

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
    await _chatDBInterface.updateChat(chat);
    loadChats();
  }

  Future<void> toggleDislikeChat(Chat chat) async {
    chat.ratedBad = !(chat.ratedBad ?? false);
    await _chatDBInterface.updateChat(chat);
    loadChats();
  }
}