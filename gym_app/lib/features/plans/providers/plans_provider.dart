import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/services/storage_service.dart';

class PlansState {
  final int selectedPeriodIndex; // 0 for Monthly, 1 for Quarterly
  final String activePlan;

  PlansState({
    required this.selectedPeriodIndex,
    required this.activePlan,
  });

  PlansState copyWith({
    int? selectedPeriodIndex,
    String? activePlan,
  }) {
    return PlansState(
      selectedPeriodIndex: selectedPeriodIndex ?? this.selectedPeriodIndex,
      activePlan: activePlan ?? this.activePlan,
    );
  }
}

class PlansNotifier extends StateNotifier<PlansState> {
  final StorageService _storageService;

  PlansNotifier(this._storageService)
      : super(PlansState(
          selectedPeriodIndex: 0, // Default to Monthly
          activePlan: _storageService.getActivePlan(),
        ));

  void setPeriodIndex(int index) {
    state = state.copyWith(selectedPeriodIndex: index);
  }

  Future<void> selectPlan(String planName) async {
    await _storageService.setActivePlan(planName);
    state = state.copyWith(activePlan: planName);
  }
}

final plansProvider = StateNotifierProvider<PlansNotifier, PlansState>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return PlansNotifier(storageService);
});
