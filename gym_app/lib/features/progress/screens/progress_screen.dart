import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/plan_toggle_button.dart';
import '../../home/providers/home_provider.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key});

  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  int _selectedStatTab = 0; // 0: Weight, 1: Body Fat, 2: Muscle Mass
  final _weightInputController = TextEditingController();

  @override
  void dispose() {
    _weightInputController.dispose();
    super.dispose();
  }

  void _showAddWeightDialog(BuildContext context, double currentWeight) {
    _weightInputController.text = currentWeight.toString();
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          title: const Text('Log Current Weight'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _weightInputController,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight (kg)',
                  hintText: 'e.g. 68.2',
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final double? weight = double.tryParse(_weightInputController.text);
                if (weight != null && weight > 0) {
                  ref.read(homeProvider.notifier).updateWeight(weight);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Weight logged: $weight kg'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.black,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final metrics = ref.watch(homeProvider);

    // Prepare chart data points
    final List<FlSpot> spots = [];
    final List<String> xLabels = [];
    
    for (int i = 0; i < metrics.weightHistory.length; i++) {
      final parts = metrics.weightHistory[i].split(':');
      final date = parts[0];
      final weight = double.tryParse(parts.length > 1 ? parts[1] : '') ?? 70.0;
      spots.add(FlSpot(i.toDouble(), weight));
      xLabels.add(date);
    }

    final double minW = spots.isNotEmpty ? spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) : 60.0;
    final double maxW = spots.isNotEmpty ? spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) : 80.0;
    final double range = maxW - minW;
    final double minY = minW - (range > 0 ? range * 0.2 : 4);
    final double maxY = maxW + (range > 0 ? range * 0.2 : 4);

    final diff = metrics.weightDiff;
    final diffText = '${diff > 0 ? '+' : ''}${diff.toStringAsFixed(1)} kg';

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(AppTheme.platformBackIcon),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Progress',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Segmented Tabs Selector
              SegmentedToggle(
                options: const ['Weight', 'Body Fat', 'Muscle Mass'],
                selectedIndex: _selectedStatTab,
                onSelected: (index) {
                  setState(() {
                    _selectedStatTab = index;
                  });
                },
              ).animate().fade(duration: 300.ms),

              const SizedBox(height: 24),

              // Current Stat Banner
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedStatTab == 0
                              ? '${metrics.weightCurrent} kg'
                              : (_selectedStatTab == 1 
                                  ? '${metrics.bodyFat.toInt()}%' 
                                  : '${metrics.muscleMass.toInt()} kg'),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          _selectedStatTab == 0
                              ? 'Current Weight'
                              : (_selectedStatTab == 1 ? 'Body Fat Ratio' : 'Muscle Mass Content'),
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _selectedStatTab == 0
                            ? diffText
                            : (_selectedStatTab == 1 ? '-4.0%' : '+3.2 kg'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: (_selectedStatTab == 0 ? diff <= 0 : true) 
                              ? AppColors.primaryGreen 
                              : AppColors.error,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Text(
                        'vs Joined',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ).animate().fade(duration: 400.ms),

              const SizedBox(height: 24),

              // Large Interactive Line Chart
              Container(
                height: 220,
                padding: const EdgeInsets.only(right: 20, top: 12, bottom: 8),
                child: spots.isEmpty 
                    ? const Center(child: Text('No historical logs logged.'))
                    : LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            getDrawingHorizontalLine: (value) => FlLine(
                              color: isDark ? AppColors.darkDivider.withOpacity(0.5) : AppColors.lightDivider,
                              strokeWidth: 1,
                            ),
                          ),
                          titlesData: FlTitlesData(
                            show: true,
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: 4,
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    '${value.toInt()}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                      fontSize: 10,
                                    ),
                                  );
                                },
                              ),
                            ),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final idx = value.toInt();
                                  if (idx >= 0 && idx < xLabels.length) {
                                    return Padding(
                                      padding: const EdgeInsets.only(top: 6.0),
                                      child: Text(
                                        xLabels[idx],
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                          fontSize: 10,
                                        ),
                                      ),
                                    );
                                  }
                                  return const SizedBox.shrink();
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          minX: 0,
                          maxX: (spots.length - 1).toDouble(),
                          minY: minY,
                          maxY: maxY,
                          lineBarsData: [
                            LineChartBarData(
                              spots: spots,
                              isCurved: true,
                              color: AppColors.primaryGreen,
                              barWidth: 3,
                              isStrokeCapRound: true,
                              dotData: FlDotData(
                                show: true,
                                getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                                  radius: 4,
                                  color: AppColors.primaryGreen,
                                  strokeColor: isDark ? AppColors.darkBackground : Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                              belowBarData: BarAreaData(
                                show: true,
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryGreen.withOpacity(0.25),
                                    AppColors.primaryGreen.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
              ).animate().fade(duration: 500.ms),

              const SizedBox(height: 24),

              // Progress Summary Section
              Text(
                'Progress Summary',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ).animate().fade(duration: 550.ms),
              const SizedBox(height: 12),

              Row(
                children: [
                  _buildSummaryCard(context, 'Weight Lost', '${diff <= 0 ? -diff : 0.0} kg', Icons.fitness_center),
                  const SizedBox(width: 12),
                  _buildSummaryCard(context, 'Body Fat Lost', '4%', Icons.pie_chart_outline),
                  const SizedBox(width: 12),
                  _buildSummaryCard(context, 'Muscle Gained', '3.2 kg', Icons.trending_up),
                ],
              ).animate().fade(duration: 600.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 28),

              // Photos Progress Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Photos Progress',
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: GestureDetector(
                      onTap: () {
                        // Transformations gallery navigation
                      },
                      child: Text(
                        'See your transformation',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ).animate().fade(duration: 650.ms),
              const SizedBox(height: 12),

              // Horizontal transformation photos list
              SizedBox(
                height: 150,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildTransformationPhoto(context, 'Before (May 10)', AppUrls.beforePhoto),
                    const SizedBox(width: 12),
                    _buildTransformationPhoto(context, 'After (July 01)', AppUrls.afterPhoto),
                  ],
                ),
              ).animate().fade(duration: 700.ms),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddWeightDialog(context, metrics.weightCurrent),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.black,
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, String label, String value, IconData icon) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 24),
            const SizedBox(height: 10),
            Text(
              value,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 10,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransformationPhoto(BuildContext context, String label, String imageUrl) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: 130,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: isDark ? AppColors.darkInput : AppColors.lightInput,
                  child: const Icon(Icons.image_not_supported, color: Colors.grey),
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                color: Colors.black.withOpacity(0.6),
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
