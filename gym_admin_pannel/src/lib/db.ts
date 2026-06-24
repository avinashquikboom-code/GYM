// Stateful Mock Database for Gym Admin Panel
// Stored on globalThis to prevent resetting during Next.js Hot Module Replacement (HMR)

export interface Member {
  id: string;
  name: string;
  email: string;
  mobile: string;
  status: 'active' | 'suspended';
  planId: string;
  trainerId: string;
  avatarUrl: string;
  joinDate: string;
  currentWeight: number;
  bodyFat: number;
  muscleMass: number;
  bmi: number;
  measurements: {
    chest: number;
    waist: number;
    biceps: number;
  };
  weightHistory: { date: string; value: number }[];
  bodyFatHistory: { date: string; value: number }[];
  muscleMassHistory: { date: string; value: number }[];
  timeline: { date: string; title: string; description: string; category: string }[];
  assignedWorkoutId?: string;
  assignedDietId?: string;
}

export interface Trainer {
  id: string;
  name: string;
  email: string;
  mobile: string;
  experience: number;
  rating: number;
  status: 'active' | 'inactive';
  avatarUrl: string;
  certifications: string[];
  attendanceRate: number;
  successRate: number;
}

export interface MembershipPlan {
  id: string;
  name: string;
  price: number;
  duration: 'month' | 'quarter' | 'year';
  features: string[];
  popular: boolean;
}

export interface WorkoutPlan {
  id: string;
  name: string;
  category: 'Fat Loss' | 'Muscle Gain' | 'Strength' | 'Cardio';
  exercises: {
    name: string;
    sets: number;
    reps: string;
    restTime: string;
    notes: string;
  }[];
}

export interface DietPlan {
  id: string;
  name: string;
  meals: {
    category: 'Breakfast' | 'Lunch' | 'Snack' | 'Dinner';
    name: string;
    calories: number;
    protein: number;
    carbs: number;
    fats: number;
  }[];
}

export interface AttendanceRecord {
  id: string;
  memberId: string;
  name: string;
  time: string;
  date: string;
  gate: string;
  status: 'present' | 'absent' | 'late';
}

export interface PaymentRecord {
  id: string;
  memberId: string;
  memberName: string;
  amount: number;
  date: string;
  type: string;
  status: 'paid' | 'pending' | 'failed';
}

export interface GymNotification {
  id: string;
  target: string;
  type: 'Membership Renewal' | 'Workout Reminder' | 'Diet Reminder' | 'Announcements';
  message: string;
  sentAt: string;
}

class GymDatabase {
  members: Member[] = [];
  trainers: Trainer[] = [];
  plans: MembershipPlan[] = [];
  workouts: WorkoutPlan[] = [];
  diets: DietPlan[] = [];
  attendance: AttendanceRecord[] = [];
  payments: PaymentRecord[] = [];
  notifications: GymNotification[] = [];

  constructor() {
    this.seed();
  }

