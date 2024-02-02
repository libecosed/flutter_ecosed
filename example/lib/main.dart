import 'package:flutter/material.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends EcosedPlugin {
  const ExampleApp({super.key});

  @override
  String pluginName() => 'Example Plugin';

  @override
  String pluginAuthor() => 'example';

  @override
  String pluginChannel() => 'flutter_example';

  @override
  String pluginDescription() => 'example';

  @override
  Future<Object?> onEcosedMethodCall(String name) async {
    return null;
  }

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  static const String appName = 'FlutterEcosed Example App';

  @override
  Widget build(BuildContext context) {

    // return MaterialApp(
    //   home: EcosedApp(
    //     materialHome: (body, exec) {
    //       return Scaffold(
    //         appBar: AppBar(
    //           title: const Text(appName),
    //           centerTitle: true,
    //         ),
    //         body: body,
    //       );
    //     },
    //     materialApp: (home, builder, title) {
    //       return MaterialApp(
    //         home: home,
    //         builder: builder,
    //         title: title,
    //       );
    //     },
    //     bannerLocation: BannerLocation.topStart,
    //     appName: appName,
    //     plugins: [widget],
    //   ),
    // );
    return EcosedApp(
      materialHome: (body, exec) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(appName),
            centerTitle: true,
          ),
          body: body,
        );
      },
      materialApp: (home, builder, title) {
        return MaterialApp(
          home: home,
          builder: builder,
          title: title,
        );
      },
      bannerLocation: BannerLocation.topStart,
      appName: appName,
      plugins: [widget],
    );
  }
}
