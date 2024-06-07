import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:uphf_generative_ai/models/suggestion.dart';

import 'package:http/http.dart' as http;


class SuggestionsAPIInterface {
  static Future<List<Suggestion>> getSuggestions() async {
    final resp = await http.get(Uri.parse("http://db.projeticy.remicaulier.fr/get/suggestions"));
    debugPrint("Response: ${resp.body}");

    if (resp.statusCode != 200) {
      return [];
    }

    List<dynamic> data = jsonDecode(resp.body) as List<dynamic>;
    return data.map((e) => Suggestion.fromMap(e as Map<String, dynamic>)).toList();
  }

  static Future<void> addSuggestion(Suggestion suggestion) async {
    final resp = await http.post(
        Uri.parse("http://db.projeticy.remicaulier.fr/post/suggestion"),
        body: jsonEncode(suggestion.toMap()),
        headers: {
          'Content-Type': 'application/json',
        }
    );
    debugPrint("Response: ${resp.body}");
  }
}