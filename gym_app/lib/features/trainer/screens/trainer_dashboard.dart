import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'trainer_home_tab.dart';
import 'trainer_members_tab.dart';
import 'trainer_workout_tab.dart'; // We will put the Workout & Diet templates here or build a toggle tab
import 'trainer_diet_tab.dart';
import 'trainer_attendance_tab.dart';
import 'trainer_profile_tab.dart';
import '../../../core/constants/app_colors.dart';

// Provider to manage dashboard active tab index for trainer
final trainerDashboardTabProvider = StateProvider<int>((ref) => 0);

class TrainerDashboard extends ConsumerWidget {
  const TrainerDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(trainerDashboardTabProvider);

    final List<Widget> screens = [
      const TrainerHomeTab(),
      const TrainerMembersTab(),
      const TrainerPlansScreen(), // Contains Workout and Diet builders
      const TrainerAttendanceTab(),
      const TrainerProfileTab(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          ref.read(trainerDashboardTabProvider.notifier).state = index;
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_rounded),
            activeIcon: Icon(Icons.people_rounded),
            label: 'Members',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner_outlined),
            activeIcon: Icon(Icons.qr_code_scanner),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// Sub-screen for Plans with double toggle (Workout and Diet management)
class TrainerPlansScreen extends StatefulWidget {
  const TrainerPlansScreen({super.key});

  @override
  State<TrainerPlansScreen> createState() => _TrainerPlansScreenState();
}

class _TrainerPlansScreenState extends State<TrainerPlansScreen> {
  bool _showWorkouts = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Plan Manager',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Custom toggle selector (same as Member App Toggle Style)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Container(
                height: 52,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightInput,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showWorkouts = true),
                        child: Container(
                          decoration: BoxDecoration(
                            color: _showWorkouts
                                ? AppColors.primaryGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Workout Plans',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: _showWorkouts ? Colors.black : (isDark ? Colors.white : Colors.black),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _showWorkouts = false),
                        child: Container(
                          decoration: BoxDecoration(
                            color: !_showWorkouts
                                ? AppColors.primaryGreen
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'Diet Plans',
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: !_showWorkouts ? Colors.black : (isDark ? Colors.white : Colors.black),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: _showWorkouts
                  ? const TrainerWorkoutTab()
                  : const TrainerDietTab(),
            ),
          ],
        ),
      ),
    );
  }
}
