import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';

// Storage service provider that will be overridden in main.dart
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService has not been initialized');
});

// Theme notifier to manage ThemeMode state
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final StorageService _storageService;

  ThemeNotifier(this._storageService)
      : super(_storageService.isDarkMode() ? ThemeMode.dark : ThemeMode.light);

  bool get isDarkMode => state == ThemeMode.dark;

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
      _storageService.setDarkMode(false);
    } else {
      state = ThemeMode.dark;
      _storageService.setDarkMode(true);
    }
  }

  void setDarkMode(bool dark) {
    state = dark ? ThemeMode.dark : ThemeMode.light;
    _storageService.setDarkMode(dark);
  }
}

// Provider for the theme state
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return ThemeNotifier(storageService);
});
