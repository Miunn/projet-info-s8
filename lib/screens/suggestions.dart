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
  bool loading = false;
  List<Suggestion> suggestions = [];
  final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm');

  @override
  void initState() {
    super.initState();
    loadSuggestions();
  }

  loadSuggestions() async {
    loading = true;
    List<Suggestion> suggestions =
        await SuggestionsAPIInterface.getSuggestions();
    suggestions.sort((a, b) => b.createdAt!.compareTo(a.createdAt!));
    loading = false;
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: (loading)
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                      itemCount: suggestions.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card.filled(
                          child: ListTile(
                            title: Text(suggestions[index].message ?? ""),
                            subtitle: Row(
                              children: [
                                Text(formatter.format(
                                    suggestions[index].createdAt ??
                                        DateTime.now())),
                                const SizedBox(width: 8.0),
                                Text(suggestions[index].user ?? ""),
                              ],
                            ),
                            trailing: (suggestions[index].upVoted ?? false)
                                ? IconButton(
                                    icon: Icon(Icons.star, color: Colors.yellow[700],),
                                    onPressed: () async {
                                      await SuggestionsAPIInterface.downvoteSuggestion(suggestions[index]);
                                      loadSuggestions();
                                    },
                                  )
                                : IconButton(
                              icon: const Icon(Icons.star_outline),
                              onPressed: () async {
                                await SuggestionsAPIInterface.upvoteSuggestion(suggestions[index]);
                                loadSuggestions();
                              },
                            ),
                          ),
                        );
                      },
                      physics: const AlwaysScrollableScrollPhysics(),
                    ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                GlobalKey<FormState> formKey = GlobalKey<FormState>();
                Suggestion suggestion = Suggestion(
                  message: "",
                  user: "",
                  createdAt: DateTime.now(),
                );
                return AlertDialog(
                  title: const Text("Ajouter une suggestion"),
                  content: Form(
                    key: formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextFormField(
                          minLines: 1,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: "Votre suggestion",
                          ),
                          onChanged: (String value) {
                            suggestion.message = value;
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer une suggestion";
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          decoration: const InputDecoration(
                            hintText: "Votre nom",
                          ),
                          onChanged: (String value) {
                            suggestion.user = value;
                          },
                          validator: (String? value) {
                            if (value == null || value.isEmpty) {
                              return "Veuillez entrer votre nom";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Annuler"),
                    ),
                    TextButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate() == false) {
                          return;
                        }

                        await SuggestionsAPIInterface.addSuggestion(suggestion);
                        loadSuggestions();
                        if (context.mounted) {
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text("Envoyer"),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.contact_support_outlined),
      ),
    );
  }
}