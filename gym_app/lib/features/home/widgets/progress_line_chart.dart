import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';

class ProgressLineChart extends StatelessWidget {
  final List<double> values;
  final bool isMini;

  const ProgressLineChart({
    super.key,
    required this.values,
    this.isMini = true,
  });

  @override
  Widget build(BuildContext context) {
    if (values.isEmpty) return const SizedBox.shrink();

    // Map list of weights to spots
    final spots = List.generate(
      values.length,
      (index) => FlSpot(index.toDouble(), values[index]),
    );

    // Calculate dynamic padding for bounds
    final minWeight = values.reduce((a, b) => a < b ? a : b);
    final maxWeight = values.reduce((a, b) => a > b ? a : b);
    final padding = (maxWeight - minWeight) * 0.15;
    final minY = minWeight - (padding > 0 ? padding : 5.0);
    final maxY = maxWeight + (padding > 0 ? padding : 5.0);

    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: false),
        titlesData: const FlTitlesData(show: false),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (values.length - 1).toDouble(),
        minY: minY,
        maxY: maxY,
        lineTouchData: const LineTouchData(enabled: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primaryGreen,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  AppColors.primaryGreen.withOpacity(0.3),
                  AppColors.primaryGreen.withOpacity(0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
