import '../plugin/plugin_runtime.dart';
import 'base.dart';
import 'base_wrapper.dart';

/// 绑定层混入
base mixin BaseMixin implements BaseWrapper {
  /// 获取绑定层实例
  @override
  EcosedRuntimePlugin get base => EcosedBase();
}
