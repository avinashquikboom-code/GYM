import 'package:flutter_riverpod/flutter_riverpod.dart';

class DietState {
  final int selectedDayIndex; // 0 for Mon, 6 for Sun
  final List<String> completedMealIds;
  final int dailyGoalKcal;

  DietState({
    required this.selectedDayIndex,
    required this.completedMealIds,
    required this.dailyGoalKcal,
  });

  DietState copyWith({
    int? selectedDayIndex,
    List<String>? completedMealIds,
    int? dailyGoalKcal,
  }) {
    return DietState(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      completedMealIds: completedMealIds ?? this.completedMealIds,
      dailyGoalKcal: dailyGoalKcal ?? this.dailyGoalKcal,
    );
  }
}

class DietNotifier extends StateNotifier<DietState> {
  DietNotifier()
      : super(DietState(
          selectedDayIndex: 0, // Monday default
          completedMealIds: ['breakfast', 'lunch', 'evening'], // Default mock completed meals (total = 350 + 550 + 160 = 1060, plus dinner/snack logic)
          dailyGoalKcal: 2000,
        ));

  void selectDay(int index) {
    state = state.copyWith(
      selectedDayIndex: index,
      // Default completed meals for demo when switching days
      completedMealIds: index % 2 == 0 ? ['breakfast', 'lunch', 'evening'] : ['breakfast', 'dinner'],
    );
  }

  void toggleMealCompletion(String id) {
    final list = List<String>.from(state.completedMealIds);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(completedMealIds: list);
  }

  int getLoggedCalories(List<Map<String, dynamic>> meals) {
    int total = 0;
    for (final meal in meals) {
      if (state.completedMealIds.contains(meal['id'])) {
        total += meal['calories'] as int;
      }
    }
    return total;
  }
}

final dietProvider = StateNotifierProvider<DietNotifier, DietState>((ref) {
  return DietNotifier();
});
