import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/widgets/custom_button.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.network(
              AppUrls.welcomeBgImage,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.darkBackground,
              ),
            ),
          ),
          
          // Dark Overlay Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.4),
                    Colors.black.withOpacity(0.6),
                    Colors.black,
                  ],
                  stops: const [0.0, 0.5, 0.95],
                ),
              ),
            ),
          ),

          // Content Layout
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Gym Logo Header
                  Column(
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.fitness_center,
                            color: AppColors.primaryGreen,
                            size: 32,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'GYM',
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w900,
                              fontSize: 26,
                              letterSpacing: 2,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 500.ms).slideY(begin: -0.2, end: 0),
                      const SizedBox(height: 4),
                      Text(
                        'FITNESS CLUB',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12,
                          letterSpacing: 4,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ).animate().fade(duration: 700.ms),
                    ],
                  ),

                  // Middle/Bottom text + buttons
                  Column(
                    children: [
                      // Subtitles & Main Catchphrase
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            height: 1.3,
                          ),
                          children: [
                            const TextSpan(text: 'TRANSFORM YOUR BODY\n'),
                            TextSpan(
                              text: 'TRANSFORM YOUR LIFE',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontFamily: theme.textTheme.titleLarge?.fontFamily,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fade(duration: 800.ms).scale(begin: const Offset(0.9, 0.9)),
                      
                      const SizedBox(height: 16),
                      
                      Text(
                        'Start your fitness journey\nwith us today',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          color: AppColors.darkTextSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ).animate().fade(duration: 1000.ms),

                      const SizedBox(height: 36),

                      // Get Started Button
                      CustomButton(
                        text: 'Get Started',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterScreen()),
                          );
                        },
                      ).animate().fade(duration: 1100.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 20),

                      // Bottom Login Redirection
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.darkTextSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const LoginScreen()),
                              );
                            },
                            child: Text(
                              'Login',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ).animate().fade(duration: 1200.ms),
                      const SizedBox(height: 12),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
