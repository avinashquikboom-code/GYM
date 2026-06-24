// Member Types
export interface Member {
  id: string;
  name: string;
  email: string;
  mobile: string;
  profilePhoto?: string;
  assignedTrainer?: string;
  trainerId?: string;
  membershipPlan: string;
  planId?: string;
  currentWeight: number;
  bodyFatPercentage: number;
  status: 'active' | 'inactive' | 'suspended';
  joinDate: string;
  expiryDate: string;
  bmi: number;
  muscleMass: number;
  measurements?: BodyMeasurements;
  weightHistory?: Array<{ date: string; value: number }>;
  bodyFatHistory?: Array<{ date: string; value: number }>;
}

// Trainer Types
export interface Trainer {
  id: string;
  name: string;
  email: string;
  mobile: string;
  photo?: string;
  experience: number;
  assignedMembers: number;
  rating: number;
  status: 'active' | 'inactive';
  certifications: string[];
  successRate?: number;
  attendanceRate?: number;
  specialization?: string;
}

// Membership Plan Types
export interface MembershipPlan {
  id: string;
  name: string;
  duration: number; // in months
  price: number;
  features: string[];
  status: 'active' | 'inactive';
}

// Workout Plan Types
export interface Exercise {
  id: string;
  name: string;
  category: 'fat-loss' | 'muscle-gain' | 'strength' | 'cardio';
  description: string;
  muscleGroups: string[];
}

export interface WorkoutPlan {
  id: string;
  name: string;
  category: 'fat-loss' | 'muscle-gain' | 'strength' | 'cardio';
  exercises: WorkoutExercise[];
  assignedTo: string[];
  createdAt: string;
}

export interface WorkoutExercise {
  exerciseId: string;
  sets: number;
  reps: number;
  restTime: number; // in seconds
  notes?: string;
}

// Diet Plan Types
export interface DietPlan {
  id: string;
  name: string;
  meals: Meal[];
  assignedTo: string[];
  createdAt: string;
}

export interface Meal {
  type: 'breakfast' | 'lunch' | 'snack' | 'dinner';
  name: string;
  calories: number;
  protein: number;
  carbohydrates: number;
  fats: number;
}

// Attendance Types
export interface Attendance {
  id: string;
  memberId: string;
  memberName: string;
  date: string;
  checkInTime?: string;
  checkOutTime?: string;
  status: 'present' | 'absent' | 'late';
  qrCode?: string;
  gate?: string;
}

// Payment Types
export interface Payment {
  id: string;
  memberId: string;
  memberName: string;
  amount: number;
  type: 'membership' | 'renewal' | 'personal-training';
  status: 'pending' | 'completed' | 'failed';
  date: string;
  dueDate: string;
  invoiceId?: string;
  method?: string | null;
}

// Transformation Types
export interface Transformation {
  id: string;
  memberId: string;
  memberName: string;
  beforePhoto: string;
  currentPhoto: string;
  goalPhoto?: string;
  measurements: BodyMeasurements;
  startDate: string;
  currentStage: string;
}

export interface BodyMeasurements {
  weight?: number;
  chest?: number;
  waist?: number;
  biceps?: number;
  bodyFat?: number;
  bmi?: number;
  muscleMass?: number;
  thighs?: number;
  shoulders?: number;
}

// Notification Types
export interface Notification {
  id: string;
  title: string;
  message: string;
  type: 'membership-renewal' | 'workout-reminder' | 'diet-reminder' | 'announcement';
  targetAudience: 'all-members' | 'all-trainers' | 'selected-users';
  sentTo: string[];
  createdAt: string;
  readBy: string[];
}

// Report Types
export interface Report {
  id: string;
  type: 'members' | 'attendance' | 'revenue' | 'trainers' | 'transformations';
  title: string;
  generatedAt: string;
  period: string;
  data: any;
}

// Dashboard Stats Types
export interface DashboardStats {
  totalMembers: number;
  activeMembers: number;
  totalTrainers: number;
  todayAttendance: {
    present: number;
    absent: number;
    late: number;
  };
  monthlyRevenue: number;
  activeMemberships: number;
}

export interface ChartData {
  name: string;
  value: number;
  [key: string]: any;
}

// Auth Types
export interface User {
  id: string;
  email: string;
  name: string;
  role: 'admin' | 'super-admin';
}

export interface LoginCredentials {
  email: string;
  password: string;
}

// Settings Types
export interface GymSettings {
  gymName: string;
  address: string;
  phone: string;
  email: string;
  logo?: string;
  workingHours: {
    weekdays: string;
    weekends: string;
  };
}
