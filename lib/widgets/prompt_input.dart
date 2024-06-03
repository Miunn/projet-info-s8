import 'package:flutter/material.dart';

class PromptInput extends StatefulWidget {
  const PromptInput({super.key, required this.onSubmitted});

  final ValueChanged<String> onSubmitted;

  @override
  State<PromptInput> createState() => _PromptInputState();
}

class _PromptInputState extends State<PromptInput> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return TextField(
      autofocus: false,
      decoration: InputDecoration(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: BorderSide.none,
      ),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceVariant,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
        ),
        hintText: 'Ma question...',
      ),
      controller: _controller,
      onSubmitted: (String value) {
        widget.onSubmitted(value);
        _controller.clear();
      },
    );
  }
}