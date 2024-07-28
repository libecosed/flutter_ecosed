import '../framework/log.dart';
import '../framework/want.dart';
import '../values/tag.dart';
import 'binding.dart';
import 'flutter_ecosed.dart';
import 'method_call.dart';
import 'plugin_engine.dart';
import 'result.dart';

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
    void added = await super.onEcosedAdded(binding);

    final MyConnection connect = MyConnection(calback: (service) {
      myService = service;
      Log.i(engineTag, 'added');
    });

    final Want want = Want(classes: FlutterEcosedPlugin());

    startService(want);
    bindService(want, connect);

    return added;
  }

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {
    switch (call.method) {
      case '':
        myService.test();
      default:
    }
  }
}
