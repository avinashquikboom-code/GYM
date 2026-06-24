import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/auth_provider.dart';
import '../widgets/social_login_button.dart';
import 'register_screen.dart';
import '../../dashboard/screens/main_dashboard.dart';
import '../../trainer/providers/trainer_providers.dart';
import '../../trainer/screens/trainer_dashboard.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'rahul@gmail.com');
  final _passwordController = TextEditingController(text: 'password123');
  bool _isTrainer = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_isTrainer) {
      // Trainer Login flow
      final success = await ref.read(trainerAuthProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const TrainerDashboard()),
          (route) => false,
        );
      } else if (mounted) {
        final error = ref.read(trainerAuthProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Trainer login failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } else {
      // Member Login flow
      final success = await ref.read(authProvider.notifier).login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const MainDashboard()),
          (route) => false,
        );
      } else if (mounted) {
        final error = ref.read(authProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Login failed'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    final authState = ref.watch(authProvider);
    final trainerAuthState = ref.watch(trainerAuthProvider);
    final isLoading = _isTrainer ? trainerAuthState.isLoading : authState.isLoading;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isTrainer 
                        ? 'Login to access your trainer portal' 
                        : 'Login to continue your fitness journey',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Role Switcher Toggle Widget
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightInput,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkDivider : Colors.transparent,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _isTrainer = false;
                              _emailController.text = 'rahul@gmail.com';
                              _passwordController.text = 'password123';
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                color: !_isTrainer ? AppColors.primaryGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Member Login',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: !_isTrainer ? Colors.black : (isDark ? Colors.white : Colors.black),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _isTrainer = true;
                              _emailController.text = 'coach.marcus@gym.com';
                              _passwordController.text = 'trainer123';
                            }),
                            child: Container(
                              decoration: BoxDecoration(
                                color: _isTrainer ? AppColors.primaryGreen : Colors.transparent,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Trainer Login',
                                style: theme.textTheme.labelLarge?.copyWith(
                                  color: _isTrainer ? Colors.black : (isDark ? Colors.white : Colors.black),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Email Input
                  CustomTextField(
                    hintText: _isTrainer ? 'Trainer Email Address' : 'Email Address',
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!value.contains('@')) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Password Input
                  CustomTextField(
                    hintText: 'Password',
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: const Icon(Icons.lock_outline),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  // Forgot Password Action
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _isTrainer 
                                  ? 'Trainer password reset link dispatched.' 
                                  : 'Member password reset link dispatched.'
                            ),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                      },
                      child: Text(
                        'Forgot Password?',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 36),

                  // Login Trigger Button
                  CustomButton(
                    text: _isTrainer ? 'Login as Trainer' : 'Login',
                    isLoading: isLoading,
                    onPressed: _handleLogin,
                  ),

                  // Member-only registration and social options
                  if (!_isTrainer) ...[
                    const SizedBox(height: 24),

                    // Or Continue With Separator
                    Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            'or continue with',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // Social Media Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialLoginButton(
                          icon: Icons.g_mobiledata, // Symbolizing Google
                          backgroundColor: Colors.white,
                          iconColor: Colors.black,
                          onTap: () {
                            _emailController.text = 'google.rahul@gmail.com';
                            _passwordController.text = 'password123';
                            _handleLogin();
                          },
                        ),
                        const SizedBox(width: 16),
                        SocialLoginButton(
                          icon: Icons.facebook, // Symbolizing Facebook
                          backgroundColor: const Color(0xFF1877F2),
                          iconColor: Colors.white,
                          onTap: () {
                            _emailController.text = 'fb.rahul@gmail.com';
                            _passwordController.text = 'password123';
                            _handleLogin();
                          },
                        ),
                        const SizedBox(width: 16),
                        SocialLoginButton(
                          icon: Icons.apple, // Symbolizing Apple
                          backgroundColor: Colors.black,
                          iconColor: Colors.white,
                          onTap: () {
                            _emailController.text = 'apple.rahul@gmail.com';
                            _passwordController.text = 'password123';
                            _handleLogin();
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 36),

                    // Bottom Register Redirect
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const RegisterScreen()),
                            );
                          },
                          child: Text(
                            'Register',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primaryGreen,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
