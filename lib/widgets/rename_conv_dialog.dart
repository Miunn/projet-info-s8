import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RenameConvDialog extends StatelessWidget {
  const RenameConvDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();

    return AlertDialog(
      title: const Text('Renommer la conversation'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
          hintText: 'Nouveau nom',
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Annuler'),
          onPressed: () {
            Navigator.of(context).pop(null);
          },
        ),
        TextButton(
          child: const Text('Renommer'),
          onPressed: () {
            Navigator.of(context).pop(controller.text);
          },
        ),
      ],
    );
  }
}