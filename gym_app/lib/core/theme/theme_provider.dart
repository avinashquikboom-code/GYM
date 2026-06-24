import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/storage_service.dart';
import '../constants/app_colors.dart';

// Storage service provider that will be overridden in main.dart
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService has not been initialized');
});

// Theme state class to hold both theme mode and accent color
class ThemeState {
  final ThemeMode mode;
  final Color accentColor;

  ThemeState({required this.mode, required this.accentColor});

  ThemeState copyWith({ThemeMode? mode, Color? accentColor}) {
    return ThemeState(
      mode: mode ?? this.mode,
      accentColor: accentColor ?? this.accentColor,
    );
  }
}

// Theme notifier to manage both ThemeMode and accent color state
class ThemeNotifier extends StateNotifier<ThemeState> {
  final StorageService _storageService;

  ThemeNotifier(this._storageService)
      : super(ThemeState(
          mode: _storageService.isDarkMode() ? ThemeMode.dark : ThemeMode.light,
          accentColor: _storageService.getAccentColor() ?? AppColors.primaryGreen,
        ));

  bool get isDarkMode => state.mode == ThemeMode.dark;
  Color get accentColor => state.accentColor;

  void toggleTheme() {
    final newMode = state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    state = state.copyWith(mode: newMode);
    _storageService.setDarkMode(newMode == ThemeMode.dark);
  }

  void setDarkMode(bool dark) {
    final newMode = dark ? ThemeMode.dark : ThemeMode.light;
    state = state.copyWith(mode: newMode);
    _storageService.setDarkMode(dark);
  }

  void setAccentColor(Color color) {
    state = state.copyWith(accentColor: color);
    _storageService.setAccentColor(color);
  }
}

// Provider for the theme state
final themeNotifierProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return ThemeNotifier(storageService);
});
