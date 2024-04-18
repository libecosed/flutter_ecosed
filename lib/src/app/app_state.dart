import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../engine/ecosed_engine.dart';
import '../engine/engine_state.dart';
import '../plugin/plugin_type.dart';
import '../values/urls.dart';
import '../widget/ecosed_banner.dart';
import '../widget/ecosed_material.dart';
import '../widget/ecosed_scaffold.dart';
import '../widget/info_card.dart';
import '../widget/more_card.dart';
import '../widget/plugin_card.dart';
import '../widget/state_card.dart';
import 'app.dart';

class EcosedAppState extends State<EcosedApp> with EcosedEngine<EcosedApp> {
  /// 滚动控制器
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return EcosedMaterialApp(
      title: widget.title,
      materialApp: widget.materialApp,
      home: EcosedBanner(
        location: widget.location,
        child: EcosedMaterialScaffold(
          scaffold: widget.scaffold,
          title: widget.title,
          body: Builder(
            builder: (context) => widget.home(
              context,
              (channel, method) async {
                return await exec(channel, method);
              },
              Scrollbar(
                controller: _controller,
                child: ListView(
                  controller: _controller,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                      child: StateCard(
                        color: getEngineState() == EngineState.running
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Theme.of(context).colorScheme.errorContainer,
                        leading: getEngineState() == EngineState.running
                            ? Icons.check_circle_outline
                            : Icons.error_outline,
                        title: widget.title,
                        subtitle: getEngineState().name,
                        action: () {
                          openDialog(context);
                        },
                        trailing: Icons.developer_mode,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      child: InfoCard(
                        appName: widget.title,
                        state: getEngineState().name,
                        platform: Theme.of(context).platform.name,
                        count: pluginCount().toString(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      child: MoreCard(
                        launchUrl: () => launchUrl(
                          Uri.parse(pubDev),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Divider(),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(12, 6, 12, 0),
                      child: ListBody(
                        children: getPluginDetailsList()
                            .map(
                              (element) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: PluginCard(
                                  title: element.title,
                                  channel: element.channel,
                                  author: element.author,
                                  icon: element.type == PluginType.native
                                      ? Icon(
                                          Icons.android,
                                          size:
                                              Theme.of(context).iconTheme.size,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        )
                                      : const FlutterLogo(),
                                  description: element.description,
                                  type: getPluginType(element),
                                  action: isAllowPush(element)
                                      ? element.channel != pluginChannel()
                                          ? '打开'
                                          : '关于'
                                      : '无界面',
                                  open: isAllowPush(element)
                                      ? () {
                                          if (element.channel !=
                                              pluginChannel()) {
                                            launchPlugin(
                                              context,
                                              element,
                                            );
                                          } else {
                                            showAboutDialog(
                                              context: context,
                                              applicationName: widget.title,
                                              applicationIcon:
                                                  const FlutterLogo(),
                                              applicationLegalese:
                                                  'Powered by FlutterEcosed',
                                            );
                                          }
                                        }
                                      : null,
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
