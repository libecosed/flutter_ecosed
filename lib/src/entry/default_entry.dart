import 'dart:io';

import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../plugin/plugin_runtime.dart';
import '../interface/ecosed_interface.dart';
import '../type/runner.dart';
import '../values/tag.dart';

/// 无法正确加载平台时的实现
final class DefaultEntry extends EcosedInterface {
  /// 获取当前操作系统名称
  final String _platform = Platform.operatingSystem;

  /// 运行应用
  @override
  Future<void> runEcosedApp(
    Widget app,
    List<EcosedRuntimePlugin> plugins,
    Runner runner,
  ) async {
    return await runner(app).then(
      (_) => Log.w(
        entryTag,
        '不支持当前平台: $_platform, '
        '框架所有代码将不会参与执行, '
        '${plugins.length}个插件不会被加载.',
      ),
    );
  }

  /// 执行方法
  @override
  Future<dynamic> execPluginMethod(
    String channel,
    String method, [
    dynamic arguments,
  ]) async {
    Log.w(
      entryTag,
      '不支持当前平台: $_platform, '
      '当前调用的插件通道: $channel, '
      '方法名: $method, '
      '携带参数: $arguments, '
      '无法执行操作, 将返回空.',
    );
    return await null;
  }

  /// 打开调试菜单
  @override
  Future<void> openDebugMenu() async {
    Log.w(
      entryTag,
      '不支持当前平台: $_platform, '
      '无法打开调试对话框.',
    );
  }
}
