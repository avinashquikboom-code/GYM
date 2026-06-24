import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _workoutReminders = true;
  bool _mealLogs = true;
  bool _weightReminders = false;
  bool _soundVibration = true;
  bool _communityUpdates = false;

  Widget _buildSwitchCard({
    required BuildContext context,
    required String title,
    required String description,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryGreen,
            inactiveTrackColor: Colors.grey.withOpacity(0.3),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20.0),
          children: [
            _buildSwitchCard(
              context: context,
              title: 'Daily Workout Reminders',
              description: 'Get notified when it is time to hit the gym.',
              value: _workoutReminders,
              icon: Icons.fitness_center_rounded,
              onChanged: (val) => setState(() => _workoutReminders = val),
            ).animate().fade(duration: 300.ms),
            
            _buildSwitchCard(
              context: context,
              title: 'Meal Log Alerts',
              description: 'Remind me to log my breakfast, lunch, and dinner.',
              value: _mealLogs,
              icon: Icons.restaurant_menu_rounded,
              onChanged: (val) => setState(() => _mealLogs = val),
            ).animate().fade(duration: 400.ms),
            
            _buildSwitchCard(
              context: context,
              title: 'Weekly Measurements Check',
              description: 'Remind me to log my body weight and metrics.',
              value: _weightReminders,
              icon: Icons.straighten_rounded,
              onChanged: (val) => setState(() => _weightReminders = val),
            ).animate().fade(duration: 500.ms),
            
            _buildSwitchCard(
              context: context,
              title: 'Sound & Vibration',
              description: 'Play alert sounds and vibrate for reminders.',
              value: _soundVibration,
              icon: Icons.volume_up_rounded,
              onChanged: (val) => setState(() => _soundVibration = val),
            ).animate().fade(duration: 600.ms),
            
            _buildSwitchCard(
              context: context,
              title: 'Community Updates & Offers',
              description: 'Receive newsletters, tips, and promotional offers.',
              value: _communityUpdates,
              icon: Icons.campaign_rounded,
              onChanged: (val) => setState(() => _communityUpdates = val),
            ).animate().fade(duration: 700.ms),
          ],
        ),
      ),
    );
  }
}
