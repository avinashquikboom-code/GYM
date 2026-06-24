import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class ExerciseCard extends StatelessWidget {
  final String title;
  final String setsReps;
  final String imageUrl;
  final bool isCompleted;
  final VoidCallback onTapPlay;

  const ExerciseCard({
    super.key,
    required this.title,
    required this.setsReps,
    required this.imageUrl,
    this.isCompleted = false,
    required this.onTapPlay,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCompleted 
              ? AppColors.primaryGreen.withOpacity(0.5) 
              : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
          width: isCompleted ? 1.5 : 1,
        ),
      ),
      child: Row(
        children: [
          // Left Exercise Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: 64,
                height: 64,
                color: isDark ? AppColors.darkInput : AppColors.lightInput,
                child: const Icon(Icons.image, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Center Text Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted 
                        ? (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary)
                        : (isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  setsReps,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Right Play Button (toggles to Green check if completed)
          GestureDetector(
            onTap: onTapPlay,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: isCompleted 
                    ? AppColors.primaryGreen.withOpacity(0.15) 
                    : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.play_arrow,
                  color: isCompleted ? AppColors.primaryGreen : (isDark ? Colors.white : Colors.black),
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
