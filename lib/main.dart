import 'package:cm_launcher/providers/application_provider.dart';
import 'package:cm_launcher/providers/battery_provider.dart';
import 'package:cm_launcher/providers/brightness_provider.dart';
import 'package:cm_launcher/providers/main_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ApplicationProvider()),
          ChangeNotifierProvider(create: (_) => BatteryProvider()),
          ChangeNotifierProvider(create: (_) => BrightnessrProvider()),
          ChangeNotifierProvider(create: (_) => MainProvider()),
        ],
        child: const MyLauncher(),
      ),
    );

class MyLauncher extends StatefulWidget {
  const MyLauncher({super.key});

  @override
  State<MyLauncher> createState() => _MyLauncherState();
}

class _MyLauncherState extends State<MyLauncher> {
  @override
  void initState() {
    super.initState();
    context.read<BatteryProvider>().listenBatteryState();
    context.read<BrightnessrProvider>().setSystemBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      themeMode: ThemeMode.light,
      darkTheme: ThemeData.dark(),
      theme: ThemeData.light(),
      home: Scaffold(
        backgroundColor: const Color(0xffe0e5ec),
        body: SafeArea(
          child: PageView(
            physics: const BouncingScrollPhysics(),
            onPageChanged: (i) =>
                context.read<MainProvider>().changeScreenTo(i),
            children: context.read<MainProvider>().getScreens,
          ),
        ),
      ),
    );
  }
}
