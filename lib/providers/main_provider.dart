import 'package:cm_launcher/fragment_screens/app_list_screen.dart';
import 'package:cm_launcher/fragment_screens/phone_detail_screen.dart';
import 'package:flutter/material.dart';

class MainProvider extends ChangeNotifier {
  int _currentScreen = 0;

  final List<Widget> _screens = const [
    PhoneDetailScreen(),
    AppListScreen(),
  ];

  int get getCurrentScreen => _currentScreen;
  List<Widget> get getScreens => _screens;

  void changeScreenTo(int i) {
    _currentScreen = i;
    notifyListeners();
  }
}
