import 'plugin_type.dart';

final class PluginDetails {
  const PluginDetails({
    required this.channel,
    required this.title,
    required this.description,
    required this.author,
    required this.type,
  });

  final String channel;
  final String title;
  final String description;
  final String author;
  final PluginType type;

  factory PluginDetails.formJSON({
    required Map<String, dynamic> json,
    required PluginType type,
  }) {
    return PluginDetails(
      channel: json['channel'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      type: type,
    );
  }
}
