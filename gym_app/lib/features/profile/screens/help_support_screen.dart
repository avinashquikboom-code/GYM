import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  static const List<Map<String, String>> _faqs = [
    {
      'question': 'How do I log my daily workouts?',
      'answer': 'Go to the Workout tab, click on your Active Workout, and tap the play icon next to each exercise. Mark sets as completed to track your stats.',
    },
    {
      'question': 'How is my BMI calculated?',
      'answer': 'Your Body Mass Index (BMI) is calculated automatically based on your height and current weight entries logged in your profile/measurements.',
    },
    {
      'question': 'Can I change my active subscription plan?',
      'answer': 'Yes, navigate to the Plan tab from the bottom bar, select the Monthly/Quarterly toggle, and select Choose Plan on any basic, standard, or premium tier.',
    },
    {
      'question': 'How do I reset my progress history?',
      'answer': 'Go to Profile -> Personal Information, or contact support if you need to wipe out historical logs. You can also sign out and log back in to clear local cache.',
    },
    {
      'question': 'How do I enable daily workout reminders?',
      'answer': 'Go to Profile -> Notifications, and turn on the toggle switch for Daily Workout Reminders.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Support Card info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryGreen.withOpacity(0.2),
                      Colors.transparent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppColors.primaryGreen.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Need Urgent Assistance?',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Our 24/7 helpdesk is ready to assist you with gym access, billing queries, or fitness logs.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        height: 1.4,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.email_outlined, color: AppColors.primaryGreen, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'support@gymfitnessclub.com',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.phone_outlined, color: AppColors.primaryGreen, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          '+91 1800-459-2810 (Toll Free)',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.05, end: 0),
              
              const SizedBox(height: 28),
              
              Text(
                'Frequently Asked Questions',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ).animate().fade(duration: 450.ms),
              const SizedBox(height: 12),

              // FAQ List Accordions
              ..._faqs.map((faq) {
                final idx = _faqs.indexOf(faq);
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                    ),
                  ),
                  child: Theme(
                    data: theme.copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      iconColor: AppColors.primaryGreen,
                      collapsedIconColor: Colors.grey,
                      title: Text(
                        faq['question']!,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
                          child: Text(
                            faq['answer']!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 12,
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(duration: (500 + idx * 80).ms);
              }),
            ],
          ),
        ),
      ),
    );
  }
}
