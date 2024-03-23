library flutter_ecosed;

import 'package:flutter/material.dart';

import '../engine/ecosed_engine.dart';
import '../plugin/plugin_type.dart';
import 'app.dart';

class EcosedAppState extends State<EcosedApp> with EcosedEngine {
  /// 滚动控制器
  late ScrollController _controller;

  /// 加载状态
  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context)
        .textTheme
        .apply(displayColor: Theme.of(context).colorScheme.onSurface);
    final colorScheme = Theme.of(context).colorScheme;
    final platform = Theme.of(context).platform;
    final iconTheme = Theme.of(context).iconTheme;
    return Banner(
      message: 'EcosedApp',
      location: widget.location,
      color: Colors.pinkAccent,
      child: Container(
        child: widget.scaffold(
          Container(
            child: widget.home(
              (channel, method) async {
                return await exec(channel, method);
              },
              Scrollbar(
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                          child: Card(
                            // color: platform == TargetPlatform.android
                            //     ? colorScheme.primaryContainer
                            //     : colorScheme.errorContainer,
                            color: colorScheme.primaryContainer,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  Icon(
                                    // platform == TargetPlatform.android
                                    //     ? Icons.check_circle_outline
                                    //     : Icons.error_outline,
                                    Icons.keyboard_command_key,
                                    size: iconTheme.size,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 24),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.title,
                                            textAlign: TextAlign.left,
                                            style: textTheme.titleMedium,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            // platform == TargetPlatform.android
                                            //     ? '一切正常'
                                            //     : '不支持的操作系统',
                                            'default',
                                            textAlign: TextAlign.left,
                                            style: textTheme.bodyMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      openDialog(context);
                                    },
                                    icon: Icon(
                                      Icons.developer_mode,
                                      size: iconTheme.size,
                                      color: colorScheme.onPrimaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '应用名称',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          widget.title,
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '当前状态',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          // platform == TargetPlatform.android
                                          //     ? '一切正常'
                                          //     : '不支持的操作系统',
                                          'default',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '当前平台',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          platform.name,
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          '插件数量',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          pluginCount(),
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                            horizontal: 12,
                          ),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '了解 flutter_ecosed',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyLarge,
                                        ),
                                        Text(
                                          '了解如何使用 flutter_ecosed 进行开发。',
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      openPubDev(context);
                                    },
                                    icon: const Icon(Icons.open_in_browser),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                      child: Column(
                        children: pluginDetailsList
                            .map(
                              (element) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Card(
                                  color: colorScheme.surface,
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        24, 16, 24, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    element.title,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: textTheme
                                                          .titleMedium
                                                          ?.fontSize,
                                                      fontFamily: textTheme
                                                          .titleMedium
                                                          ?.fontFamily,
                                                      height: textTheme
                                                          .bodySmall?.height,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                  Text(
                                                    '通道: ${element.channel}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: textTheme
                                                          .bodySmall?.fontSize,
                                                      fontFamily: textTheme
                                                          .bodySmall
                                                          ?.fontFamily,
                                                      height: textTheme
                                                          .bodySmall?.height,
                                                    ),
                                                  ),
                                                  Text(
                                                    '作者: ${element.author}',
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      fontSize: textTheme
                                                          .bodySmall?.fontSize,
                                                      fontFamily: textTheme
                                                          .bodySmall
                                                          ?.fontFamily,
                                                      height: textTheme
                                                          .bodySmall?.height,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                element.type ==
                                                        PluginType.native
                                                    ? Icon(
                                                        Icons.android,
                                                        size: iconTheme.size,
                                                        color:
                                                            colorScheme.primary,
                                                      )
                                                    : const FlutterLogo(),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          element.description,
                                          textAlign: TextAlign.start,
                                          style: textTheme.bodySmall?.apply(
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          maxLines: 4,
                                        ),
                                        const SizedBox(height: 16),
                                        const Divider(),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                getType(element),
                                                textAlign: TextAlign.start,
                                                style: textTheme.bodySmall,
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: isAllowPush(element)
                                                  ? () {
                                                      if (element.channel !=
                                                          pluginChannel()) {
                                                        launchPlugin(
                                                          context,
                                                          element,
                                                        );
                                                      } else {
                                                        showDialog(
                                                          context: context,
                                                          builder: (context) {
                                                            return AlertDialog(
                                                              title: const Text(
                                                                  '关于'),
                                                              content: const Text(
                                                                  'flutter_about'),
                                                              actions: <Widget>[
                                                                TextButton(
                                                                  child:
                                                                      const Text(
                                                                          '确认'),
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.of(
                                                                            context)
                                                                        .pop();
                                                                  },
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        );
                                                      }
                                                    }
                                                  : null,
                                              child: Text(
                                                isAllowPush(element)
                                                    ? element.channel !=
                                                            pluginChannel()
                                                        ? '打开'
                                                        : '关于'
                                                    : '无界面',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
