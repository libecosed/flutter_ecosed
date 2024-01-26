import 'type.dart';

class PluginPerson {
  const PluginPerson(
      {required this.channel,
        required this.title,
        required this.description,
        required this.author,
        required this.type,
        required this.initial});

  final String channel;
  final String title;
  final String description;
  final String author;
  final PluginType type;
  final bool initial;

  factory PluginPerson.formJSON(
      Map<String, dynamic> json, PluginType type, bool initial) {
    return PluginPerson(
        channel: json['channel'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        type: type,
        initial: initial);
  }
}