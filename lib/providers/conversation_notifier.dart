import 'package:flutter/widgets.dart';

import '../models/conversation.dart';
import '../utils/chat_db_interface.dart';

class ConversationProvider extends ChangeNotifier {
  final ChatDatabaseInterface _chatDBInterface = ChatDatabaseInterface.instance;

  List<Conversation> _conversations = [];

  List<Conversation> get conversations => _conversations;

  ConversationProvider() {
    loadConversations();
  }

  Future<void> loadConversations() async {
    _conversations = await _chatDBInterface.conversations;
    notifyListeners();
  }

  Future<void> addConversation(Conversation conversation) async {
    await _chatDBInterface.insertConversation(conversation);
    loadConversations();
  }

  Future<void> updateConversation(Conversation conversation) async {
    await _chatDBInterface.updateConversation(conversation);
    loadConversations();
  }

  Future<void> deleteConversation(int id) async {
    await _chatDBInterface.deleteConversation(id);
    loadConversations();
  }
}