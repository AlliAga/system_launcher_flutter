import 'package:battery_plus/battery_plus.dart';
import 'package:flutter/material.dart';

class BatteryProvider extends ChangeNotifier {
  final Battery _battery = Battery();
  BatteryState _batteryState = BatteryState.unknown;

  void listenBatteryState() {
    _battery.onBatteryStateChanged.listen((state) {
      _batteryState = state;
      notifyListeners();
    });
  }

  BatteryState get getBatteryState => _batteryState;

  bool get isCharging => _batteryState == BatteryState.charging;

  Stream<int> get getBatteryLevel => _battery.batteryLevel.asStream();
}
