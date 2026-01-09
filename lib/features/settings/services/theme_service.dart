import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeService extends ChangeNotifier {
  static const String _themeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      // In a real app we might need context to know if system is dark,
      // but for logic checks we usually rely on the value being ThemeMode.dark
      // or the user explicitly setting it.
      // For this simpler service, let's just return true if it's explicitly dark.
      return false;
    }
    return _themeMode == ThemeMode.dark;
  }

  ThemeService() {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);
    if (themeString != null) {
      if (themeString == 'light') _themeMode = ThemeMode.light;
      if (themeString == 'dark') _themeMode = ThemeMode.dark;
      if (themeString == 'system') _themeMode = ThemeMode.system;
      notifyListeners();
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    String value = 'system';
    if (mode == ThemeMode.light) value = 'light';
    if (mode == ThemeMode.dark) value = 'dark';
    await prefs.setString(_themeKey, value);
  }
}
