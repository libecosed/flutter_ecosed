class PluginPerson {
  const PluginPerson(
      {required this.channel,
        required this.title,
        required this.description,
        required this.author,
        required this.version});

  final String channel;
  final String title;
  final String description;
  final String author;
  final String version;

  factory PluginPerson.fromJson(Map<String, dynamic> json) {
    return PluginPerson(
        channel: json['channel'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        version: json['version']);
  }
}