import 'package:flutter/material.dart';

class PluginCard extends StatelessWidget {
  const PluginCard({
    super.key,
    required this.title,
    required this.channel,
    required this.author,
    required this.icon,
    required this.description,
    required this.type,
    required this.action,
    required this.open,
  });

  final String title;
  final String channel;
  final String author;
  final Widget icon;
  final String description;
  final String type;
  final String action;
  final VoidCallback? open;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.titleMedium?.fontSize,
                          fontFamily: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                          fontWeight: FontWeight.bold,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        '通道: $channel',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                      Text(
                        '作者: $author',
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.bodySmall?.fontSize,
                          fontFamily:
                              Theme.of(context).textTheme.bodySmall?.fontFamily,
                          height: Theme.of(context).textTheme.bodySmall?.height,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: icon,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.start,
              style: Theme.of(context).textTheme.bodySmall?.apply(
                    overflow: TextOverflow.ellipsis,
                  ),
              maxLines: 4,
            ),
            const SizedBox(height: 16),
            const Divider(),
            Row(
              children: [
                Expanded(
                  child: Text(
                    type,
                    textAlign: TextAlign.start,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                TextButton(
                  onPressed: open,
                  child: Text(action),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
