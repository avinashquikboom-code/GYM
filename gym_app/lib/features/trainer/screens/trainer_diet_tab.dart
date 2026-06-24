import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/trainer_providers.dart';

class TrainerDietTab extends ConsumerStatefulWidget {
  const TrainerDietTab({super.key});

  @override
  ConsumerState<TrainerDietTab> createState() => _TrainerDietTabState();
}

class _TrainerDietTabState extends ConsumerState<TrainerDietTab> {
  // Mock diet plans database
  final List<TrainerDietPlan> _dietPlans = [
    TrainerDietPlan(
      mealName: 'Breakfast',
      foodName: 'Oatmeal with Blueberries & Honey',
      calories: 380,
      protein: 12,
      carbs: 65,
      fats: 6,
    ),
    TrainerDietPlan(
      mealName: 'Mid Morning',
      foodName: 'Greek Yogurt with Almonds',
      calories: 210,
      protein: 15,
      carbs: 10,
      fats: 9,
    ),
    TrainerDietPlan(
      mealName: 'Lunch',
      foodName: 'Grilled Chicken Breast with Quinoa & Broccoli',
      calories: 520,
      protein: 48,
      carbs: 45,
      fats: 8,
    ),
    TrainerDietPlan(
      mealName: 'Evening Snack',
      foodName: 'Whey Protein Shake & Apple',
      calories: 240,
      protein: 26,
      carbs: 22,
      fats: 2,
    ),
    TrainerDietPlan(
      mealName: 'Dinner',
      foodName: 'Baked Salmon with Sweet Potato & Asparagus',
      calories: 460,
      protein: 36,
      carbs: 30,
      fats: 14,
    ),
  ];

  void _showCreateOrUpdateDietDialog({TrainerDietPlan? existingPlan, int? index}) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final mealNameController = TextEditingController(text: existingPlan?.mealName ?? 'Breakfast');
    final foodNameController = TextEditingController(text: existingPlan?.foodName ?? '');
    final caloriesController = TextEditingController(text: existingPlan?.calories.toString() ?? '350');
    final proteinController = TextEditingController(text: existingPlan?.protein.toString() ?? '25');
    final carbsController = TextEditingController(text: existingPlan?.carbs.toString() ?? '30');
    final fatsController = TextEditingController(text: existingPlan?.fats.toString() ?? '8');

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
                    existingPlan != null ? 'Edit Diet Plan' : 'Create Diet Plan',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomTextField(
                    hintText: 'Meal Category (e.g. Breakfast, Lunch)',
                    controller: mealNameController,
                  ),
                  const SizedBox(height: 12),
                  CustomTextField(
                    hintText: 'Food Name (e.g. Scrambled Eggs)',
                    controller: foodNameController,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Calories (kcal)',
                          controller: caloriesController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Protein (g)',
                          controller: proteinController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Carbs (g)',
                          controller: carbsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Fats (g)',
                          controller: fatsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: existingPlan != null ? 'Update Diet' : 'Create Diet',
                    onPressed: () {
                      final category = mealNameController.text.trim();
                      final food = foodNameController.text.trim();
                      final cals = int.tryParse(caloriesController.text) ?? 300;
                      final pro = int.tryParse(proteinController.text) ?? 20;
                      final carb = int.tryParse(carbsController.text) ?? 30;
                      final fat = int.tryParse(fatsController.text) ?? 5;

                      if (food.isEmpty || category.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill out all required fields.'),
                            backgroundColor: AppColors.error,
                          ),
                        );
                        return;
                      }

                      final newPlan = TrainerDietPlan(
                        mealName: category,
                        foodName: food,
                        calories: cals,
                        protein: pro,
                        carbs: carb,
                        fats: fat,
                      );

                      setState(() {
                        if (existingPlan != null && index != null) {
                          _dietPlans[index] = newPlan;
                        } else {
                          _dietPlans.add(newPlan);
                        }
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(existingPlan != null
                              ? 'Diet plan updated successfully!'
                              : 'Diet plan created successfully!'),
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

  void _showAssignDialog(TrainerDietPlan plan) {
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
                  'Assign Diet to Member',
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
                      subtitle: Text('Current plan: ${member.planName}'),
                      onTap: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Assigned diet '${plan.foodName}' to ${member.name}!"),
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
      body: _dietPlans.isEmpty
          ? Center(
              child: Text(
                'No diet plans created yet.',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              itemCount: _dietPlans.length,
              itemBuilder: (context, index) {
                final plan = _dietPlans[index];
                final macroStr = '${plan.calories} kcal | P: ${plan.protein}g | C: ${plan.carbs}g | F: ${plan.fats}g';

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
                      // Left status or representation indicator
                      Container(
                        width: 56,
                        height: 56,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.restaurant_menu_rounded,
                          color: AppColors.primaryGreen,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Center details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              plan.mealName.toUpperCase(),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              plan.foodName,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              macroStr,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Right Actions (Assign & Edit)
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
                            onTap: () => _showCreateOrUpdateDietDialog(existingPlan: plan, index: index),
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
        onPressed: () => _showCreateOrUpdateDietDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
