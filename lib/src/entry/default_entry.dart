import 'dart:io';

import 'package:flutter/widgets.dart';

import '../framework/log.dart';
import '../interface/ecosed_interface.dart';
import '../type/runner.dart';
import '../values/tag.dart';

/// 无法正确加载平台时的实现
final class DefaultEntry extends EcosedInterface {
  /// Entry
  @override
  Future<void> runEcosedApp(
    AppRunner runner,
    PluginList plugins,
    AppBuilder app,
    Object? error,
  ) async {
    // 获取当前操作系统名称
    final String platform = Platform.operatingSystem;
    return await runner(
      Builder(
        builder: (context) => app(
          context,
          () async {
            Log.w(
              tag: entryTag,
              message: '不支持当前平台: $platform, '
                  '无法打开调试对话框.',
            );
          },
          (
            String channel,
            String method, [
            dynamic arguments,
          ]) async {
            Log.w(
              tag: entryTag,
              message: '不支持当前平台: $platform, '
                  '当前调用的插件通道: $channel, '
                  '方法名: $method, '
                  '携带参数: $arguments, '
                  '无法执行操作, 将返回空.',
            );
            return await null;
          },
        ),
      ),
    ).then(
      (_) => Log.w(
        tag: entryTag,
        message: '不支持当前平台: $platform, '
            '框架所有代码将不会参与执行, '
            '${plugins().length}个插件不会被加载.',
      ),
    );
  }
}
