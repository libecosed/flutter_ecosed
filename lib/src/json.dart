class PluginPerson {
  String channel;
  String title;
  String description;
  String author;
  String version;

  PluginPerson(
      {required this.channel,
      required this.title,
      required this.description,
      required this.author,
      required this.version});

  factory PluginPerson.fromJson(Map<String, dynamic> json) {
    return PluginPerson(
        channel: json['channel'],
        title: json['title'],
        description: json['description'],
        author: json['author'],
        version: json['version']);
  }
}
