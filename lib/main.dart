import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:funny_time/setting.dart';
import 'package:funny_time/time.dart';
import 'package:funny_time/color_schemes.g.dart';

void main() {
  runApp(const MyApp());
  SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersive,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]
  );
  SystemChrome.setApplicationSwitcherDescription(
      const ApplicationSwitcherDescription(
        label: "Funny Time, Good Time!",
      )
  );
  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) {
    print("systemOverlaysAreVisible $systemOverlaysAreVisible");
    return Future(() {});
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Funny Time',
      themeMode: ThemeMode.dark,
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: const MyHomePage(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  bool loading = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (WidgetsBinding.instance.lifecycleState != null) {
      didChangeAppLifecycleState(WidgetsBinding.instance.lifecycleState!);
    }
    _appDataInit();
  }

  _appDataInit() {
    SettingManager.init(() async {
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        loading = false;
      });
    });
  }

  @override
  didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState $state");
  }

  @override
  void didChangePlatformBrightness() {
    print("didChangePlatformBrightness");
  }

  @override
  void didChangeMetrics() {
    globalSetting.sharedScreenSize = MediaQuery.sizeOf(context);
    print("didChangeMetrics ${globalSetting.sharedScreenSize}");
    SettingManager.triggerMetricsChangeCallback();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(strokeWidth: 2,),
              Padding(padding: EdgeInsets.only(top: 12)),
              Text("初始化中..."),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    }
    return const TimePage();
  }
}
