import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/services/storage_service.dart';
import 'core/theme/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/screens/splash_screen.dart';

void main() async {
  // Ensure Flutter engine is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Load SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final storageService = StorageService(prefs);

  runApp(
    ProviderScope(
      overrides: [
        // Override the storage provider with the loaded instance
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to theme changes
    final themeState = ref.watch(themeNotifierProvider);

    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: themeState.mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
        statusBarBrightness: themeState.mode == ThemeMode.dark ? Brightness.dark : Brightness.light,
      ),
    );

    return MaterialApp(
      title: 'Gym Fitness Club',
      debugShowCheckedModeBanner: false,
      themeMode: themeState.mode,
      theme: AppTheme.getLightThemeWithColor(themeState.accentColor),
      darkTheme: AppTheme.getDarkThemeWithColor(themeState.accentColor),
      home: const SplashScreen(),
      builder: (context, child) {
        final mediaQueryData = MediaQuery.of(context);
        // Base scale factor on screen width (standard design width of 375)
        final scale = (mediaQueryData.size.width / 375.0).clamp(0.85, 1.2);
        return MediaQuery(
          data: mediaQueryData.copyWith(
            textScaler: TextScaler.linear(scale),
          ),
          child: child!,
        );
      },
    );
  }
}
