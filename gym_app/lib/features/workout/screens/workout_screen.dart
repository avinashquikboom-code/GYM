import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_urls.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/workout_provider.dart';
import '../widgets/exercise_card.dart';

class WorkoutScreen extends ConsumerWidget {
  const WorkoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final workoutState = ref.watch(workoutProvider);
    final workoutNotifier = ref.read(workoutProvider.notifier);

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    // Map workout days to chest, back, legs, arms, shoulders, cardio, rest
    final dayRoutines = [
      {'title': 'Chest Day', 'subtitle': 'Build Your Chest', 'image': AppUrls.welcomeBgImage},
      {'title': 'Back Day', 'subtitle': 'Strengthen Your Lats', 'image': AppUrls.benchPressImage},
      {'title': 'Legs Day', 'subtitle': 'Sculpt Your Quadriceps', 'image': AppUrls.inclineDumbbellPressImage},
      {'title': 'Arms Day', 'subtitle': 'Pump Your Biceps & Triceps', 'image': AppUrls.chestFlyImage},
      {'title': 'Shoulders Day', 'subtitle': 'Define Your Shoulders', 'image': AppUrls.pushUpsImage},
      {'title': 'Cardio Day', 'subtitle': 'Increase Your Stamina', 'image': AppUrls.welcomeBgImage},
      {'title': 'Rest Day', 'subtitle': 'Recovery & Rest', 'image': AppUrls.benchPressImage},
    ];

    final exercises = [
      {'id': 'ex1', 'title': 'Bench Press', 'setsReps': '4 Sets x 12 Reps', 'image': AppUrls.benchPressImage},
      {'id': 'ex2', 'title': 'Incline Dumbbell Press', 'setsReps': '4 Sets x 12 Reps', 'image': AppUrls.inclineDumbbellPressImage},
      {'id': 'ex3', 'title': 'Chest Fly', 'setsReps': '3 Sets x 15 Reps', 'image': AppUrls.chestFlyImage},
      {'id': 'ex4', 'title': 'Push Ups', 'setsReps': '3 Sets x Max Reps', 'image': AppUrls.pushUpsImage},
    ];

    final currentRoutine = dayRoutines[workoutState.selectedDayIndex];

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
                    'Workout Plan',
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
                        final isSelected = workoutState.selectedDayIndex == index;
                        return GestureDetector(
                          onTap: () => workoutNotifier.selectDay(index),
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

            // Main Routine Details
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Exercise Routine Hero Card
                    Container(
                      width: double.infinity,
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(currentRoutine['image'] as String),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.55),
                            BlendMode.srcOver,
                          ),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              currentRoutine['title'] as String,
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              currentRoutine['subtitle'] as String,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fade(duration: 500.ms).scaleY(begin: 0.95),

                    const SizedBox(height: 24),

                    // Exercises Checklist
                    if (workoutState.selectedDayIndex == 6) ...[
                      // Rest Day State
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.hotel_rounded,
                                size: 64,
                                color: AppColors.primaryGreen,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'It is Rest Day!',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Give your muscles some time to recover and grow.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ] else ...[
                      // Standard Workout Day
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: exercises.length,
                        itemBuilder: (context, index) {
                          final ex = exercises[index];
                          final id = ex['id'] as String;
                          final isCompleted = workoutState.completedExerciseIds.contains(id);

                          return ExerciseCard(
                            title: ex['title'] as String,
                            setsReps: ex['setsReps'] as String,
                            imageUrl: ex['image'] as String,
                            isCompleted: isCompleted,
                            onTapPlay: () {
                              workoutNotifier.toggleExerciseCompletion(id);
                            },
                          ).animate().fade(duration: (600 + index * 80).ms).slideX(begin: 0.05, end: 0);
                        },
                      ),
                    ],
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Start/Finish Button at Bottom
            if (workoutState.selectedDayIndex != 6)
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: CustomButton(
                  text: workoutState.isWorkoutActive 
                      ? 'Finish Workout (${workoutState.completedExerciseIds.length}/${exercises.length} Done)'
                      : 'Start Workout',
                  backgroundColor: workoutState.isWorkoutActive ? AppColors.secondaryGreen : null,
                  onPressed: () {
                    if (workoutState.isWorkoutActive) {
                      // Finish workout
                      workoutNotifier.stopWorkout();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Great job! Workout session saved successfully.'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else {
                      // Start workout
                      workoutNotifier.startWorkout();
                    }
                  },
                ).animate().fade(duration: 400.ms),
              ),
          ],
        ),
      ),
    );
  }
}
