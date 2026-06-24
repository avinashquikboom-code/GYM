import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/trainer_providers.dart';
import 'trainer_member_details_screen.dart';

class TrainerMembersTab extends ConsumerWidget {
  const TrainerMembersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final members = ref.watch(trainerMembersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'My Clients',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: members.isEmpty
            ? Center(
                child: Text(
                  'No assigned members yet.',
                  style: theme.textTheme.bodyLarge,
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return _buildMemberCard(context, ref, member, index)
                      .animate()
                      .fade(duration: Duration(milliseconds: 300 + (index * 100)))
                      .slideY(begin: 0.1, end: 0);
                },
              ),
      ),
    );
  }

  Widget _buildMemberCard(BuildContext context, WidgetRef ref, GymMember member, int index) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
          // Member Profile Details
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: NetworkImage(member.avatarUrl),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      member.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      member.planName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 12,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${member.currentWeight} kg',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Progress bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Program Progress',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    '${(member.progressPercentage * 100).toInt()}%',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 12,
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: member.progressPercentage,
                  backgroundColor: isDark ? AppColors.darkInput : AppColors.lightInput,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
                  minHeight: 8,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Actions Row
          LayoutBuilder(
            builder: (context, constraints) {
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildMiniActionBtn(
                    context,
                    label: 'Details',
                    icon: Icons.visibility_outlined,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TrainerMemberDetailsScreen(memberId: member.id),
                        ),
                      );
                    },
                  ),
                  _buildMiniActionBtn(
                    context,
                    label: 'Measure',
                    icon: Icons.edit_note_rounded,
                    onTap: () => _showUpdateMeasurementsDialog(context, ref, member),
                  ),
                  _buildMiniActionBtn(
                    context,
                    label: 'Workout',
                    icon: Icons.fitness_center_rounded,
                    onTap: () => _showAssignWorkoutDialog(context, ref, member),
                  ),
                  _buildMiniActionBtn(
                    context,
                    label: 'Diet',
                    icon: Icons.restaurant_rounded,
                    onTap: () => _showAssignDietDialog(context, ref, member),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniActionBtn(
    BuildContext context, {
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: AppColors.primaryGreen),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Action Dialogs
  void _showUpdateMeasurementsDialog(BuildContext context, WidgetRef ref, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final weightController = TextEditingController(text: member.currentWeight.toString());
    final chestController = TextEditingController(text: member.chest.toString());
    final waistController = TextEditingController(text: member.waist.toString());
    final bicepsController = TextEditingController(text: member.biceps.toString());
    final thighController = TextEditingController(text: member.thigh.toString());
    final fatController = TextEditingController(text: member.bodyFat.toString());

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
                    'Update Measurements',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    'Update specs for ${member.name}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Weight (kg)',
                          controller: weightController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Body Fat (%)',
                          controller: fatController,
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
                          hintText: 'Chest (cm)',
                          controller: chestController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Waist (cm)',
                          controller: waistController,
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
                          hintText: 'Biceps (cm)',
                          controller: bicepsController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Thigh (cm)',
                          controller: thighController,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Save Update',
                    onPressed: () {
                      final wt = double.tryParse(weightController.text) ?? member.currentWeight;
                      final ch = double.tryParse(chestController.text) ?? member.chest;
                      final ws = double.tryParse(waistController.text) ?? member.waist;
                      final bc = double.tryParse(bicepsController.text) ?? member.biceps;
                      final th = double.tryParse(thighController.text) ?? member.thigh;
                      final ft = double.tryParse(fatController.text) ?? member.bodyFat;

                      ref.read(trainerMembersProvider.notifier).updateMeasurements(
                            member.id,
                            chest: ch,
                            waist: ws,
                            biceps: bc,
                            thigh: th,
                            bodyFat: ft,
                            weight: wt,
                          );

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Measurements updated for ${member.name}!"),
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

  void _showAssignWorkoutDialog(BuildContext context, WidgetRef ref, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final plans = [
      'Elite Weight Loss Pro',
      'Hypertrophy Muscle Build',
      'Strength & Conditioning L3',
      'Functional Endurance Plan'
    ];

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
                  'Assign Workout Plan',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ...plans.map((plan) {
                  final isSelected = member.planName == plan;
                  return ListTile(
                    title: Text(
                      plan,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? AppColors.primaryGreen : null,
                      ),
                    ),
                    onTap: () {
                      ref.read(trainerMembersProvider.notifier).assignWorkoutPlan(member.id, plan);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Assigned $plan to ${member.name}!"),
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

  void _showAssignDietDialog(BuildContext context, WidgetRef ref, GymMember member) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final diets = [
      'Keto Shred Plan (High Fat, Low Carb)',
      'High Protein Lean Bulk (Clean Carbs)',
      'Balanced Caloric Deficit (1800 kcal)',
      'Vegan Muscle Maintenance Plan'
    ];

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
                  'Assign Diet Plan',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                ...diets.map((diet) {
                  return ListTile(
                    title: Text(diet),
                    onTap: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Assigned $diet to ${member.name}!"),
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
}
