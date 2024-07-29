import '../base/base_wrapper.dart';
import '../interface/ecosed_interface.dart';
import 'runtime.dart';

/// 运行时混入
base mixin RuntimeMixin implements BaseWrapper {
  /// 获取运行时实例
  @override
  EcosedInterface call() => EcosedRuntime();
}
