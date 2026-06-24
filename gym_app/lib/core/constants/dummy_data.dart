// Comprehensive dummy data for Gym Mobile App
// This data matches the admin panel for consistency

class DummyData {
  // Member data (for logged-in user)
  static final Map<String, dynamic> currentUser = {
    'id': 'MEM001',
    'name': 'Rahul Sharma',
    'email': 'rahul.sharma@email.com',
    'mobile': '+91 98765 43210',
    'avatar': 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&h=200&fit=crop&crop=face',
    'joinDate': '2024-01-15',
    'expiryDate': '2025-01-15',
    'membershipPlan': 'Platinum Premium',
    'trainerId': 'TR001',
    'assignedTrainer': 'Vikram Singh',
    'status': 'active',
    'currentWeight': 78.5,
    'bodyFatPercentage': 18.2,
    'bmi': 24.8,
    'muscleMass': 32.5,
    'measurements': {
      'chest': 98,
      'waist': 78,
      'biceps': 34,
      'thighs': 58,
      'shoulders': 112,
    },
    'weightHistory': [
      {'date': '2024-01-15', 'value': 85.0},
      {'date': '2024-02-15', 'value': 83.5},
      {'date': '2024-03-15', 'value': 82.0},
      {'date': '2024-04-15', 'value': 80.5},
      {'date': '2024-05-15', 'value': 79.0},
      {'date': '2024-06-15', 'value': 78.5},
    ],
    'bodyFatHistory': [
      {'date': '2024-01-15', 'value': 22.0},
      {'date': '2024-02-15', 'value': 21.2},
      {'date': '2024-03-15', 'value': 20.5},
      {'date': '2024-04-15', 'value': 19.5},
      {'date': '2024-05-15', 'value': 18.8},
      {'date': '2024-06-15', 'value': 18.2},
    ],
  };

  // Dashboard statistics
  static final Map<String, dynamic> dashboardStats = {
    'totalWorkouts': 48,
    'thisWeekWorkouts': 4,
    'caloriesBurned': 125000,
    'currentStreak': 12,
    'weightLost': 6.5,
    'bodyFatLost': 3.8,
  };

  // Today's workout
  static final Map<String, dynamic> todaysWorkout = {
    'id': 'WK001',
    'name': 'Upper Body Hypertrophy',
    'category': 'Muscle Gain',
    'exercises': [
      {
        'name': 'Bench Press',
        'sets': 4,
        'reps': '10-12',
        'restTime': '90s',
        'notes': 'Focus on controlled eccentric',
        'completed': true,
      },
      {
        'name': 'Incline Dumbbell Press',
        'sets': 3,
        'reps': '10-12',
        'restTime': '60s',
        'notes': 'Keep shoulders retracted',
        'completed': true,
      },
      {
        'name': 'Lat Pulldown',
        'sets': 4,
        'reps': '12-15',
        'restTime': '60s',
        'notes': 'Full range of motion',
        'completed': false,
      },
      {
        'name': 'Cable Rows',
        'sets': 3,
        'reps': '12-15',
        'restTime': '60s',
        'notes': 'Squeeze at the bottom',
        'completed': false,
      },
      {
        'name': 'Tricep Pushdown',
        'sets': 3,
        'reps': '12-15',
        'restTime': '45s',
        'notes': 'Keep elbows tucked',
        'completed': false,
      },
    ],
    'estimatedDuration': 45,
    'caloriesBurned': 320,
  };

  // Diet plan
  static final Map<String, dynamic> dietPlan = {
    'id': 'DT001',
    'name': 'Cutting Phase - High Protein',
    'meals': [
      {
        'category': 'Breakfast',
        'name': 'Oatmeal with Protein Powder',
        'calories': 450,
        'protein': 35,
        'carbs': 55,
        'fats': 8,
        'time': '7:00 AM',
      },
      {
        'category': 'Snack',
        'name': 'Greek Yogurt with Berries',
        'calories': 200,
        'protein': 20,
        'carbs': 15,
        'fats': 5,
        'time': '10:00 AM',
      },
      {
        'category': 'Lunch',
        'name': 'Grilled Chicken Salad',
        'calories': 550,
        'protein': 45,
        'carbs': 30,
        'fats': 18,
        'time': '1:00 PM',
      },
      {
        'category': 'Snack',
        'name': 'Protein Shake with Almonds',
        'calories': 300,
        'protein': 30,
        'carbs': 20,
        'fats': 12,
        'time': '4:00 PM',
      },
      {
        'category': 'Dinner',
        'name': 'Salmon with Quinoa',
        'calories': 600,
        'protein': 40,
        'carbs': 45,
        'fats': 22,
        'time': '8:00 PM',
      },
    ],
    'totalCalories': 2100,
    'totalProtein': 170,
    'totalCarbs': 165,
    'totalFats': 65,
  };

