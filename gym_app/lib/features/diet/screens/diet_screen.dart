import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_urls.dart';
import '../providers/diet_provider.dart';
import '../widgets/meal_card.dart';

class DietScreen extends ConsumerWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dietState = ref.watch(dietProvider);
    final dietNotifier = ref.read(dietProvider.notifier);

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    final meals = [
      {
        'id': 'breakfast',
        'category': 'Breakfast',
        'dishName': 'Oatmeal with Fruits',
        'portionCalories': '1 Bowl • 350 kcal',
        'calories': 350,
        'image': AppUrls.oatmealImage,
      },
      {
        'id': 'mid_morning',
        'category': 'Mid Morning',
        'dishName': 'Protein Shake',
        'portionCalories': '1 Glass • 200 kcal',
        'calories': 200,
        'image': AppUrls.proteinShakeImage,
      },
      {
        'id': 'lunch',
        'category': 'Lunch',
        'dishName': 'Grilled Chicken with Rice',
        'portionCalories': '1 Plate • 550 kcal',
        'calories': 550,
        'image': AppUrls.chickenRiceImage,
      },
      {
        'id': 'evening',
        'category': 'Evening Snack',
        'dishName': 'Boiled Eggs',
        'portionCalories': '2 Eggs • 160 kcal',
        'calories': 160,
        'image': AppUrls.boiledEggsImage,
      },
      {
        'id': 'dinner',
        'category': 'Dinner',
        'dishName': 'Salad with Paneer',
        'portionCalories': '1 Bowl • 300 kcal',
        'calories': 300,
        'image': AppUrls.saladPaneerImage,
      },
    ];

    // Compute dynamic calorie tracking
    final loggedCalories = dietNotifier.getLoggedCalories(meals);
    final double percent = (loggedCalories / dietState.dailyGoalKcal).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Calendar & Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Diet Plan',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ).animate().fade(duration: 300.ms),
                  const SizedBox(height: 16),

                  // Horizontal Calendar
                  SizedBox(
                    height: 54,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: days.length,
                      itemBuilder: (context, index) {
                        final isSelected = dietState.selectedDayIndex == index;
                        return GestureDetector(
                          onTap: () => dietNotifier.selectDay(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              color: isSelected 
                                  ? AppColors.primaryGreen 
                                  : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected 
                                    ? AppColors.primaryGreen 
                                    : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                days[index],
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isSelected 
                                      ? Colors.black 
                                      : (isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary),
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ).animate().fade(duration: 400.ms),
                ],
              ),
            ),

            // Diet list
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                itemCount: meals.length,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  final id = meal['id'] as String;
                  final isCompleted = dietState.completedMealIds.contains(id);

                  return MealCard(
                    category: meal['category'] as String,
                    dishName: meal['dishName'] as String,
                    portionCalories: meal['portionCalories'] as String,
                    imageUrl: meal['image'] as String,
                    isCompleted: isCompleted,
                    onTap: () {
                      dietNotifier.toggleMealCompletion(id);
                    },
                  ).animate().fade(duration: (500 + index * 80).ms).slideX(begin: -0.05, end: 0);
                },
              ),
            ),

            // Calorie progress bar footer
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Calories',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : Colors.black,
                          ),
                          children: [
                            TextSpan(
                              text: '$loggedCalories',
                              style: TextStyle(
                                color: AppColors.primaryGreen,
                                fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                              ),
                            ),
                            TextSpan(text: ' / ${dietState.dailyGoalKcal} kcal'),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Progress indicator
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 8,
                      backgroundColor: isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.08),
                      valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 400.ms),
          ],
        ),
      ),
    );
  }
}
