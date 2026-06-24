import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/trainer_providers.dart';

class TrainerWorkoutTab extends ConsumerStatefulWidget {
  const TrainerWorkoutTab({super.key});

  @override
  ConsumerState<TrainerWorkoutTab> createState() => _TrainerWorkoutTabState();
}

class _TrainerWorkoutTabState extends ConsumerState<TrainerWorkoutTab> {
  // Mock workout database list
  final List<TrainerWorkoutPlan> _workoutPlans = [
    TrainerWorkoutPlan(
      workoutName: 'Elite Weight Loss Pro',
      day: 'Monday',
      exercise: 'Barbell Squat',
      sets: 4,
      reps: 12,
      restTime: '60s',
    ),
    TrainerWorkoutPlan(
      workoutName: 'Elite Weight Loss Pro',
      day: 'Monday',
      exercise: 'Dumbbell Lunge',
      sets: 3,
      reps: 15,
      restTime: '45s',
    ),
    TrainerWorkoutPlan(
      workoutName: 'Hypertrophy Muscle Build',
      day: 'Wednesday',
      exercise: 'Incline Bench Press',
      sets: 4,
      reps: 10,
      restTime: '90s',
    ),
    TrainerWorkoutPlan(
      workoutName: 'Hypertrophy Muscle Build',
      day: 'Wednesday',
      exercise: 'Weighted Pull-Ups',
      sets: 4,
      reps: 8,
      restTime: '90s',
    ),
    TrainerWorkoutPlan(
      workoutName: 'Strength & Conditioning L3',
      day: 'Friday',
      exercise: 'Deadlift',
      sets: 5,
      reps: 5,
      restTime: '120s',
    ),
  ];

  void _showCreateOrUpdatePlanDialog({TrainerWorkoutPlan? existingPlan, int? index}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final planNameController = TextEditingController(text: existingPlan?.workoutName ?? 'New Workout Routine');
    final dayController = TextEditingController(text: existingPlan?.day ?? 'Monday');
    final exerciseController = TextEditingController(text: existingPlan?.exercise ?? '');
    final setsController = TextEditingController(text: existingPlan?.sets.toString() ?? '4');
    final repsController = TextEditingController(text: existingPlan?.reps.toString() ?? '12');
    final restController = TextEditingController(text: existingPlan?.restTime ?? '60s');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    existingPlan != null ? 'Edit Workout Plan' : 'Create Workout Plan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Workout Plan Name (e.g. Lean Bulk)',
                    controller: planNameController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    hintText: 'Day of Week (e.g. Monday)',
                    controller: dayController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    hintText: 'Exercise Name (e.g. Bench Press)',
                    controller: exerciseController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Sets',
                          controller: setsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Reps',
                          controller: repsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Rest (e.g. 60s)',
                          controller: restController,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: existingPlan != null ? 'Update Plan' : 'Create Plan',
                    onPressed: () {
                      final name = planNameController.text.trim();
                      final day = dayController.text.trim();
                      final exercise = exerciseController.text.trim();
                      final sets = int.tryParse(setsController.text) ?? 4;
                      final reps = int.tryParse(repsController.text) ?? 12;
                      final rest = restController.text.trim();

                      if (exercise.isEmpty || name.isEmpty || day.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill out all required fields.'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }

                      final newPlan = TrainerWorkoutPlan(
                        workoutName: name,
                        day: day,
                        exercise: exercise,
                        sets: sets,
                        reps: reps,
                        restTime: rest,
                      );

                      setState(() {
                        if (existingPlan != null && index != null) {
                          _workoutPlans[index] = newPlan;
                        } else {
                          _workoutPlans.add(newPlan);
                        }
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(existingPlan != null
                              ? 'Workout plan updated successfully!'
                              : 'Workout plan created successfully!'),
                          backgroundColor: AppColors.primaryGreen,
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAssignDialog(TrainerWorkoutPlan plan) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final members = ref.read(trainerMembersProvider);

    showModalBottomSheet(
      context: context,
      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Assign Plan to Member',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                if (members.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text('No active members available.'),
                  )
                else
                  ...members.map((member) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(member.avatarUrl),
                      ),
                      title: Text(member.name),
                      subtitle: Text(member.planName),
                      onTap: () {
                        ref.read(trainerMembersProvider.notifier).assignWorkoutPlan(
                              member.id,
                              plan.workoutName,
                            );
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Assigned '${plan.workoutName}' to ${member.name}!"),
                            backgroundColor: AppColors.primaryGreen,
                          ),
                        );
                      },
                    );
                  }),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: _workoutPlans.isEmpty
          ? Center(
              child: Text(
                'No workout plans created yet.',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              itemCount: _workoutPlans.length,
              itemBuilder: (context, index) {
                final plan = _workoutPlans[index];
                final setsRepsStr = '${plan.sets} Sets x ${plan.reps} Reps | Rest: ${plan.restTime}';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Left workout icon representation
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.fitness_center_rounded,
                          color: AppColors.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Center text details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    plan.day.toUpperCase(),
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primaryGreen,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    plan.workoutName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              plan.exercise,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              setsRepsStr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right Action Buttons (Assign & Edit)
                      Column(
                        children: [
                          GestureDetector(
                            onTap: () => _showAssignDialog(plan),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: AppColors.primaryGreen.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_add_alt_1_rounded,
                                color: AppColors.primaryGreen,
                                size: 16,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => _showCreateOrUpdatePlanDialog(existingPlan: plan, index: index),
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.edit_outlined,
                                color: isDark ? Colors.white : Colors.black,
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ).animate().fade(duration: 200.ms);
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () => _showCreateOrUpdatePlanDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
