import 'package:flutter/material.dart';

class Plugin extends StatefulWidget {
  const Plugin(
      {super.key,
      required this.title,
      required this.version,
      required this.author,
      required this.description});

  final String title;
  final String version;
  final String author;
  final String description;

  @override
  State<Plugin> createState() => _PluginState();
}

class _PluginState extends State<Plugin> {
  void a() {}

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        child: Card(
          color: Theme.of(context).colorScheme.surface,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.title, textAlign: TextAlign.start),
                        Text('版本:${widget.version}',
                            textAlign: TextAlign.start),
                        Text('作者:${widget.author}', textAlign: TextAlign.start),
                      ],
                    ),
                    const Spacer(flex: 1),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [Switch(value: true, onChanged: (value) {})],
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(widget.description, textAlign: TextAlign.start),
                const SizedBox(height: 16),
                const Divider(),
                Row(
                  children: [
                    const Text('内置模块'),
                    const Spacer(flex: 1),
                    TextButton(onPressed: a, child: const Text('设置')),
                    TextButton(onPressed: a, child: const Text('卸载'))
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
