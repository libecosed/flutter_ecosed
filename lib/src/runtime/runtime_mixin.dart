import 'package:flutter_ecosed/src/base/base_wrapper.dart';
import 'package:flutter_ecosed/src/runtime/runtime.dart';

base mixin RuntimeMixin {
  late EcosedRuntime ecosedRuntime;

  BaseWrapper get _ecosedRuntime => ecosedRuntime;
}
