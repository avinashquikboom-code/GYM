import 'package:flutter_riverpod/flutter_riverpod.dart';

// Trainer Model
class TrainerProfile {
  final String name;
  final String email;
  final String phone;
  final String experience;
  final List<String> certifications;
  final int assignedMembers;
  final int activeMembersCount;
  final double successRate;

  TrainerProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.experience,
    required this.certifications,
    required this.assignedMembers,
    required this.activeMembersCount,
    required this.successRate,
  });

  TrainerProfile copyWith({
    String? name,
    String? email,
    String? phone,
    String? experience,
    List<String>? certifications,
    int? assignedMembers,
    int? activeMembersCount,
    double? successRate,
  }) {
    return TrainerProfile(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      experience: experience ?? this.experience,
      certifications: certifications ?? this.certifications,
      assignedMembers: assignedMembers ?? this.assignedMembers,
      activeMembersCount: activeMembersCount ?? this.activeMembersCount,
      successRate: successRate ?? this.successRate,
    );
  }
}

// Member Model
class GymMember {
  final String id;
  final String name;
  final String avatarUrl;
  final double currentWeight;
  final double startWeight;
  final double targetWeight;
  final String planName;
  final double progressPercentage;
  
  // Personal Info
  final int age;
  final double height; // in cm
  final String gender;

  // Measurements
  final double chest; // in cm
  final double waist; // in cm
  final double biceps; // in cm
  final double thigh; // in cm
  final double bodyFat; // in %
  final double bmi;
  final double muscleMass; // in kg

  // Compliance
  final double workoutCompliance; // e.g. 0.85 (85%)
  final double dietCompliance; // e.g. 0.90 (90%)
  
  final List<double> weightHistory;
  final List<AttendanceRecord> attendanceHistory;

  GymMember({
    required this.id,
    required this.name,
    required this.avatarUrl,
    required this.currentWeight,
    required this.startWeight,
    required this.targetWeight,
    required this.planName,
    required this.progressPercentage,
    required this.age,
    required this.height,
    required this.gender,
    required this.chest,
    required this.waist,
    required this.biceps,
    required this.thigh,
    required this.bodyFat,
    required this.bmi,
    required this.muscleMass,
    required this.workoutCompliance,
    required this.dietCompliance,
    required this.weightHistory,
    required this.attendanceHistory,
  });

  GymMember copyWith({
    String? id,
    String? name,
    String? avatarUrl,
    double? currentWeight,
    double? startWeight,
    double? targetWeight,
    String? planName,
    double? progressPercentage,
    int? age,
    double? height,
    String? gender,
    double? chest,
    double? waist,
    double? biceps,
    double? thigh,
    double? bodyFat,
    double? bmi,
    double? muscleMass,
    double? workoutCompliance,
    double? dietCompliance,
    List<double>? weightHistory,
    List<AttendanceRecord>? attendanceHistory,
  }) {
    return GymMember(
      id: id ?? this.id,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      currentWeight: currentWeight ?? this.currentWeight,
      startWeight: startWeight ?? this.startWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      planName: planName ?? this.planName,
      progressPercentage: progressPercentage ?? this.progressPercentage,
      age: age ?? this.age,
      height: height ?? this.height,
      gender: gender ?? this.gender,
      chest: chest ?? this.chest,
      waist: waist ?? this.waist,
      biceps: biceps ?? this.biceps,
      thigh: thigh ?? this.thigh,
      bodyFat: bodyFat ?? this.bodyFat,
      bmi: bmi ?? this.bmi,
      muscleMass: muscleMass ?? this.muscleMass,
      workoutCompliance: workoutCompliance ?? this.workoutCompliance,
      dietCompliance: dietCompliance ?? this.dietCompliance,
      weightHistory: weightHistory ?? this.weightHistory,
      attendanceHistory: attendanceHistory ?? this.attendanceHistory,
    );
  }
}

class AttendanceRecord {
  final DateTime date;
  final String status; // 'Present', 'Absent', 'Late'

  AttendanceRecord({required this.date, required this.status});
}

// Workout Assignment Model
class TrainerWorkoutPlan {
  final String workoutName;
  final String day;
  final String exercise;
  final int sets;
  final int reps;
  final String restTime;

  TrainerWorkoutPlan({
    required this.workoutName,
    required this.day,
    required this.exercise,
    required this.sets,
    required this.reps,
    required this.restTime,
  });
}

// Diet Assignment Model
class TrainerDietPlan {
  final String mealName; // 'Breakfast', 'Mid Morning', 'Lunch', 'Evening Snack', 'Dinner'
  final String foodName;
  final int calories;
  final int protein;
  final int carbs;
  final int fats;

