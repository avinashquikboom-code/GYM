import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/widgets/custom_button.dart';
import 'welcome_screen.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Hide status bar on onboarding screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  final List<Map<String, String>> _slides = [
    {
      'title': 'Track Your Workouts',
      'description': 'Log exercises, mark sets completed, and stay motivated with structured routines tailored to you.',
      'image': AppUrls.benchPressImage,
    },
    {
      'title': 'Monitor Your Diet',
      'description': 'Manage meal logs, calculate calories consumed dynamically, and hit your fitness targets daily.',
      'image': AppUrls.chickenRiceImage,
    },
    {
      'title': 'Transform Your Body',
      'description': 'Log weight entries, update biceps/waist metrics, and track progress on interactive graphs.',
      'image': AppUrls.welcomeBgImage,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _finishOnboarding() async {
    final storage = ref.read(storageServiceProvider);
    await storage.setOnboardingCompleted(true);
    // Restore status bar for all other screens
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : AppColors.lightBackground,
      body: Stack(
        children: [
          // Onboarding Page Slides
          PageView.builder(
            controller: _pageController,
            itemCount: _slides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final slide = _slides[index];
              return Stack(
                children: [
                  // Full-screen background image
                  Positioned.fill(
                    child: Image.network(
                      slide['image']!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: isDark ? AppColors.darkBackground : AppColors.lightBackground,
                      ),
                    ),
                  ),
                  
                  // Black Overlay Gradient
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withOpacity(0.3),
                            Colors.black.withOpacity(0.6),
                            Colors.black,
                          ],
                          stops: const [0.0, 0.45, 0.85],
                        ),
                      ),
                    ),
                  ),

                  // Texts Content Layout
                  SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            slide['title']!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              fontSize: 32,
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                            ),
                          ).animate().fade(duration: 400.ms).slideY(begin: 0.2, end: 0),
                          
                          const SizedBox(height: 12),
                          
                          Text(
                            slide['description']!,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: AppColors.darkTextSecondary,
                              fontSize: 15,
                              height: 1.4,
                            ),
                          ).animate().fade(duration: 600.ms),
                          
                          const SizedBox(height: 140), // Reserved space for buttons/indicator
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // Skip Button Top Right
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                'Skip',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          // Bottom Controls (Indicator Dots & Button)
          Positioned(
            bottom: 40,
            left: 24,
            right: 24,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Horizontal Slide Indicator dots
                Row(
                  children: List.generate(_slides.length, (index) {
                    final isActive = _currentPageIndex == index;
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: isActive ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        color: isActive ? AppColors.primaryGreen : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),

                // Next/Get Started Button
                CustomButton(
                  text: _currentPageIndex == _slides.length - 1 ? 'Get Started' : 'Next',
                  width: 140,
                  height: 50,
                  borderRadius: 12,
                  onPressed: () {
                    if (_currentPageIndex < _slides.length - 1) {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                      );
                    } else {
                      _finishOnboarding();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
