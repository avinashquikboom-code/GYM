import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkoutState {
  final int selectedDayIndex; // 0 for Mon, 6 for Sun
  final List<String> completedExerciseIds;
  final bool isWorkoutActive;

  WorkoutState({
    required this.selectedDayIndex,
    required this.completedExerciseIds,
    required this.isWorkoutActive,
  });

  WorkoutState copyWith({
    int? selectedDayIndex,
    List<String>? completedExerciseIds,
    bool? isWorkoutActive,
  }) {
    return WorkoutState(
      selectedDayIndex: selectedDayIndex ?? this.selectedDayIndex,
      completedExerciseIds: completedExerciseIds ?? this.completedExerciseIds,
      isWorkoutActive: isWorkoutActive ?? this.isWorkoutActive,
    );
  }
}

class WorkoutNotifier extends StateNotifier<WorkoutState> {
  WorkoutNotifier()
      : super(WorkoutState(
          selectedDayIndex: 0, // Monday is default
          completedExerciseIds: [],
          isWorkoutActive: false,
        ));

  void selectDay(int index) {
    state = state.copyWith(
      selectedDayIndex: index,
      // Clear completions on day switch to reset logs
      completedExerciseIds: [],
    );
  }

  void toggleExerciseCompletion(String id) {
    final list = List<String>.from(state.completedExerciseIds);
    if (list.contains(id)) {
      list.remove(id);
    } else {
      list.add(id);
    }
    state = state.copyWith(completedExerciseIds: list);
  }

  void startWorkout() {
    state = state.copyWith(isWorkoutActive: true);
  }

  void stopWorkout() {
    state = state.copyWith(isWorkoutActive: false, completedExerciseIds: []);
  }
}

final workoutProvider = StateNotifierProvider<WorkoutNotifier, WorkoutState>((ref) {
  return WorkoutNotifier();
});
