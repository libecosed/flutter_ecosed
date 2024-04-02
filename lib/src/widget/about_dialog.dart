import 'package:flutter/material.dart';

class AboutDialog extends StatelessWidget {
  const AboutDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('关于'),
      content: const Text('flutter_about'),
      actions: <Widget>[
        TextButton(
          child: const Text('确认'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
