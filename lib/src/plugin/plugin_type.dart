/// 插件类型
enum PluginType {
  /// 平台插件，特指Android
  platform,

  /// 框架运行时
  runtime,

  /// 普通插件
  flutter,

  /// 未知插件类型，用于异常处理
  unknown,
}
