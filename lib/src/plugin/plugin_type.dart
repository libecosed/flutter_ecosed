/// 插件类型
enum PluginType {
  /// 框架运行时
  runtime,

  /// 运行时基础绑定
  base,

  /// 库操作系统内核
  kernel,

  /// 引擎插件
  engine,

  /// 平台插件
  platform,

  /// 普通插件
  flutter,

  /// 未知插件类型，用于异常处理
  unknown,
}
