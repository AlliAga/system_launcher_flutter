import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';

class BrightnessrProvider extends ChangeNotifier {
  double _brightnessPercent = 10;

  double get getBrightnessPercentage => _brightnessPercent;

  void setSystemBrightness() async {
    _brightnessPercent = await ScreenBrightness().system * 100;
    if (_brightnessPercent < 5) {
      _brightnessPercent = 5;
    }
    notifyListeners();
  }

  void changeBrightness(double val) async {
    if (val > 0) {
      if (_brightnessPercent <= 5) return;
      _brightnessPercent -= 0.5;
    } else {
      if (_brightnessPercent >= 100) return;
      _brightnessPercent += 0.5;
    }
    try {
      await ScreenBrightness().setScreenBrightness(_brightnessPercent / 100);
    } catch (e) {
      log(e.toString());
      throw 'Failed to set brightness';
    }
    notifyListeners();
  }
}
