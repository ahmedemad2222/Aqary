import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeData get themeData {
    if (_isDarkMode) {
      return ThemeData.dark().copyWith(
        // Customize dark mode colors here
        primaryColor: Colors.grey[800],
        // Add more dark mode color customizations as needed
      );
    } else {
      return ThemeData.light();
    }
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}