  seed() {
    // 1. Membership Plans
    this.plans = [
      {
        id: 'PLAN-BASIC',
        name: 'Basic Access',
        price: 29,
        duration: 'month',
        features: ['24/7 Gym Floor Access', 'Locker Room & Shower Access', '1 Free Fitness Assessment'],
        popular: false
      },
      {
        id: 'PLAN-VIP',
        name: 'VIP Elite Trainer',
        price: 79,
        duration: 'month',
        features: ['Full Gym Access & Spa', 'Unlimited Group Workouts', '2 Personal Trainer Sessions/mo', 'Free Protein Shake Daily'],
        popular: true
      },
      {
        id: 'PLAN-FAMILY',
        name: 'Ultimate Family Pass',
        price: 149,
        duration: 'month',
        features: ['Access for 3 Family Members', 'All VIP Perks Included', 'Childcare Lounge Access', 'Monthly Guest Passes'],
        popular: false
      }
    ];

    // 2. Personal Trainers
    this.trainers = [
      {
        id: 'TRN-001',
        name: 'Marcus Vance',
        email: 'marcus@gym.com',
        mobile: '+1 555-0101',
        experience: 8,
        rating: 4.9,
        status: 'active',
        avatarUrl: 'https://images.unsplash.com/photo-1567013127542-490d757e51fc?q=80&w=150&auto=format&fit=crop',
        certifications: ['NASM-CPT', 'FMS Level 1', 'CPR/AED'],
        attendanceRate: 98,
        successRate: 95
      },
      {
        id: 'TRN-002',
        name: 'Elena Rostova',
        email: 'elena@gym.com',
        mobile: '+1 555-0102',
        experience: 6,
        rating: 4.8,
        status: 'active',
        avatarUrl: 'https://images.unsplash.com/photo-1548690312-e3b507d8c110?q=80&w=150&auto=format&fit=crop',
        certifications: ['ISSA Strength & Cond.', 'Precision Nutrition L1'],
        attendanceRate: 95,
        successRate: 91
      },
      {
        id: 'TRN-003',
        name: 'Devon Carter',
        email: 'devon@gym.com',
        mobile: '+1 555-0103',
        experience: 12,
        rating: 4.7,
        status: 'active',
        avatarUrl: 'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?q=80&w=150&auto=format&fit=crop',
        certifications: ['CSCS *D', 'USA Weightlifting L2'],
        attendanceRate: 97,
        successRate: 94
      },
      {
        id: 'TRN-004',
        name: 'Sarah Jenkins',
        email: 'sarah@gym.com',
        mobile: '+1 555-0104',
        experience: 5,
        rating: 4.9,
        status: 'active',
        avatarUrl: 'https://images.unsplash.com/photo-1594381898411-846e7d193883?q=80&w=150&auto=format&fit=crop',
        certifications: ['ACE-CPT', 'RYT-200 Yoga Alliance'],
        attendanceRate: 99,
        successRate: 88
      }
    ];

    // 3. Workouts
    this.workouts = [
      {
        id: 'WRK-001',
        name: 'Muscle Gain Hypertrophy',
        category: 'Muscle Gain',
        exercises: [
          { name: 'Barbell Bench Press', sets: 4, reps: '8-10', restTime: '90s', notes: 'Keep bar path controlled.' },
          { name: 'Incline Dumbbell Flyes', sets: 3, reps: '12', restTime: '60s', notes: 'Focus on chest squeeze.' },
          { name: 'Barbell Squats', sets: 4, reps: '8', restTime: '120s', notes: 'Parallel depth required.' },
          { name: 'Overhead Press', sets: 3, reps: '10', restTime: '90s', notes: 'Core tight, do not arch back.' }
        ]
      },
      {
        id: 'WRK-002',
        name: 'Fat Burn HIIT & Core',
        category: 'Fat Loss',
        exercises: [
          { name: 'Kettlebell Swings', sets: 4, reps: '30s on', restTime: '30s', notes: 'Hinge hips, drive glutes.' },
          { name: 'Burpees', sets: 4, reps: '30s on', restTime: '30s', notes: 'Explosion at top pushup.' },
          { name: 'Dumbbell Renegade Rows', sets: 3, reps: '12 per arm', restTime: '45s', notes: 'Minimize hip swaying.' },
          { name: 'Hanging Leg Raises', sets: 3, reps: '15', restTime: '30s', notes: 'Slow negative control.' }
        ]
      },
      {
        id: 'WRK-003',
        name: 'Strength Foundation Power',
        category: 'Strength',
        exercises: [
          { name: 'Conventional Deadlifts', sets: 5, reps: '5', restTime: '180s', notes: 'Keep bar close to shins.' },
          { name: 'Weighted Pull-ups', sets: 4, reps: '6', restTime: '120s', notes: 'Chest to bar, full extension.' },
          { name: 'Barbell Squats (Heavy)', sets: 5, reps: '5', restTime: '180s', notes: 'Brace core with belt.' },
          { name: 'Standing Overhead Press', sets: 4, reps: '6', restTime: '120s', notes: 'Squeeze glutes at top.' }
        ]
      }
    ];

    // 4. Diets
    this.diets = [
      {
        id: 'DIET-001',
        name: 'Lean Bulk High Carb',
        meals: [
          { category: 'Breakfast', name: 'Oats with Whey, Peanut Butter & Banana', calories: 650, protein: 45, carbs: 80, fats: 18 },
          { category: 'Lunch', name: 'Grilled Chicken Breast, Jasmine Rice & Broccoli', calories: 720, protein: 60, carbs: 90, fats: 10 },
          { category: 'Snack', name: 'Almonds & Greek Yogurt with Mixed Berries', calories: 350, protein: 25, carbs: 30, fats: 12 },
          { category: 'Dinner', name: 'Pan Seared Salmon, Sweet Potato & Asparagus', calories: 680, protein: 48, carbs: 60, fats: 22 }
        ]
      },
      {
        id: 'DIET-002',
        name: 'Ketogenic Fat Loss',
        meals: [
          { category: 'Breakfast', name: '3 Scrambled Eggs in Butter with Spinach & Avocado', calories: 550, protein: 28, carbs: 4, fats: 48 },
          { category: 'Lunch', name: 'Ribeye Steak with Garlic Herb Compound Butter', calories: 750, protein: 55, carbs: 0, fats: 60 },
          { category: 'Snack', name: 'Macadamia Nuts & Keto Protein Shake', calories: 320, protein: 20, carbs: 3, fats: 26 },
          { category: 'Dinner', name: 'Baked Chicken Thighs with Cauliflower Mash & Olive Oil', calories: 620, protein: 42, carbs: 5, fats: 48 }
        ]
      }
    ];

    // 5. Members Directory
    this.members = [
      {
        id: 'MEM-001',
        name: 'Jordan Belfort',
        email: 'jordan@straton.com',
        mobile: '+1 555-0151',
        status: 'active',
        planId: 'PLAN-VIP',
        trainerId: 'TRN-001',
        avatarUrl: 'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?q=80&w=100&auto=format&fit=crop',
        joinDate: '2026-01-10',
        currentWeight: 82.5,
        bodyFat: 15.4,
        muscleMass: 38.5,
        bmi: 24.3,
        measurements: { chest: 108, waist: 88, biceps: 38 },
        weightHistory: [
          { date: 'Jan', value: 85.0 },
          { date: 'Feb', value: 84.2 },
          { date: 'Mar', value: 83.5 },
          { date: 'Apr', value: 83.0 },
          { date: 'May', value: 82.8 },
          { date: 'Jun', value: 82.5 }
        ],
        bodyFatHistory: [
          { date: 'Jan', value: 18.2 },
          { date: 'Feb', value: 17.5 },
          { date: 'Mar', value: 16.8 },
          { date: 'Apr', value: 16.2 },
          { date: 'May', value: 15.8 },
          { date: 'Jun', value: 15.4 }
        ],
        muscleMassHistory: [
          { date: 'Jan', value: 37.1 },
          { date: 'Feb', value: 37.3 },
          { date: 'Mar', value: 37.7 },
          { date: 'Apr', value: 38.0 },
          { date: 'May', value: 38.3 },
          { date: 'Jun', value: 38.5 }
        ],
        timeline: [
          { date: '2026-01-10', title: 'Joined Gym', description: 'Enrolled under VIP Elite Trainer Package.', category: 'milestone' },
          { date: '2026-02-15', title: 'Trainer Assigned', description: 'Marcus Vance assigned as Personal Coach.', category: 'coaching' },
          { date: '2026-03-20', title: 'Diet Changed', description: 'Assigned lean bulk diet targets.', category: 'nutrition' },
          { date: '2026-06-01', title: 'Bench Press PR', description: 'Hit 100kg for 3 reps.', category: 'workout' }
        ],
        assignedWorkoutId: 'WRK-001',
        assignedDietId: 'DIET-001'
      },
      {
        id: 'MEM-002',
        name: 'Sarah Connor',
        email: 'sconnor@cyberdyne.net',
        mobile: '+1 555-0152',
        status: 'active',
        planId: 'PLAN-VIP',
        trainerId: 'TRN-003',
        avatarUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?q=80&w=100&auto=format&fit=crop',
        joinDate: '2026-02-15',
        currentWeight: 62.0,
        bodyFat: 14.2,
        muscleMass: 29.8,
        bmi: 20.8,
        measurements: { chest: 92, waist: 66, biceps: 30 },
        weightHistory: [
          { date: 'Feb', value: 65.2 },
          { date: 'Mar', value: 64.0 },
          { date: 'Apr', value: 63.1 },
          { date: 'May', value: 62.5 },
          { date: 'Jun', value: 62.0 }
        ],
        bodyFatHistory: [
          { date: 'Feb', value: 18.5 },
          { date: 'Mar', value: 17.2 },
          { date: 'Apr', value: 16.0 },
          { date: 'May', value: 15.1 },
          { date: 'Jun', value: 14.2 }
        ],
        muscleMassHistory: [
          { date: 'Feb', value: 28.1 },
          { date: 'Mar', value: 28.5 },
          { date: 'Apr', value: 29.0 },
          { date: 'May', value: 29.5 },
          { date: 'Jun', value: 29.8 }
        ],
        timeline: [
          { date: '2026-02-15', title: 'Joined Gym', description: 'Joined VIP to prepare for heavy physical workloads.', category: 'milestone' },
          { date: '2026-03-01', title: 'Workout Assigned', description: 'Powerlift Strength assigned by Coach Devon.', category: 'workout' }
        ],
        assignedWorkoutId: 'WRK-003',
        assignedDietId: 'DIET-002'
      },
      {
        id: 'MEM-003',
        name: 'Bruce Wayne',
        email: 'bruce@waynecorp.com',
        mobile: '+1 555-0153',
        status: 'active',
        planId: 'PLAN-FAMILY',
        trainerId: 'TRN-003',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?q=80&w=100&auto=format&fit=crop',
        joinDate: '2025-11-04',
        currentWeight: 95.0,
        bodyFat: 8.5,
        muscleMass: 48.0,
        bmi: 25.1,
        measurements: { chest: 122, waist: 82, biceps: 45 },
        weightHistory: [
          { date: 'Jan', value: 96.0 },
          { date: 'Feb', value: 95.5 },
          { date: 'Mar', value: 95.8 },
          { date: 'Apr', value: 95.2 },
          { date: 'May', value: 95.0 },
          { date: 'Jun', value: 95.0 }
        ],
        bodyFatHistory: [
          { date: 'Jan', value: 9.2 },
          { date: 'Feb', value: 8.9 },
          { date: 'Mar', value: 9.0 },
          { date: 'Apr', value: 8.7 },
          { date: 'May', value: 8.5 },
          { date: 'Jun', value: 8.5 }
        ],
        muscleMassHistory: [
          { date: 'Jan', value: 47.2 },
          { date: 'Feb', value: 47.5 },
          { date: 'Mar', value: 47.6 },
          { date: 'Apr', value: 47.9 },
          { date: 'May', value: 48.0 },
          { date: 'Jun', value: 48.0 }
        ],
        timeline: [
          { date: '2025-11-04', title: 'Joined Gym', description: 'Enrolled under Ultimate Family Pass.', category: 'milestone' }
        ],
        assignedWorkoutId: 'WRK-003',
        assignedDietId: 'DIET-001'
      },
      {
        id: 'MEM-004',
        name: 'Clara Oswald',
        email: 'clara@tardis.org',
        mobile: '+1 555-0154',
        status: 'suspended',
        planId: 'PLAN-BASIC',
        trainerId: '',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=100&auto=format&fit=crop',
        joinDate: '2025-08-20',
        currentWeight: 54.0,
        bodyFat: 21.0,
        muscleMass: 21.2,
        bmi: 19.8,
        measurements: { chest: 84, waist: 64, biceps: 26 },
        weightHistory: [
          { date: 'Jan', value: 55.0 },
          { date: 'Feb', value: 54.8 },
          { date: 'Mar', value: 54.2 },
          { date: 'Apr', value: 54.0 },
          { date: 'May', value: 54.0 }
        ],
        bodyFatHistory: [
          { date: 'Jan', value: 22.0 },
          { date: 'Feb', value: 21.8 },
          { date: 'Mar', value: 21.4 },
          { date: 'Apr', value: 21.0 },
          { date: 'May', value: 21.0 }
        ],
        muscleMassHistory: [
          { date: 'Jan', value: 21.0 },
          { date: 'Feb', value: 21.1 },
          { date: 'Mar', value: 21.2 },
          { date: 'Apr', value: 21.2 },
          { date: 'May', value: 21.2 }
        ],
        timeline: [
          { date: '2025-08-20', title: 'Joined Gym', description: 'Joined Basic Access plan.', category: 'milestone' },
          { date: '2026-05-25', title: 'Membership Suspended', description: 'Account suspended due to billing failure.', category: 'milestone' }
        ]
      },
      {
        id: 'MEM-005',
        name: 'Peter Parker',
        email: 'web@bugle.com',
        mobile: '+1 555-0155',
        status: 'active',
        planId: 'PLAN-BASIC',
        trainerId: 'TRN-002',
        avatarUrl: 'https://images.unsplash.com/photo-1539571696357-5a69c17a67c6?q=80&w=100&auto=format&fit=crop',
        joinDate: '2026-03-01',
        currentWeight: 74.2,
        bodyFat: 10.8,
        muscleMass: 35.2,
        bmi: 21.5,
        measurements: { chest: 100, waist: 74, biceps: 34 },
        weightHistory: [
          { date: 'Mar', value: 73.0 },
          { date: 'Apr', value: 73.8 },
          { date: 'May', value: 74.0 },
          { date: 'Jun', value: 74.2 }
        ],
        bodyFatHistory: [
          { date: 'Mar', value: 12.0 },
          { date: 'Apr', value: 11.4 },
          { date: 'May', value: 11.0 },
          { date: 'Jun', value: 10.8 }
        ],
        muscleMassHistory: [
          { date: 'Mar', value: 34.0 },
          { date: 'Apr', value: 34.6 },
          { date: 'May', value: 35.0 },
          { date: 'Jun', value: 35.2 }
        ],
        timeline: [
          { date: '2026-03-01', title: 'Joined Gym', description: 'Joined Basic Access plan.', category: 'milestone' },
          { date: '2026-03-10', title: 'Trainer Assigned', description: 'Elena Rostova assigned as Coach.', category: 'coaching' }
        ],
        assignedWorkoutId: 'WRK-002',
        assignedDietId: 'DIET-002'
      }
    ];

    // 6. Attendance Logs
    this.attendance = [
      { id: 'ATT-001', memberId: 'MEM-001', name: 'Jordan Belfort', time: '08:15 AM', date: '2026-06-24', gate: 'Gate A - Main Entry', status: 'present' },
      { id: 'ATT-002', memberId: 'MEM-003', name: 'Bruce Wayne', time: '09:42 AM', date: '2026-06-24', gate: 'Gate A - Main Entry', status: 'present' },
      { id: 'ATT-003', memberId: 'MEM-005', name: 'Peter Parker', time: '10:12 AM', date: '2026-06-24', gate: 'Gate B - Cardio Area', status: 'present' },
      { id: 'ATT-004', memberId: 'MEM-002', name: 'Sarah Connor', time: '07:30 AM', date: '2026-06-24', gate: 'Gate A - Main Entry', status: 'present' }
    ];

    // 7. Payments History
    this.payments = [
      { id: 'INV-2026-001', memberId: 'MEM-001', memberName: 'Jordan Belfort', amount: 79, date: '2026-06-10', type: 'Subscription Renewal', status: 'paid' },
      { id: 'INV-2026-002', memberId: 'MEM-002', memberName: 'Sarah Connor', amount: 79, date: '2026-06-15', type: 'Subscription Renewal', status: 'paid' },
      { id: 'INV-2026-003', memberId: 'MEM-003', memberName: 'Bruce Wayne', amount: 149, date: '2026-06-04', type: 'Subscription Renewal', status: 'paid' },
      { id: 'INV-2026-004', memberId: 'MEM-004', memberName: 'Clara Oswald', amount: 29, date: '2026-05-20', type: 'Subscription Renewal', status: 'failed' },
      { id: 'INV-2026-005', memberId: 'MEM-005', memberName: 'Peter Parker', amount: 29, date: '2026-06-01', type: 'Subscription Renewal', status: 'paid' },
      { id: 'INV-2026-006', memberId: 'MEM-006', memberName: 'Tony Stark', amount: 79, date: '2026-06-22', type: 'Subscription Renewal', status: 'pending' }
    ];

    // 8. Notifications Log
    this.notifications = [
      {
        id: 'NOT-001',
        target: 'All Members',
        type: 'Announcements',
        message: 'New cardio machines have been installed in the main floor!',
        sentAt: '2026-06-23T10:00:00Z'
      },
      {
        id: 'NOT-002',
        target: 'Jordan Belfort',
        type: 'Workout Reminder',
        message: 'Your Coach Marcus Vance updated your routine. Check it out!',
        sentAt: '2026-06-24T08:30:00Z'
      }
    ];
  }
}

// Ensure the db exists on globalThis
const getDatabase = (): GymDatabase => {
  const g = globalThis as any;
  if (!g.gymDb) {
    g.gymDb = new GymDatabase();
  }
  return g.gymDb;
};

export const db = getDatabase();
