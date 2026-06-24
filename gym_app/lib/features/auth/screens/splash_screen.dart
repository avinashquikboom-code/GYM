import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../providers/auth_provider.dart';
import 'role_selection_screen.dart';
import 'onboarding_screen.dart';
import '../../dashboard/screens/main_dashboard.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set status bar to transparent
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
    ));
    _startTimer();
  }

  void _startTimer() {
    Timer(const Duration(milliseconds: 2500), () {
      _routeUser();
    });
  }

  void _routeUser() {
    if (!mounted) return;

    final storage = ref.read(storageServiceProvider);
    final authState = ref.read(authProvider);

    final bool onboardingCompleted = storage.isOnboardingCompleted();
    final bool isLoggedIn = authState.isAuthenticated;

    Widget nextScreen;

    if (isLoggedIn) {
      nextScreen = const MainDashboard();
    } else if (onboardingCompleted) {
      nextScreen = const RoleSelectionScreen();
    } else {
      nextScreen = const OnboardingScreen();
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => nextScreen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Centered App Logo
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                boxShadow: isDark
                    ? [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.08),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ]
                    : null,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.asset(
                  'assets/images/gym_logo.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    child: const Icon(
                      Icons.fitness_center,
                      size: 64,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),
            )
            .animate()
            .fade(duration: 800.ms)
            .scale(begin: const Offset(0.7, 0.7), duration: 1000.ms, curve: Curves.easeOutBack),
            
            const SizedBox(height: 36),
            
            Text(
              'GYM FITNESS CLUB',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 16,
                letterSpacing: 6,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            )
            .animate()
            .fade(delay: 500.ms, duration: 600.ms),
            
            const SizedBox(height: 48),
            
            // Spinner
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
              ),
            )
            .animate()
            .fade(delay: 800.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