  TrainerDietPlan({
    required this.mealName,
    required this.foodName,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
  });
}

// Auth State
class TrainerAuthState {
  final bool isLoading;
  final bool isAuthenticated;
  final String? errorMessage;
  final TrainerProfile? trainer;

  TrainerAuthState({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.errorMessage,
    this.trainer,
  });

  TrainerAuthState copyWith({
    bool? isLoading,
    bool? isAuthenticated,
    String? errorMessage,
    TrainerProfile? trainer,
  }) {
    return TrainerAuthState(
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      errorMessage: errorMessage,
      trainer: trainer ?? this.trainer,
    );
  }
}

// Auth Notifier
class TrainerAuthNotifier extends StateNotifier<TrainerAuthState> {
  TrainerAuthNotifier() : super(TrainerAuthState());

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate Network Request Delay
    await Future.delayed(const Duration(milliseconds: 1000));

    if (email.isEmpty || password.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Email and password cannot be empty',
      );
      return false;
    }

    if (!email.contains('@')) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid email address',
      );
      return false;
    }

    // Success Mock
    final trainer = TrainerProfile(
      name: 'Coach Marcus',
      email: email,
      phone: '+1 (555) 019-2834',
      experience: '8 Years',
      certifications: ['NASM-CPT', 'FMS Level 2', 'Precision Nutrition L1', 'CPR/AED Certified'],
      assignedMembers: 12,
      activeMembersCount: 9,
      successRate: 94.5,
    );

    state = state.copyWith(
      isLoading: false,
      isAuthenticated: true,
      trainer: trainer,
    );
    return true;
  }

  void logout() {
    state = TrainerAuthState();
  }
}

final trainerAuthProvider = StateNotifierProvider<TrainerAuthNotifier, TrainerAuthState>((ref) {
  return TrainerAuthNotifier();
});

// Members Notifier
class TrainerMembersNotifier extends StateNotifier<List<GymMember>> {
  TrainerMembersNotifier() : super(_initialMembers);

  static final List<GymMember> _initialMembers = [
    GymMember(
      id: 'm1',
      name: 'Rahul Sharma',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150&auto=format&fit=crop',
      currentWeight: 78.4,
      startWeight: 85.0,
      targetWeight: 75.0,
      planName: 'Elite Weight Loss Pro',
      progressPercentage: 0.66,
      age: 26,
      height: 178,
      gender: 'Male',
      chest: 102.5,
      waist: 88.0,
      biceps: 38.2,
      thigh: 56.4,
      bodyFat: 19.5,
      bmi: 24.7,
      muscleMass: 58.2,
      workoutCompliance: 0.88,
      dietCompliance: 0.82,
      weightHistory: [85.0, 83.2, 81.8, 80.5, 79.2, 78.4],
      attendanceHistory: [
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 4)), status: 'Present'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 3)), status: 'Present'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 2)), status: 'Late'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 1)), status: 'Present'),
        AttendanceRecord(date: DateTime.now(), status: 'Present'),
      ],
    ),
    GymMember(
      id: 'm2',
      name: 'Aisha Patel',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=150&auto=format&fit=crop',
      currentWeight: 62.1,
      startWeight: 58.0,
      targetWeight: 63.0,
      planName: 'Hypertrophy Muscle Build',
      progressPercentage: 0.82,
      age: 24,
      height: 165,
      gender: 'Female',
      chest: 91.0,
      waist: 68.5,
      biceps: 28.5,
      thigh: 51.2,
      bodyFat: 21.0,
      bmi: 22.8,
      muscleMass: 43.1,
      workoutCompliance: 0.94,
      dietCompliance: 0.89,
      weightHistory: [58.0, 59.2, 60.1, 61.0, 61.5, 62.1],
      attendanceHistory: [
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 4)), status: 'Present'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 3)), status: 'Present'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 2)), status: 'Present'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 1)), status: 'Present'),
        AttendanceRecord(date: DateTime.now(), status: 'Present'),
      ],
    ),
    GymMember(
      id: 'm3',
      name: 'Vikram Singh',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop',
      currentWeight: 92.5,
      startWeight: 100.0,
      targetWeight: 85.0,
      planName: 'Elite Weight Loss Pro',
      progressPercentage: 0.50,
      age: 32,
      height: 182,
      gender: 'Male',
      chest: 112.0,
      waist: 104.2,
      biceps: 41.0,
      thigh: 62.5,
      bodyFat: 28.2,
      bmi: 27.9,
      muscleMass: 61.0,
      workoutCompliance: 0.76,
      dietCompliance: 0.70,
      weightHistory: [100.0, 98.4, 96.9, 95.1, 93.8, 92.5],
      attendanceHistory: [
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 4)), status: 'Present'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 3)), status: 'Absent'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 2)), status: 'Present'),
        AttendanceRecord(date: DateTime.now().subtract(const Duration(days: 1)), status: 'Present'),
        AttendanceRecord(date: DateTime.now(), status: 'Absent'),
      ],
    ),
  ];

  void updateMeasurements(String memberId, {
    required double chest,
    required double waist,
    required double biceps,
    required double thigh,
    required double bodyFat,
    required double weight,
  }) {
    state = [
      for (final m in state)
        if (m.id == memberId)
          m.copyWith(
            chest: chest,
            waist: waist,
            biceps: biceps,
            thigh: thigh,
            bodyFat: bodyFat,
            currentWeight: weight,
            weightHistory: [...m.weightHistory, weight],
            bmi: double.parse((weight / ((m.height / 100) * (m.height / 100))).toStringAsFixed(1)),
          )
        else
          m
    ];
  }

  void assignWorkoutPlan(String memberId, String planName) {
    state = [
      for (final m in state)
        if (m.id == memberId)
          m.copyWith(planName: planName)
        else
          m
    ];
  }
}

