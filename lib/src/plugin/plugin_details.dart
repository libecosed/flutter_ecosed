import 'plugin_type.dart';

/// 插件详细信息
final class PluginDetails {
  const PluginDetails({
    required this.channel,
    required this.title,
    required this.description,
    required this.author,
    required this.type,
  });

  /// 插件通道,插件的唯一标识符
  final String channel;

  /// 插件标题
  final String title;

  /// 插件描述
  final String description;

  /// 插件作者
  final String author;

  /// 插件类型
  final PluginType type;

  /// 使用Map解析插件详细信息
  factory PluginDetails.formMap({
    required Map<String, dynamic> map,
    required PluginType type,
  }) {
    return PluginDetails(
      channel: map['channel'],
      title: map['title'],
      description: map['description'],
      author: map['author'],
      type: type,
    );
  }

  /// 使用JSON解析插件详细信息
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
