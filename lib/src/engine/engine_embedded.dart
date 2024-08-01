import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import '../framework/log.dart';
import '../framework/service.dart';
import '../framework/want.dart';
import '../values/tag.dart';
import 'binding.dart';
import 'method_call.dart';
import 'plugin_engine.dart';
import 'result.dart';

final class EngineEmbedded extends EcosedEnginePlugin {
  @override
  String get author => 'wyq0918dev';

  @override
  String get channel => 'engine_embedded';

  @override
  String get description => '服务嵌入';

  @override
  String get title => 'EngineEmbedded';

  /// 服务实例
  late FlutterEcosedPlugin _service;

  @override
  Future<void> onEcosedAdded(PluginBinding binding) async {
    return await super.onEcosedAdded(binding).then((added) {
      final MyConnection connect = MyConnection(
        calback: (service) => _service = service,
      );
      final Want want = Want(classes: FlutterEcosedPlugin());
      startService(want);
      bindService(want, connect);
      return added;
    });
  }

  @override
  Future<void> onEcosedMethodCall(
    EcosedMethodCall call,
    EcosedResult result,
  ) async {
    switch (call.method) {
      case 'getPlugins':
        result.success(_service.getPlatformPluginList());
      case 'openDialog':
        result.success(_service.openPlatformDialog());
      case 'closeDialog':
        result.success(_service.closePlatformDialog());
      default:
        result.notImplemented();
    }
  }
}

final class FlutterEcosedPlugin extends Service
    implements FlutterEcosedPlatform {
  final FlutterEcosedPlatform instance = FlutterEcosedPlatform.instance;

  @override
  void onCreate() {
    super.onCreate();
    Log.i(engineTag, 'onCreate');
  }

  @override
  IBinder onBind(Want want) => LocalBinder(service: this);

  @override
  Future<List?> getPlatformPluginList() async {
    return await instance.getPlatformPluginList();
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await instance.openPlatformDialog();
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await instance.closePlatformDialog();
  }
}

final class LocalBinder extends Binder {
  LocalBinder({required this.service});

  final FlutterEcosedPlugin service;

  @override
  Service get getService => service;
}

final class MyConnection implements ServiceConnection {
  MyConnection({required this.calback});

  final void Function(FlutterEcosedPlugin service) calback;

  @override
  void onServiceConnected(String name, IBinder service) {
    LocalBinder binder = service as LocalBinder;
    calback.call(binder.getService as FlutterEcosedPlugin);
  }

  @override
  void onServiceDisconnected(String name) {}
}

abstract class FlutterEcosedPlatform extends PlatformInterface {
  FlutterEcosedPlatform() : super(token: _token);

  static final Object _token = Object();
  static FlutterEcosedPlatform get instance => MethodChannelFlutterEcosed();

  Future<List?> getPlatformPluginList() async {
    throw UnimplementedError('未实现getPlatformPluginList()接口.');
  }

  Future<bool?> openPlatformDialog() async {
    throw UnimplementedError('未实现openPlatformDialog()接口.');
  }

  Future<bool?> closePlatformDialog() async {
    throw UnimplementedError('未实现closePlatformDialog()接口.');
  }
}

class MethodChannelFlutterEcosed extends FlutterEcosedPlatform {
  /// 方法通道
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_ecosed');

  /// 方法通道调用参数
  final Map<String, String> _arguments = const {'channel': 'ecosed_engine'};

  @override
  Future<List?> getPlatformPluginList() async {
    return await methodChannel.invokeListMethod<String?>(
      'getPlugins',
      _arguments,
    );
  }

  @override
  Future<bool?> openPlatformDialog() async {
    return await methodChannel.invokeMethod<bool?>('openDialog', _arguments);
  }

  @override
  Future<bool?> closePlatformDialog() async {
    return await methodChannel.invokeMethod<bool?>('closeDialog', _arguments);
  }
}
