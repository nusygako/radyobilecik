import 'dart:async';
import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  int _currentTabIndex = 0;
  int? _sleepTimerMinutes;
  DateTime? _sleepTimerEndTime;
  Timer? _countdownTimer;

  /// Called when the sleep timer expires. Set by AppShell.
  void Function()? onSleepTimerExpired;

  ThemeMode get themeMode => _themeMode;
  int get currentTabIndex => _currentTabIndex;
  int? get sleepTimerMinutes => _sleepTimerMinutes;
  DateTime? get sleepTimerEndTime => _sleepTimerEndTime;
  bool get isSleepTimerActive => _sleepTimerEndTime != null;

  void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void setCurrentTab(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  void setSleepTimer(int minutes) {
    _sleepTimerMinutes = minutes;
    _sleepTimerEndTime = DateTime.now().add(Duration(minutes: minutes));
    _startCountdown();
    notifyListeners();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_sleepTimerEndTime == null ||
          DateTime.now().isAfter(_sleepTimerEndTime!)) {
        _countdownTimer?.cancel();
        _countdownTimer = null;
        _sleepTimerEndTime = null;
        _sleepTimerMinutes = null;
        notifyListeners();
        onSleepTimerExpired?.call();
      } else {
        notifyListeners();
      }
    });
  }

  void cancelSleepTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = null;
    _sleepTimerMinutes = null;
    _sleepTimerEndTime = null;
    notifyListeners();
  }

  Duration? getRemainingTime() {
    if (_sleepTimerEndTime == null) return null;
    final remaining = _sleepTimerEndTime!.difference(DateTime.now());
    if (remaining.isNegative) return null;
    return remaining;
  }

  /// Returns a 0.0–1.0 value representing remaining time fraction.
  double getRemainingProgress() {
    if (_sleepTimerEndTime == null || _sleepTimerMinutes == null) return 0;
    final total = Duration(minutes: _sleepTimerMinutes!).inSeconds.toDouble();
    final remaining = getRemainingTime()?.inSeconds.toDouble() ?? 0;
    if (total <= 0) return 0;
    return (remaining / total).clamp(0.0, 1.0);
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }
}
