import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../auth/screens/welcome_screen.dart';
import '../../plans/providers/plans_provider.dart';
import '../../progress/screens/progress_screen.dart';
import '../../dashboard/screens/main_dashboard.dart';
import 'personal_info_screen.dart';
import 'payment_history_screen.dart';
import 'goals_screen.dart';
import 'notifications_settings_screen.dart';
import 'help_support_screen.dart';
import 'settings_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final authState = ref.watch(authProvider);
    final plansState = ref.watch(plansProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            children: [
              // User Info Header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primaryGreen,
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(45),
                        child: Image.network(
                          AppUrls.profileAvatar,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            child: const Icon(Icons.person, size: 48, color: Colors.grey),
                          ),
                        ),
                      ),
                    ).animate().fade(duration: 400.ms).scale(),
                    const SizedBox(height: 16),
                    Text(
                      authState.userName.isNotEmpty ? authState.userName : 'Rahul Sharma',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ).animate().fade(duration: 500.ms),
                    const SizedBox(height: 2),
                    Text(
                      authState.userEmail.isNotEmpty ? authState.userEmail : 'rahulsharma@gmail.com',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                      ),
                    ).animate().fade(duration: 600.ms),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Menu Section Lists
              Column(
                children: [
                  _buildMenuItem(
                    context,
                    icon: Icons.person_outline,
                    title: 'Personal Information',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PersonalInfoScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.card_membership_outlined,
                    title: 'Membership',
                    trailingText: plansState.activePlan,
                    onTap: () {
                      ref.read(dashboardTabProvider.notifier).state = 1;
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.payment_outlined,
                    title: 'Payment History',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PaymentHistoryScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.straighten_outlined,
                    title: 'My Measurements',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ProgressScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.adjust_outlined,
                    title: 'Goals',
                    trailingText: 'Get Strong & Fit',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const GoalsScreen()),
                      );
                    },
                  ),
                  _buildMenuItem(
                    context,
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()),
                      );
                    },
                  ),
                  // Theme Center Card
                  Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.palette_outlined,
                              color: AppColors.primaryGreen,
                              size: 22,
                            ),
                            const SizedBox(width: 16),
                            Text(
                              'Theme Center',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            // Default Theme Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => themeNotifier.setDarkMode(true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isDark 
                                        ? AppColors.primaryGreen.withOpacity(0.08) 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isDark 
                                          ? AppColors.primaryGreen 
                                          : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                                      width: isDark ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.dark_mode_outlined,
                                        color: isDark ? AppColors.primaryGreen : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Default Theme',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 12,
                                          fontWeight: isDark ? FontWeight.bold : FontWeight.normal,
                                          color: isDark ? AppColors.primaryGreen : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Custom Theme Button
                            Expanded(
                              child: GestureDetector(
                                onTap: () => themeNotifier.setDarkMode(false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !isDark 
                                        ? AppColors.primaryGreen.withOpacity(0.08) 
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: !isDark 
                                          ? AppColors.primaryGreen 
                                          : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                                      width: !isDark ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.light_mode_outlined,
                                        color: !isDark ? AppColors.primaryGreen : Colors.grey,
                                        size: 20,
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Custom Theme',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          fontSize: 12,
                                          fontWeight: !isDark ? FontWeight.bold : FontWeight.normal,
                                          color: !isDark ? AppColors.primaryGreen : null,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  _buildMenuItem(
                    context,
                    icon: Icons.help_outline,
                    title: 'Help & Support',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpSupportScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // Logout Button List
                  _buildMenuItem(
                    context,
                    icon: Icons.logout,
                    title: 'Logout',
                    iconColor: AppColors.error,
                    textColor: AppColors.error,
                    showArrow: false,
                    onTap: () async {
                      // Show confirmation dialog before logout
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          title: const Text('Logout'),
                          content: const Text('Are you sure you want to sign out?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: Text(
                                'Cancel',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.error,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Logout'),
                            ),
                          ],
                        ),
                      );

                      if (!context.mounted) return;

                      if (confirm == true) {
                        final navigator = Navigator.of(context);
                        await ref.read(authProvider.notifier).logout();
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const WelcomeScreen()),
                          (route) => false,
                        );
                      }
                    },
                  ),
                ],
              ).animate().fade(duration: 700.ms).slideY(begin: 0.1, end: 0),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? trailingText,
    Color? iconColor,
    Color? textColor,
    bool showArrow = true,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          width: 1,
        ),
      ),
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(15),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          onTap: onTap,
          leading: Icon(
            icon,
            color: iconColor ?? AppColors.primaryGreen,
            size: 22,
          ),
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor ?? (isDark ? Colors.white : Colors.black),
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (trailingText != null) ...[
                Text(
                  trailingText,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
