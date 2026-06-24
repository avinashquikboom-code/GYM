import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/trainer_providers.dart';
import '../../home/widgets/progress_line_chart.dart';
import 'trainer_notifications_screen.dart';

class TrainerHomeTab extends ConsumerWidget {
  const TrainerHomeTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final authState = ref.watch(trainerAuthProvider);
    final members = ref.watch(trainerMembersProvider);
    final attendance = ref.watch(trainerAttendanceProvider);

    final trainerName = authState.trainer?.name ?? 'Trainer';
    final totalMembers = authState.trainer?.assignedMembers ?? members.length;
    final activeMembers = authState.trainer?.activeMembersCount ?? 9;
    final todaySessions = 4; // Mock today sessions
    final pendingCheckins = attendance.where((r) => r.status == 'Pending').length;

    // Mock progress chart values for the overview cards
    final memberGrowthData = [5.0, 7.0, 8.0, 10.0, 11.0, 12.0];
    final sessionData = [2.0, 4.0, 3.0, 5.0, 4.0, 4.0];
    final activeRateData = [75.0, 80.0, 78.0, 85.0, 90.0, 92.0];
    final checkinTrend = [1.0, 3.0, 2.0, 0.0, 1.0, 2.0];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Hello, $trainerName',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(width: 4),
                const Text(
                  '👋',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            Text(
              'Your clients are ready to train',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 11,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TrainerNotificationsScreen()),
                  );
                },
              ),
              Positioned(
                right: 12,
                top: 12,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryGreen,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Performance Overview',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),

              // Grid of Overview Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  _buildOverviewCard(
                    context,
                    title: 'Total Members',
                    value: '$totalMembers',
                    subtitle: '+2 this week',
                    chartValues: memberGrowthData,
                  ).animate().fade(duration: 300.ms).slideY(begin: 0.1, end: 0),
                  
                  _buildOverviewCard(
                    context,
                    title: 'Active Members',
                    value: '$activeMembers',
                    subtitle: '92% Active Rate',
                    chartValues: activeRateData,
                  ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

                  _buildOverviewCard(
                    context,
                    title: "Today's Sessions",
                    value: '$todaySessions',
                    subtitle: '2 completed',
                    chartValues: sessionData,
                  ).animate().fade(duration: 500.ms).slideY(begin: 0.1, end: 0),

                  _buildOverviewCard(
                    context,
                    title: 'Pending Check-ins',
                    value: '$pendingCheckins',
                    subtitle: 'Awaiting scan',
                    chartValues: checkinTrend,
                    isWarning: pendingCheckins > 0,
                  ).animate().fade(duration: 600.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
              const SizedBox(height: 28),

              // Dynamic Workout Compliance leaderboard
              _buildComplianceLeaderboard(context, members).animate().fade(duration: 700.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required List<double> chartValues,
    bool isWarning = false,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: isWarning ? AppColors.warning : AppColors.darkTextPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              color: isWarning ? AppColors.warning.withOpacity(0.8) : AppColors.primaryGreen,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          // Small sparkline chart
          SizedBox(
            height: 40,
            child: ProgressLineChart(
              values: chartValues,
              isMini: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceLeaderboard(BuildContext context, List<GymMember> members) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Client Compliance Leaderboard',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: members.length,
            separatorBuilder: (context, index) => Divider(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              height: 20,
            ),
            itemBuilder: (context, index) {
              final member = members[index];
              final averageCompliance = (member.workoutCompliance + member.dietCompliance) / 2;

              return Row(
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(member.avatarUrl),
                    radius: 18,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          member.name,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          member.planName,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${(averageCompliance * 100).toInt()}%',
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      Text(
                        'Compliance',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
