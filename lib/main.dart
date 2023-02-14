import 'package:at_gauges/at_gauges.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:cm_launcher/widgets/neomorphism_widget.dart';
import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyLauncher());

class MyLauncher extends StatefulWidget {
  const MyLauncher({super.key});

  @override
  State<MyLauncher> createState() => _MyLauncherState();
}

class _MyLauncherState extends State<MyLauncher> {
  final Battery _battery = Battery();
  BatteryState _batteryState = BatteryState.unknown;

  Future<List<Application>> get getApps async =>
      DeviceApps.getInstalledApplications(
        includeAppIcons: true,
        includeSystemApps: false,
        onlyAppsWithLaunchIntent: false,
      );

  @override
  void initState() {
    super.initState();

    _battery.onBatteryStateChanged.listen((state) {
      setState(() {
        _batteryState = state;
      });
    });
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
          child: ListView(
            padding: const EdgeInsets.all(10),
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Neomorphism(
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.symmetric(horizontal: 15),
                    child: FutureBuilder<int>(
                        future: _battery.batteryLevel,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Center(
                              child: Text(snapshot.error.toString()),
                            );
                          }

                          if (!snapshot.hasData) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return SizedBox(
                            width: 200,
                            height: 200,
                            child: SimpleRadialGauge(
                              actualValue:
                                  double.parse(snapshot.data!.toString()),
                              maxValue: 100,
                              minValue: 0,
                              titlePosition: TitlePosition.bottom,
                              unit: '%',
                              icon: const Icon(
                                Icons.bolt,
                                size: 40,
                              ),
                              pointerColor: Theme.of(context).primaryColor,
                              decimalPlaces: 0,
                              isAnimate: true,
                              animationDuration: 2000,
                              size: 300,
                              title: Text(
                                "${_batteryState.name.toUpperCase()}...",
                                textScaleFactor: 1.1,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontStyle: FontStyle.italic,
                                  letterSpacing: 1,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          );
                        }),
                  ),
                ],
              ),
              FutureBuilder<List<Application>>(
                future: getApps,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  }

                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  List<Application> apps = snapshot.data!;

                  return Expanded(
                    child: GridView.builder(
                      primary: false,
                      shrinkWrap: true,
                      itemCount: apps.length,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      gridDelegate:
                          const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 100,
                        childAspectRatio: 1,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemBuilder: (context, index) {
                        var app = apps[index];

                        return GestureDetector(
                          onTap: () async => await app.openApp(),
                          child: Neomorphism(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                app is ApplicationWithIcon
                                    ? Expanded(
                                        child: Image(
                                          image: MemoryImage(app.icon),
                                        ),
                                      )
                                    : const Icon(Icons.flutter_dash),
                                const SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  app.appName,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textScaleFactor: 0.85,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
