import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class MealCard extends StatelessWidget {
  final String category;
  final String dishName;
  final String portionCalories;
  final String imageUrl;
  final bool isCompleted;
  final VoidCallback onTap;

  const MealCard({
    super.key,
    required this.category,
    required this.dishName,
    required this.portionCalories,
    required this.imageUrl,
    this.isCompleted = false,
    required this.onTap,
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
              ? AppColors.primaryGreen.withOpacity(0.4) 
              : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
          width: isCompleted ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            // Left Status Checkbox
            IconButton(
              icon: Icon(
                isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isCompleted ? AppColors.primaryGreen : Colors.grey,
                size: 24,
              ),
              onPressed: onTap,
            ),
            const SizedBox(width: 4),

            // Center details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    dishName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    portionCalories,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),

            // Right Food Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 60,
                  height: 60,
                  color: isDark ? AppColors.darkInput : AppColors.lightInput,
                  child: const Icon(Icons.restaurant, color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
