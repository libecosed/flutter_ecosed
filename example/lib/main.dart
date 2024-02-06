import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:flutter_ecosed/flutter_ecosed.dart';

void main() {
  CustomFlutterBinding();
  runApp(const ExampleApp());
}

class CustomFlutterBinding extends WidgetsFlutterBinding
    with BoostFlutterBinding {}

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  static const String appName = 'flutter_ecosed 示例应用';

  static Map<String, FlutterBoostRouteFactory> routerMap = {
    '/': (settings, uniqueId) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const MyHomePage(title: appName),
      );
    },
    '/manager': (settings, uniqueId) {
      return MaterialPageRoute(
        settings: settings,
        builder: (_) => const MyManagerPage(title: appName),
      );
    },
  };

  Route<dynamic>? routeFactory(RouteSettings settings, String? uniqueId) {
    FlutterBoostRouteFactory? func = routerMap[settings.name!];
    if (func == null) return null;
    return func(settings, uniqueId);
  }

  Widget appBuilder(BuildContext context, Widget home) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          home: home,
          builder: (context, child) => home,
          title: appName,
          theme: ThemeData(
            colorScheme: lightDynamic,
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: darkDynamic,
            useMaterial3: true,
          ),
          themeMode: ThemeMode.system,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FlutterBoostApp(
      routeFactory,
      appBuilder: (home) => appBuilder(
        context,
        home,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'flutter_ecosed与flutter_boost不完全兼容',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              '注意: 如果需要使用flutter_boost库, 在切换页面时请勿使用withContainer: true, 这样会导致页面在新的Activity中打开, flutter_ecosed无法按照预期正常工作.',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: Theme.of(context).textTheme.titleLarge?.fontSize,
                  color: Theme.of(context).colorScheme.error),
            ),
            FilledButton(
              onPressed: () {
                BoostNavigator.instance.push('/manager', withContainer: false);
              },
              child: const Text('open manager'),
            )
          ],
        ),
      ),
    );
  }
}

class MyManagerPage extends StatelessWidget {
  const MyManagerPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: const EcosedManager(),
    );
  }
}
