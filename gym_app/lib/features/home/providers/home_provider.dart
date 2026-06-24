import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/services/storage_service.dart';

class UserMetrics {
  final double weightStart;
  final double weightCurrent;
  final double chest;
  final double waist;
  final double biceps;
  final double bodyFat;
  final double muscleMass;
  final double bmi;
  final List<String> weightHistory;

  UserMetrics({
    required this.weightStart,
    required this.weightCurrent,
    required this.chest,
    required this.waist,
    required this.biceps,
    required this.bodyFat,
    required this.muscleMass,
    required this.bmi,
    required this.weightHistory,
  });

  double get weightDiff => weightCurrent - weightStart;

  UserMetrics copyWith({
    double? weightStart,
    double? weightCurrent,
    double? chest,
    double? waist,
    double? biceps,
    double? bodyFat,
    double? muscleMass,
    double? bmi,
    List<String>? weightHistory,
  }) {
    return UserMetrics(
      weightStart: weightStart ?? this.weightStart,
      weightCurrent: weightCurrent ?? this.weightCurrent,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      biceps: biceps ?? this.biceps,
      bodyFat: bodyFat ?? this.bodyFat,
      muscleMass: muscleMass ?? this.muscleMass,
      bmi: bmi ?? this.bmi,
      weightHistory: weightHistory ?? this.weightHistory,
    );
  }
}

class HomeNotifier extends StateNotifier<UserMetrics> {
  final StorageService _storageService;

  HomeNotifier(this._storageService)
      : super(UserMetrics(
          weightStart: _storageService.getWeightStart(),
          weightCurrent: _storageService.getWeightCurrent(),
          chest: _storageService.getChest(),
          waist: _storageService.getWaist(),
          biceps: _storageService.getBiceps(),
          bodyFat: _storageService.getBodyFat(),
          muscleMass: _storageService.getMuscleMass(),
          bmi: _storageService.getBmi(),
          weightHistory: _storageService.getWeightHistory(),
        ));

  Future<void> updateWeight(double newWeight) async {
    await _storageService.setWeightCurrent(newWeight);
    
    // Add to history
    final history = List<String>.from(state.weightHistory);
    // Simple mock date stamp
    final date = _getMockDateString();
    history.add('$date:$newWeight');
    // Limit to last 8 records
    if (history.length > 8) {
      history.removeAt(0);
    }
    await _storageService.setWeightHistory(history);

    // Recalculate BMI based on mock height (1.71m)
    final double height = 1.71;
    final bmi = newWeight / (height * height);
    final formattedBmi = double.parse(bmi.toStringAsFixed(1));
    await _storageService.setBmi(formattedBmi);

    state = state.copyWith(
      weightCurrent: newWeight,
      weightHistory: history,
      bmi: formattedBmi,
    );
  }

  Future<void> updateMeasurements({
    double? chest,
    double? waist,
    double? biceps,
    double? bodyFat,
    double? muscleMass,
  }) async {
    if (chest != null) {
      await _storageService.setChest(chest);
    }
    if (waist != null) {
      await _storageService.setWaist(waist);
    }
    if (biceps != null) {
      await _storageService.setBiceps(biceps);
    }
    if (bodyFat != null) {
      await _storageService.setBodyFat(bodyFat);
    }
    if (muscleMass != null) {
      await _storageService.setMuscleMass(muscleMass);
    }

    state = state.copyWith(
      chest: chest ?? state.chest,
      waist: waist ?? state.waist,
      biceps: biceps ?? state.biceps,
      bodyFat: bodyFat ?? state.bodyFat,
      muscleMass: muscleMass ?? state.muscleMass,
    );
  }

  String _getMockDateString() {
    final now = DateTime.now();
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${now.day.toString().padLeft(2, '0')} ${months[now.month - 1]}';
  }
}

final homeProvider = StateNotifierProvider<HomeNotifier, UserMetrics>((ref) {
  final storageService = ref.read(storageServiceProvider);
  return HomeNotifier(storageService);
});
