import 'package:flutter_ecosed/src/engine/binding.dart';
import 'package:flutter_ecosed/src/engine/flutter_ecosed.dart';
import 'package:flutter_ecosed/src/engine/method_call.dart';
import 'package:flutter_ecosed/src/engine/plugin_engine.dart';
import 'package:flutter_ecosed/src/engine/result.dart';
import 'package:flutter_ecosed/src/framework/intent.dart';
import 'package:flutter_ecosed/src/values/tag.dart';

import '../framework/log.dart';

final class ServiceInvoke extends EcosedEnginePlugin {
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'service_invoke';

  @override
  String get description => '服务调用';

  @override
  String get title => 'ServiceInvoke';

  late FlutterEcosedPlugin myService;

  @override
  Future<void> onEcosedAdded(PluginBinding binding) async {
    var added = await super.onEcosedAdded(binding);

    final MyConnection connect = MyConnection(calback: (service) {
      myService = service;
      Log.i(engineTag, 'added');
    });

    final Intent intent = Intent(classes: FlutterEcosedPlugin());

    startService(intent);
    bindService(intent, connect);

    return added;
  }

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {}
}
