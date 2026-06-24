import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/trainer_providers.dart';
import '../../home/widgets/progress_line_chart.dart';
import 'trainer_body_transformation_screen.dart';

class TrainerMemberDetailsScreen extends ConsumerWidget {
  final String memberId;

  const TrainerMemberDetailsScreen({super.key, required this.memberId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final members = ref.watch(trainerMembersProvider);
    final member = members.firstWhere((m) => m.id == memberId, orElse: () => members.first);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          member.name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 3D Body Transformation Navigation Card
              _buildTransformationPromo(context, member)
                  .animate()
                  .fade(duration: 300.ms)
                  .slideY(begin: 0.1, end: 0),
              const SizedBox(height: 24),

              // Personal Information Section
              _buildSectionHeader(context, 'Personal Information'),
              const SizedBox(height: 12),
              _buildPersonalInfoCard(context, member)
                  .animate()
                  .fade(duration: 400.ms),
              const SizedBox(height: 24),

              // Measurements Section
              _buildSectionHeader(context, 'Current Measurements'),
              const SizedBox(height: 12),
              _buildMeasurementsCard(context, member)
                  .animate()
                  .fade(duration: 500.ms),
              const SizedBox(height: 24),

              // Compliance Section
              _buildSectionHeader(context, 'Compliance Overview'),
              const SizedBox(height: 12),
              _buildComplianceCard(context, member)
                  .animate()
                  .fade(duration: 600.ms),
              const SizedBox(height: 24),

              // Progress Chart Section
              _buildSectionHeader(context, 'Weight Progress Chart'),
              const SizedBox(height: 12),
              _buildProgressChartCard(context, member)
                  .animate()
                  .fade(duration: 700.ms),
              const SizedBox(height: 24),

              // Attendance History Section
              _buildSectionHeader(context, 'Attendance Log'),
              const SizedBox(height: 12),
              _buildAttendanceCard(context, member)
                  .animate()
                  .fade(duration: 800.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildTransformationPromo(BuildContext context, GymMember member) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryGreen,
            AppColors.secondaryGreen,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.threed_rotation,
                color: Colors.black,
                size: 28,
              ),
              const SizedBox(width: 12),
              Text(
                '3D Body Transformation',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Visualize, rotate, and zoom the before, current, and goal body models for ${member.name}. Compare body stats side-by-side.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: Colors.black.withOpacity(0.8),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: 'Launch 3D Viewer',
            backgroundColor: Colors.black,
            textColor: AppColors.primaryGreen,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TrainerBodyTransformationScreen(memberId: member.id),
                ),
              );
            },
            height: 48,
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard(BuildContext context, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
        children: [
          _buildInfoRow(context, 'Name', member.name),
          const Divider(height: 24),
          _buildInfoRow(context, 'Age', '${member.age} Years'),
          const Divider(height: 24),
          _buildInfoRow(context, 'Height', '${member.height} cm'),
          const Divider(height: 24),
          _buildInfoRow(context, 'Weight', '${member.currentWeight} kg'),
          const Divider(height: 24),
          _buildInfoRow(context, 'Gender', member.gender),
        ],
      ),
    );
  }

  Widget _buildMeasurementsCard(BuildContext context, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : Colors.transparent,
          width: 1,
        ),
      ),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        childAspectRatio: 2.2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 16,
        children: [
          _buildMeasurementGridItem(context, 'Chest', '${member.chest} cm'),
          _buildMeasurementGridItem(context, 'Waist', '${member.waist} cm'),
          _buildMeasurementGridItem(context, 'Biceps', '${member.biceps} cm'),
          _buildMeasurementGridItem(context, 'Thigh', '${member.thigh} cm'),
          _buildMeasurementGridItem(context, 'Body Fat', '${member.bodyFat}%'),
          _buildMeasurementGridItem(context, 'BMI', '${member.bmi}'),
        ],
      ),
    );
  }

  Widget _buildMeasurementGridItem(BuildContext context, String title, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: theme.textTheme.titleMedium?.copyWith(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildComplianceCard(BuildContext context, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : Colors.transparent,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildComplianceIndicator(
              context,
              title: 'Workout Compliance',
              percentage: member.workoutCompliance,
              color: AppColors.primaryGreen,
            ),
          ),
          Container(
            height: 60,
            width: 1,
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
          ),
          Expanded(
            child: _buildComplianceIndicator(
              context,
              title: 'Diet Compliance',
              percentage: member.dietCompliance,
              color: AppColors.secondaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComplianceIndicator(
    BuildContext context, {
    required String title,
    required double percentage,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              height: 68,
              width: 68,
              child: CircularProgressIndicator(
                value: percentage,
                strokeWidth: 6,
                backgroundColor: isDark ? AppColors.darkInput : AppColors.lightInput,
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              '${(percentage * 100).toInt()}%',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildProgressChartCard(BuildContext context, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 180,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : Colors.transparent,
          width: 1,
        ),
      ),
      child: ProgressLineChart(
        values: member.weightHistory,
        isMini: false,
      ),
    );
  }

  Widget _buildAttendanceCard(BuildContext context, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
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
        children: [
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: member.attendanceHistory.length,
            separatorBuilder: (context, index) => Divider(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              height: 24,
            ),
            itemBuilder: (context, index) {
              final record = member.attendanceHistory[index];
              final dateStr = '${record.date.day}/${record.date.month}/${record.date.year}';
              
              Color statusColor;
              if (record.status == 'Present') {
                statusColor = AppColors.success;
              } else if (record.status == 'Late') {
                statusColor = AppColors.warning;
              } else {
                statusColor = AppColors.error;
              }

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateStr,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      record.status,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
