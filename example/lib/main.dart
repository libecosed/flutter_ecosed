import 'package:flutter/material.dart';

import 'package:flutter_ecosed/flutter_ecosed.dart';
import 'package:flutter_ecosed_example/example_plugin.dart';

void main() {
  // runEcosedApp((openManager) {
  //   return MyApp(openManager: openManager);
  // }, (app) {
  //   runApp(app);
  // }, [const ExamplePlugin()]);

  runApp(EcosedApp(
      app: (openManager) {
        return MyApp(openManager: openManager);
      },
      plugins: const [ExamplePlugin()],
      title: ''));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key, required this.openManager});

  final VoidCallback openManager;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: false),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterEcosed Example App'),
        ),
        body: Center(
          child: MaterialButton(
            onPressed: widget.openManager,
            child: const Text('打开管理器'),
          ),
        ),
      ),
    );
  }
}
