import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _isMetric = true; // true = kg/cm, false = lbs/inches
  bool _twoFactorAuth = false;
  bool _privateProfile = false;
  bool _autoPlayVideos = true;
  String _selectedLanguage = 'English';

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 20, bottom: 8),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title.toUpperCase(),
          style: theme.textTheme.titleSmall?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: (iconColor ?? AppColors.primaryGreen).withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: iconColor ?? AppColors.primaryGreen,
            size: 20,
          ),
        ),
        title: Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
            fontSize: 11,
          ),
        ),
        trailing: trailing ?? (onTap != null ? const Icon(Icons.chevron_right, size: 20) : null),
        onTap: onTap,
      ),
    );
  }

  void _showLanguageSelector() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.bottom: 20,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Text(
                  'Select Language',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ...['English', 'Spanish', 'French', 'Hindi', 'German'].map((lang) {
                  final isSelected = _selectedLanguage == lang;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                    title: Text(
                      lang,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primaryGreen : null,
                      ),
                    ),
                    trailing: isSelected ? const Icon(Icons.check, color: AppColors.primaryGreen) : null,
                    onTap: () {
                      setState(() => _selectedLanguage = lang);
                      Navigator.pop(context);
                    },
                  );
                }),
              ],
            ),
          ),
        );
      },
    );
  }

  void _clearCache() {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        title: const Text('Clear Cache'),
        content: const Text('Are you sure you want to clear the app cache? This will redownload media assets next time you use the app.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('App cache cleared successfully!'),
                  backgroundColor: AppColors.success,
                ),
              );
            },
            child: const Text(
              'Clear',
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final themeMode = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          children: [
            // App Appearance Section
            _buildSectionHeader(context, 'Appearance'),
            _buildSettingTile(
              context: context,
              icon: isDark ? Icons.dark_mode_outlined : Icons.light_mode_outlined,
              title: 'Dark Mode',
              subtitle: 'Change the visual appearance of the application',
              trailing: Switch(
                value: isDark,
                activeThumbColor: AppColors.primaryGreen,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  themeNotifier.toggleTheme();
                },
              ),
            ).animate().fade(duration: 200.ms),

            // Account & Security Section
            _buildSectionHeader(context, 'Account & Security'),
            _buildSettingTile(
              context: context,
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              subtitle: 'Update your login password securely',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Change password flow initiated.')),
                );
              },
            ).animate().fade(duration: 300.ms),
            _buildSettingTile(
              context: context,
              icon: Icons.security_outlined,
              title: 'Two-Factor Authentication',
              subtitle: 'Secure your gym profile with verification codes',
              trailing: Switch(
                value: _twoFactorAuth,
                activeThumbColor: AppColors.primaryGreen,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  setState(() => _twoFactorAuth = value);
                },
              ),
            ).animate().fade(duration: 350.ms),

            // Preferences Section
            _buildSectionHeader(context, 'Preferences'),
            _buildSettingTile(
              context: context,
              icon: Icons.scale_outlined,
              title: 'Unit System',
              subtitle: _isMetric ? 'Metric (kg, cm, km)' : 'Imperial (lbs, inches, miles)',
              trailing: Switch(
                value: _isMetric,
                activeThumbColor: AppColors.primaryGreen,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  setState(() => _isMetric = value);
                },
              ),
            ).animate().fade(duration: 400.ms),
            _buildSettingTile(
              context: context,
              icon: Icons.translate_rounded,
              title: 'Language',
              subtitle: _selectedLanguage,
              onTap: _showLanguageSelector,
            ).animate().fade(duration: 450.ms),
            _buildSettingTile(
              context: context,
              icon: Icons.play_circle_outline_rounded,
              title: 'Auto-play Workout Videos',
              subtitle: 'Play exercise demonstration clips automatically',
              trailing: Switch(
                value: _autoPlayVideos,
                activeThumbColor: AppColors.primaryGreen,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  setState(() => _autoPlayVideos = value);
                },
              ),
            ).animate().fade(duration: 500.ms),

            // Privacy Section
            _buildSectionHeader(context, 'Privacy'),
            _buildSettingTile(
              context: context,
              icon: Icons.visibility_off_outlined,
              title: 'Private Profile',
              subtitle: 'Only share workouts and logs with approved trainers',
              trailing: Switch(
                value: _privateProfile,
                activeThumbColor: AppColors.primaryGreen,
                inactiveTrackColor: Colors.grey.withOpacity(0.3),
                onChanged: (value) {
                  setState(() => _privateProfile = value);
                },
              ),
            ).animate().fade(duration: 550.ms),

            // Developer / Advanced Section
            _buildSectionHeader(context, 'Advanced'),
            _buildSettingTile(
              context: context,
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              title: 'Clear App Cache',
              subtitle: 'Delete locally cached images and workout databases',
              onTap: _clearCache,
            ).animate().fade(duration: 600.ms),

            const SizedBox(height: 32),

            // App Info Section
            Center(
              child: Column(
                children: [
                  Text(
                    'GYM Application',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Version 1.0.0 (Build 42)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ).animate().fade(duration: 700.ms),
          ],
        ),
      ),
    );
  }
}