  // Attendance history
  static final List<Map<String, dynamic>> attendanceHistory = [
    {'date': '2024-06-24', 'time': '6:30 AM', 'gate': 'Gate A - Main Entry', 'status': 'present'},
    {'date': '2024-06-23', 'time': '6:45 AM', 'gate': 'Gate A - Main Entry', 'status': 'present'},
    {'date': '2024-06-22', 'time': '7:00 AM', 'gate': 'Gate A - Main Entry', 'status': 'late'},
    {'date': '2024-06-21', 'time': '6:30 AM', 'gate': 'Gate A - Main Entry', 'status': 'present'},
    {'date': '2024-06-20', 'time': '6:30 AM', 'gate': 'Gate A - Main Entry', 'status': 'present'},
    {'date': '2024-06-19', 'time': '6:30 AM', 'gate': 'Gate A - Main Entry', 'status': 'present'},
    {'date': '2024-06-18', 'time': '7:15 AM', 'gate': 'Gate A - Main Entry', 'status': 'late'},
  ];

  // Payment history
  static final List<Map<String, dynamic>> paymentHistory = [
    {
      'id': 'PAY001',
      'amount': 9000,
      'type': 'Membership Renewal',
      'date': '2024-01-15',
      'status': 'paid',
      'method': 'UPI',
    },
    {
      'id': 'PAY002',
      'amount': 9000,
      'type': 'Membership Renewal',
      'date': '2024-02-15',
      'status': 'paid',
      'method': 'Credit Card',
    },
    {
      'id': 'PAY003',
      'amount': 9000,
      'type': 'Membership Renewal',
      'date': '2024-03-15',
      'status': 'paid',
      'method': 'UPI',
    },
    {
      'id': 'PAY004',
      'amount': 9000,
      'type': 'Membership Renewal',
      'date': '2024-04-15',
      'status': 'paid',
      'method': 'UPI',
    },
    {
      'id': 'PAY005',
      'amount': 9000,
      'type': 'Membership Renewal',
      'date': '2024-05-15',
      'status': 'paid',
      'method': 'UPI',
    },
  ];

  // Workout history
  static final List<Map<String, dynamic>> workoutHistory = [
    {
      'date': '2024-06-24',
      'name': 'Upper Body Hypertrophy',
      'duration': 45,
      'caloriesBurned': 320,
      'exercisesCompleted': 5,
      'totalExercises': 5,
    },
    {
      'date': '2024-06-23',
      'name': 'Lower Body Strength',
      'duration': 50,
      'caloriesBurned': 380,
      'exercisesCompleted': 6,
      'totalExercises': 6,
    },
    {
      'date': '2024-06-21',
      'name': 'Cardio HIIT',
      'duration': 30,
      'caloriesBurned': 280,
      'exercisesCompleted': 4,
      'totalExercises': 4,
    },
    {
      'date': '2024-06-20',
      'name': 'Push Day',
      'duration': 48,
      'caloriesBurned': 350,
      'exercisesCompleted': 5,
      'totalExercises': 5,
    },
    {
      'date': '2024-06-19',
      'name': 'Pull Day',
      'duration': 45,
      'caloriesBurned': 310,
      'exercisesCompleted': 5,
      'totalExercises': 5,
    },
  ];

  // Transformation photos
  static final List<Map<String, dynamic>> transformationPhotos = [
    {
      'id': 'TF001',
      'date': '2024-01-15',
      'type': 'before',
      'url': 'https://images.unsplash.com/photo-1517838277536-f5f99be501cd?w=400&h=400&fit=crop',
      'weight': 85.0,
      'bodyFat': 22.0,
    },
    {
      'id': 'TF002',
      'date': '2024-03-15',
      'type': 'progress',
      'url': 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=400&h=400&fit=crop',
      'weight': 82.0,
      'bodyFat': 20.5,
    },
    {
      'id': 'TF003',
      'date': '2024-06-15',
      'type': 'current',
      'url': 'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=400&h=400&fit=crop',
      'weight': 78.5,
      'bodyFat': 18.2,
    },
  ];

