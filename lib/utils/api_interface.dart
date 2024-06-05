import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import '../models/chat.dart';

class APIInterface {
  static final APIInterface instance = APIInterface._internal();

  APIInterface._internal();

  Future<Chat?> askPrompt(Chat newChat, int? conversationId, List<Chat> history) async {
    history.add(newChat);
    String payload = json.encode(history.map((e) => e.toApi()).toList());

    debugPrint(payload);
    final resp = await http.get(Uri.parse('https://summary-fresh-katydid.ngrok-free.app/ask?prompt=$payload'), headers: {
      'ngrok-skip-browser-warning': 'true',
    });
    debugPrint("Response: ${resp.body}");
    if (resp.statusCode != 200) {
      return Chat(
        conversationId: conversationId,
        isMe: false,
        message: "Impossible de contacter l'API",
        sentAt: DateTime.now(),
      );
    }

    Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
    return Chat(
      conversationId: conversationId,
      isMe: false,
      message: (data['content'] ?? "Erreur lors de la réponse API") as String,
      sentAt: DateTime.now(),
    );
  }
}