import '../flutter_ecosed.dart';

Future runEcosedApp(EcosedApps app, RunApp run, List<EcosedPlugin> plugins) async {
 run(EcosedApp(app: app, plugins: plugins, title: ''));
}