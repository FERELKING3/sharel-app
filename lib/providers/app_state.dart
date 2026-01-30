import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int idx) {
    if (_selectedIndex == idx) return;
    _selectedIndex = idx;
    notifyListeners();
  }
}
