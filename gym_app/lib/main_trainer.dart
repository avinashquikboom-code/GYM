import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/trainer/screens/trainer_login_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: MyAppTrainer(),
    ),
  );
}

class MyAppTrainer extends StatelessWidget {
  const MyAppTrainer({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gym Trainer Ecosystem',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark, // Default to dark theme for premium dark gym trainer experience
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const TrainerLoginScreen(),
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