  // Notifications
  static final List<Map<String, dynamic>> notifications = [
    {
      'id': 'NOT001',
      'title': 'Workout Reminder',
      'message': 'Don\'t forget your Upper Body workout today at 6:30 AM!',
      'type': 'workout',
      'date': '2024-06-24T06:00:00',
      'read': false,
    },
    {
      'id': 'NOT002',
      'title': 'Membership Renewal',
      'message': 'Your membership will expire on 2025-01-15. Renew early for 10% discount!',
      'type': 'membership',
      'date': '2024-06-20T10:00:00',
      'read': true,
    },
    {
      'id': 'NOT003',
      'title': 'Diet Tip',
      'message': 'Remember to increase protein intake on workout days for better recovery.',
      'type': 'diet',
      'date': '2024-06-18T09:00:00',
      'read': true,
    },
    {
      'id': 'NOT004',
      'title': 'Achievement Unlocked',
      'message': 'Congratulations! You\'ve completed 10 workout days in a row!',
      'type': 'achievement',
      'date': '2024-06-15T18:00:00',
      'read': true,
    },
  ];

  // Membership plans
  static final List<Map<String, dynamic>> membershipPlans = [
    {
      'id': 'PLAN001',
      'name': 'Basic',
      'price': 3000,
      'duration': 'month',
      'features': [
        'Gym Access (6 AM - 8 PM)',
        'Basic Equipment',
        'Locker Room',
        'Drinking Water',
      ],
      'popular': false,
    },
    {
      'id': 'PLAN002',
      'name': 'Gold',
      'price': 6000,
      'duration': 'month',
      'features': [
        '24/7 Gym Access',
        'All Equipment',
        'Locker Room',
        'Drinking Water',
        'Free WiFi',
        'Group Classes',
      ],
      'popular': false,
    },
    {
      'id': 'PLAN003',
      'name': 'Platinum Premium',
      'price': 9000,
      'duration': 'month',
      'features': [
        '24/7 Gym Access',
        'All Equipment',
        'Personal Trainer (2 sessions/week)',
        'Locker Room',
        'Drinking Water',
        'Free WiFi',
        'Group Classes',
        'Sauna Access',
        'Massage Therapy (1/month)',
      ],
      'popular': true,
    },
  ];

  // Trainers
  static final List<Map<String, dynamic>> trainers = [
    {
      'id': 'TR001',
      'name': 'Vikram Singh',
      'avatar': 'https://images.unsplash.com/photo-1568602471122-7832951cc4c5?w=200&h=200&fit=crop&crop=face',
      'experience': '8',
      'rating': 4.8,
      'successRate': 92,
      'attendanceRate': 95,
      'certifications': ['NASM-CPT', 'CrossFit Level 2', 'FMS'],
      'specialization': 'Muscle Building',
      'assignedMembers': 12,
    },
    {
      'id': 'TR002',
      'name': 'Priya Patel',
      'avatar': 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=200&h=200&fit=crop&crop=face',
      'experience': '6',
      'rating': 4.7,
      'successRate': 88,
      'attendanceRate': 93,
      'certifications': ['ACE', 'Yoga Certified', 'Nutrition Specialist'],
      'specialization': 'Weight Loss',
      'assignedMembers': 10,
    },
    {
      'id': 'TR003',
      'name': 'Amit Kumar',
      'avatar': 'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=200&h=200&fit=crop&crop=face',
      'experience': '5',
      'rating': 4.6,
      'successRate': 85,
      'attendanceRate': 90,
      'certifications': ['ISSA', 'Strength & Conditioning'],
      'specialization': 'Strength Training',
      'assignedMembers': 8,
    },
  ];

  // Gym info
  static final Map<String, dynamic> gymInfo = {
    'name': 'GYM - Executive Hub',
    'email': 'hq@gym.com',
    'mobile': '+91 98765 43210',
    'address': '100 Fitness Plaza, New York, NY',
    'timing': '24/7',
    'qrCode': 'https://example.com/qr-code.png',
  };
}
