import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingService extends ChangeNotifier {
  static const String _seenKeyPrefix = 'onboarding_seen_';

  bool _hasSeenOnboarding = false;
  bool _isLoading = true;
  String? _userId;

  bool get hasSeenOnboarding => _hasSeenOnboarding;
  bool get isLoading => _isLoading;

  // Called by ProxyProvider when auth changes
  void updateUser(String? userId) {
    if (_userId != userId) {
      _userId = userId;
      _loadState();
    }
  }

  Future<void> _loadState() async {
    _isLoading = true;
    // Don't notify here to avoid build errors if called during build,
    // but usually updateUser is called during build.
    // However, we want to notify when loading finishes.

    if (_userId == null) {
      _hasSeenOnboarding = false;
      _isLoading = false;
      notifyListeners();
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    final key = '$_seenKeyPrefix$_userId';
    _hasSeenOnboarding = prefs.getBool(key) ?? false;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> markAsSeen() async {
    if (_userId == null) return;

    _hasSeenOnboarding = true;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final key = '$_seenKeyPrefix$_userId';
    await prefs.setBool(key, true);
  }

  // Para testes ou reset
  Future<void> reset() async {
    if (_userId == null) return;

    _hasSeenOnboarding = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    final key = '$_seenKeyPrefix$_userId';
    await prefs.remove(key);
  }
}
