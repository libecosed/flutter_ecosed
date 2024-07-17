import '../base/base_wrapper.dart';
import 'runtime.dart';

base mixin RuntimeMixin {
  late EcosedRuntime ecosedRuntime;

  void initRuntime() {
    ecosedRuntime = EcosedRuntime();
  }

  BaseWrapper get _ecosedRuntime => ecosedRuntime;
}
