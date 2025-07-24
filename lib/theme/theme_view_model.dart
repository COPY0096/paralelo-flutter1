import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemePreference { system, light, dark }

class ThemeViewModel extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  ThemeViewModel() {
    _loadThemePreference();
  }

  void setTheme(ThemePreference preference) async {
    final prefs = await SharedPreferences.getInstance();

    switch (preference) {
      case ThemePreference.system:
        _themeMode = ThemeMode.system;
        prefs.setString('theme', 'system');
        break;
      case ThemePreference.light:
        _themeMode = ThemeMode.light;
        prefs.setString('theme', 'light');
        break;
      case ThemePreference.dark:
        _themeMode = ThemeMode.dark;
        prefs.setString('theme', 'dark');
        break;
    }

    notifyListeners();
  }

  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString('theme') ?? 'system';

    switch (themeStr) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
        break;
    }

    notifyListeners();
  }
}
