import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../providers/home_provider.dart';

class BodyOverviewCard extends StatelessWidget {
  final UserMetrics metrics;
  final VoidCallback onViewDetails;

  const BodyOverviewCard({
    super.key,
    required this.metrics,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final diff = metrics.weightDiff;
    final diffText = '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg';
    final diffColor = diff <= 0 ? AppColors.primaryGreen : AppColors.error;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Your Body Overview',
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: onViewDetails,
                child: Row(
                  children: [
                    Text(
                      'View Details',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    const Icon(
                      Icons.chevron_right,
                      color: AppColors.primaryGreen,
                      size: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Overview Details
          Row(
            children: [
              // Left Metrics Column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetricItem(
                      context,
                      'When You Joined',
                      '${metrics.weightStart} kg',
                      null,
                    ),
                    const SizedBox(height: 20),
                    _buildMetricItem(
                      context,
                      'Chest',
                      '${metrics.chest.toInt()} cm',
                      Icons.arrow_downward,
                      iconColor: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 20),
                    _buildMetricItem(
                      context,
                      'Waist',
                      '${metrics.waist.toInt()} cm',
                      Icons.arrow_downward,
                      iconColor: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 20),
                    _buildMetricItem(
                      context,
                      'Biceps',
                      '${metrics.biceps.toInt()} cm',
                      Icons.arrow_downward,
                      iconColor: AppColors.primaryGreen,
                    ),
                  ],
                ),
              ),

              // Center Anatomy Vector Illustration
              Expanded(
                flex: 4,
                child: Center(
                  child: SizedBox(
                    height: 200,
                    width: 90,
                    child: CustomPaint(
                      painter: BodyAnatomyPainter(),
                    ),
                  ),
                ),
              ),

              // Right Metrics Column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMetricItem(
                      context,
                      'Today',
                      '${metrics.weightCurrent} kg',
                      null,
                      subtitle: Text(
                        diffText,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: diffColor,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildMetricItem(
                      context,
                      'Body Fat',
                      '${metrics.bodyFat.toInt()}%',
                      Icons.arrow_downward,
                      iconColor: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 20),
                    _buildMetricItem(
                      context,
                      'Muscle Mass',
                      '${metrics.muscleMass.toInt()} kg',
                      Icons.arrow_upward,
                      iconColor: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 20),
                    _buildMetricItem(
                      context,
                      'BMI',
                      '${metrics.bmi}',
                      Icons.arrow_downward,
                      iconColor: AppColors.primaryGreen,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context,
    String title,
    String value,
    IconData? trendIcon, {
    Color? iconColor,
    Widget? subtitle,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (trendIcon != null) ...[
              const SizedBox(width: 4),
              Icon(
                trendIcon,
                size: 14,
                color: iconColor ?? theme.primaryColor,
              ),
            ],
          ],
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          subtitle,
        ],
      ],
    );
  }
}

// Custom Painter to draw a sleek, high-fidelity muscular body avatar
class BodyAnatomyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primaryGreen.withOpacity(0.15)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.primaryGreen
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final double w = size.width;
    final double h = size.height;

    // Draw stylized head
    canvas.drawCircle(Offset(w / 2, h * 0.12), w * 0.12, paint);
    canvas.drawCircle(Offset(w / 2, h * 0.12), w * 0.12, linePaint);

    // Draw neck
    final neckPath = Path()
      ..moveTo(w * 0.45, h * 0.18)
      ..lineTo(w * 0.45, h * 0.22)
      ..lineTo(w * 0.55, h * 0.22)
      ..lineTo(w * 0.55, h * 0.18)
      ..close();
    canvas.drawPath(neckPath, paint);
    canvas.drawPath(neckPath, linePaint);

    // Draw shoulders & chest/torso
    final torsoPath = Path()
      ..moveTo(w * 0.2, h * 0.24) // Left shoulder outer
      ..quadraticBezierTo(w * 0.35, h * 0.22, w * 0.5, h * 0.24) // Neck collar right
      ..moveTo(w * 0.8, h * 0.24) // Right shoulder outer
      ..quadraticBezierTo(w * 0.65, h * 0.22, w * 0.5, h * 0.24)
      ..lineTo(w * 0.2, h * 0.24)
      ..quadraticBezierTo(w * 0.15, h * 0.35, w * 0.25, h * 0.45) // Left lat
      ..lineTo(w * 0.32, h * 0.6) // Left waist
      ..lineTo(w * 0.68, h * 0.6) // Right waist
      ..lineTo(w * 0.75, h * 0.45) // Right lat
      ..quadraticBezierTo(w * 0.85, h * 0.35, w * 0.8, h * 0.24)
      ..close();
    canvas.drawPath(torsoPath, paint);
    canvas.drawPath(torsoPath, linePaint);

    // Draw arms (biceps/forearms)
    final leftArmPath = Path()
      ..moveTo(w * 0.2, h * 0.24)
      ..quadraticBezierTo(w * 0.05, h * 0.35, w * 0.12, h * 0.48) // Left outer arm
      ..lineTo(w * 0.22, h * 0.4) // Left inner arm
      ..close();
    canvas.drawPath(leftArmPath, paint);
    canvas.drawPath(leftArmPath, linePaint);

    final rightArmPath = Path()
      ..moveTo(w * 0.8, h * 0.24)
      ..quadraticBezierTo(w * 0.95, h * 0.35, w * 0.88, h * 0.48) // Right outer arm
      ..lineTo(w * 0.78, h * 0.4) // Right inner arm
      ..close();
    canvas.drawPath(rightArmPath, paint);
    canvas.drawPath(rightArmPath, linePaint);

    // Draw hips
    final hipsPath = Path()
      ..moveTo(w * 0.32, h * 0.6)
      ..lineTo(w * 0.28, h * 0.68)
      ..lineTo(w * 0.72, h * 0.68)
      ..lineTo(w * 0.68, h * 0.6)
      ..close();
    canvas.drawPath(hipsPath, paint);
    canvas.drawPath(hipsPath, linePaint);

    // Draw legs
    final leftLegPath = Path()
      ..moveTo(w * 0.3, h * 0.68)
      ..lineTo(w * 0.22, h * 0.82) // Left outer thigh
      ..lineTo(w * 0.26, h * 0.96) // Left calf
      ..lineTo(w * 0.38, h * 0.96) // Left inner foot
      ..lineTo(w * 0.46, h * 0.8) // Left inner thigh
      ..close();
    canvas.drawPath(leftLegPath, paint);
    canvas.drawPath(leftLegPath, linePaint);

    final rightLegPath = Path()
      ..moveTo(w * 0.7, h * 0.68)
      ..lineTo(w * 0.78, h * 0.82) // Right outer thigh
      ..lineTo(w * 0.74, h * 0.96) // Right calf
      ..lineTo(w * 0.62, h * 0.96) // Right inner foot
      ..lineTo(w * 0.54, h * 0.8) // Right inner thigh
      ..close();
    canvas.drawPath(rightLegPath, paint);
    canvas.drawPath(rightLegPath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
