import 'package:flutter/material.dart';

class Suggestions extends StatefulWidget {
  const Suggestions({super.key});

  @override
  createState() => _SuggestionsState();
}

class _SuggestionsState extends State<Suggestions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Suggestions'),
      ),
      body: const Center(
        child: Text('Suggestions'),
      ),
    );
  }
}
