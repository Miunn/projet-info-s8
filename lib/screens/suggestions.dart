import 'dart:core';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uphf_generative_ai/utils/suggestions_api_interface.dart';

import '../models/suggestion.dart';

class SuggestionsScreen extends StatefulWidget {
  const SuggestionsScreen({super.key});

  @override
  createState() => _SuggestionsScreenState();
}

class _SuggestionsScreenState extends State<SuggestionsScreen> {
  List<Suggestion> suggestions = [];
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    loadSuggestions();
  }

  loadSuggestions() async {
    List<Suggestion> suggestions =
        await SuggestionsAPIInterface.getSuggestions();
    suggestions.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));

    setState(() {
      this.suggestions = suggestions;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Suggestions'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          return loadSuggestions();
        },
        child: ListView.builder(
          itemCount: suggestions.length,
          itemBuilder: (BuildContext context, int index) {
            return Card.filled(
              child: ListTile(
                title: Text(suggestions[index].message ?? ""),
                subtitle: Text(
                    "Par ${suggestions[index].user ?? ""} le ${formatter.format(suggestions[index].createdAt ?? DateTime.now())}"),
              ),
            );
          },
          physics: const AlwaysScrollableScrollPhysics(),
        ),
      ),
    );
  }
}
