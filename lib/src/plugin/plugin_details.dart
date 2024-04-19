import 'plugin_type.dart';

final class PluginDetails {
  const PluginDetails({
    required this.channel,
    required this.title,
    required this.description,
    required this.author,
    required this.type,
    required this.initial,
  });

  final String channel;
  final String title;
  final String description;
  final String author;
  final PluginType type;
  final bool initial;

  factory PluginDetails.formJSON({
    required Map<String, dynamic> json,
    required PluginType type,
    required bool initial,
  }) {
    return PluginDetails(
      channel: json['channel'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      type: type,
      initial: initial,
    );
  }
}
