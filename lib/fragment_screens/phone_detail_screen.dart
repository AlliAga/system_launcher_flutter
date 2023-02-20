import 'package:at_gauges/at_gauges.dart';
import 'package:cm_launcher/helpers/storage_helper.dart';
import 'package:cm_launcher/providers/battery_provider.dart';
import 'package:cm_launcher/providers/brightness_provider.dart';
import 'package:cm_launcher/widgets/neomorphism_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class PhoneDetailScreen extends StatefulWidget {
  const PhoneDetailScreen({super.key});

  @override
  State<PhoneDetailScreen> createState() => _PhoneDetailScreenState();
}

class _PhoneDetailScreenState extends State<PhoneDetailScreen> {
  final StorageHelper _storageHelper = StorageHelper.init;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          SizedBox(
            height: 275,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Neomorphism(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: StreamBuilder<int>(
                        stream: context.read<BatteryProvider>().getBatteryLevel,
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

                          return SimpleRadialGauge(
                            actualValue:
                                double.parse(snapshot.data!.toString()),
                            maxValue: 100,
                            minValue: 0,
                            titlePosition: TitlePosition.bottom,
                            unit: '%',
                            icon: Icon(
                              Icons.bolt,
                              size: 40,
                              color: context.watch<BatteryProvider>().isCharging
                                  ? Colors.green
                                  : null,
                            ),
                            pointerColor: Theme.of(context).primaryColor,
                            decimalPlaces: 0,
                            isAnimate: true,
                            animationDuration: 2000,
                            size: 300,
                            title: Text(
                              "${context.watch<BatteryProvider>().getBatteryState.name.toUpperCase()}...",
                              textScaleFactor: 1.1,
                              style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontStyle: FontStyle.italic,
                                letterSpacing: 1,
                                color: Colors.grey,
                              ),
                            ),
                          );
                        }),
                  ),
                ),
                const SizedBox(
                  width: 25,
                ),
                Expanded(
                  child: Neomorphism(
                    padding: const EdgeInsets.all(8),
                    child: LayoutBuilder(
                      builder: (context, box) {
                        return Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          children: [
                            GestureDetector(
                              onVerticalDragUpdate: (details) => context
                                  .read<BrightnessrProvider>()
                                  .changeBrightness(details.delta.dy),
                              child: Container(
                                height: box.maxHeight,
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onVerticalDragUpdate: (details) => context
                                  .read<BrightnessrProvider>()
                                  .changeBrightness(details.delta.dy),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutBack,
                                height: context
                                        .watch<BrightnessrProvider>()
                                        .getBrightnessPercentage *
                                    box.maxHeight /
                                    100,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            const Positioned(
                              bottom: 8,
                              child: Icon(
                                CupertinoIcons.brightness,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 25),
          Row(
            children: [
              Expanded(
                child: Neomorphism(
                  child: SizedBox(
                    height: 250,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FutureBuilder<double>(
                            future: _storageHelper.getCalculatedSpace,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return Center(
                                  child: Text(snapshot.error.toString()),
                                );
                              }

                              if (!snapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 10,
                                  ),
                                );
                              }

                              var val = snapshot.data ?? 0;

                              return WaveWidget(
                                config: CustomConfig(
                                  colors: [
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.2),
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.4),
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.6),
                                  ],
                                  durations: [1600, 8000, 4000],
                                  heightPercentages: [val, val, val],
                                ),
                                size: const Size(
                                    double.infinity, double.infinity),
                                waveAmplitude: 2,
                              );
                            }),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Total Storage"),
                      FutureBuilder<double>(
                        future: _storageHelper.getStorageTotalSpaceInGB,
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Text(snapshot.error.toString());
                          }

                          if (!snapshot.hasData) {
                            return const Text("Calculating...");
                          }

                          return Text("${snapshot.data ?? 0} GB");
                        },
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Free Space"),
                                FutureBuilder<double>(
                                  future:
                                      _storageHelper.getStorageFreeSpaceInGB,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }

                                    if (!snapshot.hasData) {
                                      return const Text("Calculating...");
                                    }

                                    return Text("${snapshot.data ?? 0} GB");
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Used Space"),
                                FutureBuilder<double>(
                                  future:
                                      _storageHelper.getStorageUsedSpaceInGB,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasError) {
                                      return Text(snapshot.error.toString());
                                    }

                                    if (!snapshot.hasData) {
                                      return const Text("Calculating...");
                                    }

                                    return Text("${snapshot.data ?? 0} GB");
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
