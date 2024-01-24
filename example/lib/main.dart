import 'package:flutter/material.dart';

import 'package:flutter_ecosed/flutter_ecosed.dart';

void main() => runApp(const EcosedApp(app: MyApp(), plugins: [], title: ''));

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
      home: Scaffold(
        appBar: AppBar(
          title: const Text('FlutterEcosed Example App'),
        ),
        body: const Center(
          child: Text('Oi!'),
        ),
      ),
    );
  }
}