final trainerMembersProvider = StateNotifierProvider<TrainerMembersNotifier, List<GymMember>>((ref) {
  return TrainerMembersNotifier();
});

// Notifications Dispatch State
class TrainerNotification {
  final String id;
  final String memberId;
  final String memberName;
  final String title;
  final String type; // 'Workout', 'Diet', 'Session'
  final DateTime timestamp;

  TrainerNotification({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.title,
    required this.type,
    required this.timestamp,
  });
}

class TrainerNotificationsNotifier extends StateNotifier<List<TrainerNotification>> {
  TrainerNotificationsNotifier() : super([]);

  void sendNotification({
    required String memberId,
    required String memberName,
    required String type,
    required String message,
  }) {
    final newNotif = TrainerNotification(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      memberId: memberId,
      memberName: memberName,
      title: message,
      type: type,
      timestamp: DateTime.now(),
    );
    state = [newNotif, ...state];
  }
}

final trainerNotificationsProvider = StateNotifierProvider<TrainerNotificationsNotifier, List<TrainerNotification>>((ref) {
  return TrainerNotificationsNotifier();
});

// Attendance Management Notifier
class TrainerAttendanceRecord {
  final String memberId;
  final String memberName;
  final String avatarUrl;
  final String status; // 'Present', 'Absent', 'Late', 'Pending'
  final String? time;

  TrainerAttendanceRecord({
    required this.memberId,
    required this.memberName,
    required this.avatarUrl,
    required this.status,
    this.time,
  });

  TrainerAttendanceRecord copyWith({
    String? status,
    String? time,
  }) {
    return TrainerAttendanceRecord(
      memberId: memberId,
      memberName: memberName,
      avatarUrl: avatarUrl,
      status: status ?? this.status,
      time: time ?? this.time,
    );
  }
}

class TrainerAttendanceNotifier extends StateNotifier<List<TrainerAttendanceRecord>> {
  TrainerAttendanceNotifier() : super(_initialRecords);

  static final List<TrainerAttendanceRecord> _initialRecords = [
    TrainerAttendanceRecord(
      memberId: 'm1',
      memberName: 'Rahul Sharma',
      avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?q=80&w=150&auto=format&fit=crop',
      status: 'Present',
      time: '08:15 AM',
    ),
    TrainerAttendanceRecord(
      memberId: 'm2',
      memberName: 'Aisha Patel',
      avatarUrl: 'https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=150&auto=format&fit=crop',
      status: 'Present',
      time: '07:45 AM',
    ),
    TrainerAttendanceRecord(
      memberId: 'm3',
      memberName: 'Vikram Singh',
      avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=150&auto=format&fit=crop',
      status: 'Pending',
    ),
  ];

  void validateCheckIn(String memberId, String status) {
    final now = DateTime.now();
    final timeStr = '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';
    
    state = [
      for (final r in state)
        if (r.memberId == memberId)
          r.copyWith(status: status, time: timeStr)
        else
          r
    ];
  }
}

final trainerAttendanceProvider = StateNotifierProvider<TrainerAttendanceNotifier, List<TrainerAttendanceRecord>>((ref) {
  return TrainerAttendanceNotifier();
});
