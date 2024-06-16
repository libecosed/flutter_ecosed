import '../service/service_mixin.dart';

final class EcosedLibKernel with VMServiceWrapper {
  EcosedLibKernel();

  static Shell get shell => Shell();
}

final class Shell {}
