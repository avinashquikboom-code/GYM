import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../constants/app_colors.dart';

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

// Accent color notifier to manage accent color state
class AccentColorNotifier extends StateNotifier<Color> {
  final StorageService _storageService;

  AccentColorNotifier(this._storageService)
      : super(_storageService.getAccentColor() ?? AppColors.primaryGreen);

  void setAccentColor(Color color) {
    state = color;
    _storageService.setAccentColor(color);
  }
}

// Provider for the accent color
final accentColorProvider = StateNotifierProvider<AccentColorNotifier, Color>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return AccentColorNotifier(storageService);
});
