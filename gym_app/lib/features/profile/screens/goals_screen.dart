import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class GoalsScreen extends StatefulWidget {
  const GoalsScreen({super.key});

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  // Available fitness goals
  final List<Map<String, dynamic>> _goals = [
    {
      'title': 'Lose Weight',
      'subtitle': 'Burn fat and get leaner',
      'icon': Icons.trending_down_rounded,
      'selected': false,
    },
    {
      'title': 'Build Muscle',
      'subtitle': 'Gain muscle mass and strength',
      'icon': Icons.fitness_center_rounded,
      'selected': true, // Pre-selected as per mock user info
    },
    {
      'title': 'Stay Fit & Healthy',
      'subtitle': 'Maintain weight and improve wellness',
      'icon': Icons.favorite_border_rounded,
      'selected': true,
    },
    {
      'title': 'Increase Endurance',
      'subtitle': 'Optimize stamina and cardio health',
      'icon': Icons.bolt_rounded,
      'selected': false,
    },
    {
      'title': 'Powerlifting',
      'subtitle': 'Maximize raw strength on main lifts',
      'icon': Icons.sports_gymnastics_rounded,
      'selected': false,
    },
    {
      'title': 'Flexibility & Yoga',
      'subtitle': 'Improve mobility and range of motion',
      'icon': Icons.self_improvement_rounded,
      'selected': false,
    },
  ];

  bool _isSaving = false;

  void _saveGoals() async {
    setState(() {
      _isSaving = true;
    });

    // Simulate saving
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() {
        _isSaving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Fitness goals updated!'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Fitness Goals',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(20.0),
                itemCount: _goals.length,
                itemBuilder: (context, index) {
                  final goal = _goals[index];
                  final isSelected = goal['selected'] as bool;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primaryGreen 
                            : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Material(
                      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      borderRadius: BorderRadius.circular(15),
                      clipBehavior: Clip.antiAlias,
                      child: ListTile(
                        onTap: () {
                          setState(() {
                            _goals[index]['selected'] = !isSelected;
                          });
                        },
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        leading: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.primaryGreen.withOpacity(0.15) 
                                : (isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.05)),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            goal['icon'] as IconData,
                            color: isSelected ? AppColors.primaryGreen : Colors.grey,
                            size: 22,
                          ),
                        ),
                        title: Text(
                          goal['title'] as String,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: isSelected ? AppColors.primaryGreen : (isDark ? Colors.white : Colors.black),
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 4.0),
                          child: Text(
                            goal['subtitle'] as String,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        trailing: Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          color: isSelected ? AppColors.primaryGreen : Colors.grey.withOpacity(0.5),
                          size: 24,
                        ),
                      ),
                    ),
                  ).animate().fade(duration: (300 + index * 100).ms).slideY(begin: 0.05, end: 0);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: CustomButton(
                text: 'Save Goals',
                isLoading: _isSaving,
                onPressed: _saveGoals,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
