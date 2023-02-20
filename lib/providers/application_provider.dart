import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class ApplicationProvider extends ChangeNotifier {
  List<Application> _appList = [];

  Future<List<Application>> get getApps async {
    _appList = await DeviceApps.getInstalledApplications(
      includeAppIcons: true,
      includeSystemApps: true,
      onlyAppsWithLaunchIntent: true,
    );

    return _appList;
  }

  List<Application> get getInitialApps => _appList;
}
