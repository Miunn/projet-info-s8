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
    /*final resp = await http.get(Uri.parse('http://192.168.209.157:8000/ask?prompt=$payload'));
    debugPrint("Response: ${resp.body}");
    if (resp.statusCode != 200) {
      return null;
    }

    Map<String, dynamic> data = jsonDecode(resp.body) as Map<String, dynamic>;
    return Chat(
      conversationId: conversationId,
      isMe: false,
      message: data['message'] as String,
      sentAt: DateTime.now(),
    );*/

    await Future.delayed(const Duration(seconds: 2));

    return Chat(
      conversationId: conversationId,
      isMe: false,
      message: "Test",
      sentAt: DateTime.now(),
    );
  }
}