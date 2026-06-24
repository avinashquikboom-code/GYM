import { NextResponse } from 'next/server';
import { db, Member, Trainer, MembershipPlan, WorkoutPlan, DietPlan, AttendanceRecord, PaymentRecord, GymNotification } from '@/lib/db';

// Helper to handle CORS/Response wrapping
function jsonResponse(data: any, status = 200) {
  return NextResponse.json(data, { status });
}

// Next.js 15 treats route params as a Promise
type Params = Promise<{ path: string[] }>;

// --- GET HANDLERS ---
export async function GET(
  request: Request,
  { params }: { params: Params }
) {
  const { path } = await params;
  const resource = path[0];
  const id = path[1];

  try {
    switch (resource) {
      case 'dashboard': {
        // Calculate dynamic dashboard KPI stats
        const totalMembers = db.members.length;
        const activeMembers = db.members.filter(m => m.status === 'active').length;
        const totalTrainers = db.trainers.length;
        
        // Today's attendance present count
        const todayStr = new Date().toISOString().split('T')[0];
        const todayAttendance = db.attendance.filter(a => a.date === todayStr && a.status === 'present').length;
        
        // Sum paid payments for monthly revenue
        const monthlyRevenue = db.payments
          .filter(p => p.status === 'paid')
          .reduce((sum, p) => sum + p.amount, 0);
          
        const activeMemberships = db.members.filter(m => m.status === 'active').length;

        // Mock Recharts Chart Timelines
        const growthChart = [
          { month: 'Jan', members: 65, trainers: 3 },
          { month: 'Feb', members: 78, trainers: 4 },
          { month: 'Mar', members: 92, trainers: 4 },
          { month: 'Apr', members: 110, trainers: 4 },
          { month: 'May', members: 125, trainers: 4 },
          { month: 'Jun', members: db.members.length, trainers: db.trainers.length }
        ];

        const revenueChart = [
          { month: 'Jan', revenue: 4200 },
          { month: 'Feb', revenue: 5100 },
          { month: 'Mar', revenue: 6400 },
          { month: 'Apr', revenue: 7800 },
          { month: 'May', revenue: 8100 },
          { month: 'Jun', revenue: monthlyRevenue }
        ];

        const attendanceChart = [
          { day: 'Mon', present: 52, absent: 8, late: 5 },
          { day: 'Tue', present: 55, absent: 6, late: 4 },
          { day: 'Wed', present: 48, absent: 10, late: 7 },
          { day: 'Thu', present: 58, absent: 5, late: 2 },
          { day: 'Fri', present: 45, absent: 12, late: 8 },
          { day: 'Sat', present: 60, absent: 4, late: 1 },
          { day: 'Sun', present: 35, absent: 8, late: 2 }
        ];

        // Combined average weight / fat history for active members
        const weightProgressChart = [
          { month: 'Jan', weight: 81.2, fat: 17.5 },
          { month: 'Feb', weight: 80.5, fat: 16.8 },
          { month: 'Mar', weight: 79.8, fat: 16.0 },
          { month: 'Apr', weight: 79.2, fat: 15.5 },
          { month: 'May', weight: 78.8, fat: 15.0 },
          { month: 'Jun', weight: 78.5, fat: 14.5 }
        ];

        // Build recent activities feed
        const recentActivities = [
          ...db.members.slice(-3).map(m => ({
            id: `act-m-${m.id}`,
            type: 'member_signup',
            title: 'New Member Registered',
            description: `${m.name} joined under ${db.plans.find(p => p.id === m.planId)?.name || 'Basic'}.`,
            time: m.joinDate
          })),
          ...db.payments.slice(-3).map(p => ({
            id: `act-p-${p.id}`,
            type: 'payment',
            title: 'Membership Renewal',
            description: `${p.memberName} paid ₹${p.amount} via Invoicing.`,
            time: p.date
          })),
          ...db.attendance.slice(-3).map(a => ({
            id: `act-a-${a.id}`,
            type: 'attendance',
            title: 'Check-in Gate Entry',
            description: `${a.name} checked in at ${a.time} via ${a.gate}.`,
            time: a.date
          }))
        ].sort((a, b) => b.time.localeCompare(a.time)).slice(0, 8);

        return jsonResponse({
          stats: { totalMembers, activeMembers, totalTrainers, todayAttendance, monthlyRevenue, activeMemberships },
          charts: { growth: growthChart, revenue: revenueChart, attendance: attendanceChart, weightProgress: weightProgressChart },
          recentActivities
        });
      }

      case 'members': {
        if (id) {
          const member = db.members.find(m => m.id === id);
          if (!member) return jsonResponse({ error: 'Member not found' }, 404);
          
          // Enrich member plan & trainer details
          const plan = db.plans.find(p => p.id === member.planId);
          const trainer = db.trainers.find(t => t.id === member.trainerId);
          const workout = db.workouts.find(w => w.id === member.assignedWorkoutId);
          const diet = db.diets.find(d => d.id === member.assignedDietId);
          const memberPayments = db.payments.filter(p => p.memberId === id);
          const memberAttendance = db.attendance.filter(a => a.memberId === id);

          return jsonResponse({
            ...member,
            planDetails: plan,
            trainerDetails: trainer,
            workoutDetails: workout,
            dietDetails: diet,
            payments: memberPayments,
            attendance: memberAttendance
          });
        }
        return jsonResponse(db.members);
      }

      case 'trainers': {
        if (id) {
          const trainer = db.trainers.find(t => t.id === id);
          if (!trainer) return jsonResponse({ error: 'Trainer not found' }, 404);
          
          const assignedMembers = db.members.filter(m => m.trainerId === id);
          const attendanceRate = trainer.attendanceRate;

          return jsonResponse({
            ...trainer,
            assignedMembers,
            attendanceRate
          });
        }
        return jsonResponse(db.trainers);
      }

      case 'plans': {
        return jsonResponse(db.plans);
      }

      case 'workouts': {
        return jsonResponse(db.workouts);
      }

      case 'diets': {
        return jsonResponse(db.diets);
      }

      case 'attendance': {
        return jsonResponse(db.attendance);
      }

      case 'payments': {
        return jsonResponse(db.payments);
      }

      case 'notifications': {
        return jsonResponse(db.notifications);
      }

      default:
        return jsonResponse({ error: 'Resource not found' }, 404);
    }
  } catch (err: any) {
    return jsonResponse({ error: err.message }, 500);
  }
}

// --- POST HANDLERS (CREATES & ACTIONS) ---
export async function POST(
  request: Request,
  { params }: { params: Params }
) {
  const { path } = await params;
  const resource = path[0];
  const subAction = path[1];

  try {
    const body = await request.json();

    switch (resource) {
      case 'auth': {
        if (subAction === 'login') {
          const { email, password } = body;
          if (email === 'admin@gym.com' && password === 'admin123') {
            return jsonResponse({
              success: true,
              token: 'session_token_gym_admin_2026',
              user: { name: 'Alex Mercer', email: 'admin@gym.com', role: 'Super Admin' }
            });
          }
          return jsonResponse({ error: 'Invalid email or password credentials' }, 401);
        }
        return jsonResponse({ error: 'Invalid auth endpoint' }, 404);
      }

      case 'members': {
        // Register New Member
        const { name, email, mobile, planId, trainerId, currentWeight, bodyFat } = body;
        const newId = `MEM-${String(db.members.length + 1).padStart(3, '0')}`;
        
        const weightVal = parseFloat(currentWeight) || 75;
        const fatVal = parseFloat(bodyFat) || 18;
        const muscleVal = Math.round(weightVal * (1 - fatVal / 100) * 0.55 * 10) / 10;
        const bmiVal = Math.round((weightVal / 3.06) * 10) / 10; // Dummy Height = 1.75m -> height^2 = 3.0625

        const newMember: Member = {
          id: newId,
          name,
          email,
          mobile,
          status: 'active',
          planId,
          trainerId: trainerId || '',
          avatarUrl: `https://images.unsplash.com/photo-${['1535713875002-d1d0cf377fde', '1580489944761-15a19d654956', '1633332755192-727a05c4013d', '1438761681033-6461ffad8d80'][db.members.length % 4]}?q=80&w=100&auto=format&fit=crop`,
          joinDate: new Date().toISOString().split('T')[0],
          currentWeight: weightVal,
          bodyFat: fatVal,
          muscleMass: muscleVal,
          bmi: bmiVal,
          measurements: { chest: 96, waist: 78, biceps: 32 },
          weightHistory: [{ date: 'Jun', value: weightVal }],
          bodyFatHistory: [{ date: 'Jun', value: fatVal }],
          muscleMassHistory: [{ date: 'Jun', value: muscleVal }],
          timeline: [{ date: new Date().toISOString().split('T')[0], title: 'Account Opened', description: 'Registered member profile.', category: 'milestone' }]
        };

        db.members.push(newMember);

        // Add corresponding invoice log entry
        const plan = db.plans.find(p => p.id === planId);
        if (plan) {
          const invId = `INV-2026-${String(db.payments.length + 1).padStart(3, '0')}`;
          db.payments.push({
            id: invId,
            memberId: newId,
            memberName: name,
            amount: plan.price,
            date: newMember.joinDate,
            type: 'Subscription Renewal',
            status: 'paid'
          });
        }

        return jsonResponse(newMember, 21);
      }

      case 'trainers': {
        const { name, email, mobile, experience, certifications } = body;
        const newId = `TRN-${String(db.trainers.length + 1).padStart(3, '0')}`;

        const certs = typeof certifications === 'string' 
          ? certifications.split(',').map((c: string) => c.trim()).filter((c: string) => c.length > 0)
          : certifications;

        const newTrainer: Trainer = {
          id: newId,
          name,
          email,
          mobile,
          experience: parseInt(experience) || 1,
          rating: 4.8,
          status: 'active',
          avatarUrl: `https://images.unsplash.com/photo-${['1567013127542-490d757e51fc', '1548690312-e3b507d8c110', '1534438327276-14e5300c3a48', '1594381898411-846e7d193883'][db.trainers.length % 4]}?q=80&w=150&auto=format&fit=crop`,
          certifications: certs || ['CPT'],
          attendanceRate: 100,
          successRate: 90
        };

        db.trainers.push(newTrainer);
        return jsonResponse(newTrainer, 21);
      }

      case 'plans': {
        const { name, price, duration, features } = body;
        const newId = `PLAN-${name.toUpperCase().replace(/\s+/g, '-')}`;
        
        const parsedFeatures = typeof features === 'string'
          ? features.split(',').map((f: string) => f.trim()).filter((f: string) => f.length > 0)
          : features;

        const newPlan: MembershipPlan = {
          id: newId,
          name,
          price: parseInt(price) || 49,
          duration: duration || 'month',
          features: parsedFeatures || [],
          popular: false
        };

        db.plans.push(newPlan);
        return jsonResponse(newPlan, 21);
      }

      case 'workouts': {
        const { name, category, exercises } = body;
        const newId = `WRK-${String(db.workouts.length + 1).padStart(3, '0')}`;
        
        const newWorkout: WorkoutPlan = {
          id: newId,
          name,
          category,
          exercises: exercises || []
        };
        
        db.workouts.push(newWorkout);
        return jsonResponse(newWorkout, 21);
      }

      case 'diets': {
        const { name, meals } = body;
        const newId = `DIET-${String(db.diets.length + 1).padStart(3, '0')}`;
        
        const newDiet: DietPlan = {
          id: newId,
          name,
          meals: meals || []
        };
        
        db.diets.push(newDiet);
        return jsonResponse(newDiet, 21);
      }

      case 'attendance': {
        // QR Simulator Scan check-in
        const { memberId, gate } = body;
        const member = db.members.find(m => m.id === memberId);
        if (!member) return jsonResponse({ error: 'Member not found' }, 404);

        const newId = `ATT-${String(db.attendance.length + 1).padStart(3, '0')}`;
        const now = new Date();
        
        let hours = now.getHours();
        const ampm = hours >= 12 ? 'PM' : 'AM';
        hours = hours % 12 || 12;
        const minutes = String(now.getMinutes()).padStart(2, '0');
        const timeStr = `${hours}:${minutes} ${ampm}`;
        const dateStr = now.toISOString().split('T')[0];

        // Access rules: suspended member check-in gets absent/late flag or denied status
        const isSuspended = member.status === 'suspended';
        
        const record: AttendanceRecord = {
          id: newId,
          memberId,
          name: member.name,
          time: timeStr,
          date: dateStr,
          gate: gate || 'Gate A - Main Entry',
          status: isSuspended ? 'absent' : (now.getHours() >= 10 ? 'late' : 'present')
        };

        db.attendance.unshift(record);

        // Add scan milestone to member timeline
        member.timeline.unshift({
          date: dateStr,
          title: isSuspended ? 'Gate Scan Denied' : 'Gate Scan Verified',
          description: `Attempted scan entry via ${record.gate}. Status: ${record.status.toUpperCase()}`,
          category: isSuspended ? 'milestone' : 'coaching'
        });

        return jsonResponse(record, 21);
      }

      case 'notifications': {
        const { target, type, message } = body;
        const newId = `NOT-${String(db.notifications.length + 1).padStart(3, '0')}`;
        
        const newNotification: GymNotification = {
          id: newId,
          target,
          type,
          message,
          sentAt: new Date().toISOString()
        };

        db.notifications.unshift(newNotification);

        // If target is a single user, append to member's timeline
        if (target !== 'All Members' && target !== 'All Trainers') {
          const member = db.members.find(m => m.name === target || m.id === target);
          if (member) {
            member.timeline.unshift({
              date: new Date().toISOString().split('T')[0],
              title: `Notification Received: ${type}`,
              description: message,
              category: 'milestone'
            });
          }
        }

        return jsonResponse(newNotification, 21);
      }

      default:
        return jsonResponse({ error: 'Endpoint action not found' }, 404);
    }
  } catch (err: any) {
    return jsonResponse({ error: err.message }, 500);
  }
}

// --- PUT / PATCH HANDLERS (UPDATES) ---
export async function PUT(
  request: Request,
  { params }: { params: Params }
) {
  const { path } = await params;
  const resource = path[0];
  const id = path[1];

  try {
    const body = await request.json();

    if (resource === 'members' && id) {
      const index = db.members.findIndex(m => m.id === id);
      if (index === -1) return jsonResponse({ error: 'Member not found' }, 404);

      const existing = db.members[index];
      const updated: Member = {
        ...existing,
        ...body,
        measurements: body.measurements ? { ...existing.measurements, ...body.measurements } : existing.measurements
      };

      // If weight changes, append to weight history
      if (body.currentWeight && parseFloat(body.currentWeight) !== existing.currentWeight) {
        const newWeight = parseFloat(body.currentWeight);
        updated.currentWeight = newWeight;
        updated.weightHistory.push({
          date: new Date().toLocaleString('en-US', { month: 'short' }),
          value: newWeight
        });
        
        // Re-calculate BMI
        updated.bmi = Math.round((newWeight / 3.06) * 10) / 10;
        
        // Add log to timeline
        updated.timeline.unshift({
          date: new Date().toISOString().split('T')[0],
          title: 'Weight Measurement Updated',
          description: `Weight adjusted to ${newWeight}kg. New BMI: ${updated.bmi}`,
          category: 'milestone'
        });
      }

      if (body.bodyFat && parseFloat(body.bodyFat) !== existing.bodyFat) {
        const newFat = parseFloat(body.bodyFat);
        updated.bodyFat = newFat;
        updated.bodyFatHistory.push({
          date: new Date().toLocaleString('en-US', { month: 'short' }),
          value: newFat
        });
        updated.muscleMass = Math.round(updated.currentWeight * (1 - newFat / 100) * 0.55 * 10) / 10;
        updated.muscleMassHistory.push({
          date: new Date().toLocaleString('en-US', { month: 'short' }),
          value: updated.muscleMass
        });
      }

      db.members[index] = updated;
      return jsonResponse(updated);
    }

    if (resource === 'trainers' && id) {
      const index = db.trainers.findIndex(t => t.id === id);
      if (index === -1) return jsonResponse({ error: 'Trainer not found' }, 404);

      const existing = db.trainers[index];
      const updated: Trainer = {
        ...existing,
        ...body
      };

      db.trainers[index] = updated;
      return jsonResponse(updated);
    }

    return jsonResponse({ error: 'Update target not supported' }, 400);
  } catch (err: any) {
    return jsonResponse({ error: err.message }, 500);
  }
}

// Support status changes (e.g. PATCH)
export async function PATCH(
  request: Request,
  { params }: { params: Params }
) {
  const { path } = await params;
  const resource = path[0];
  const id = path[1];
  const subAction = path[2];

  try {
    if (resource === 'members' && id) {
      const member = db.members.find(m => m.id === id);
      if (!member) return jsonResponse({ error: 'Member not found' }, 404);

      if (subAction === 'status') {
        const body = await request.json();
        member.status = body.status; // 'active' | 'suspended'
        
        member.timeline.unshift({
          date: new Date().toISOString().split('T')[0],
          title: `Status Changed`,
          description: `Membership status toggled to ${body.status.toUpperCase()}.`,
          category: 'milestone'
        });

        return jsonResponse(member);
      }
    }

    if (resource === 'plans' && id) {
      const plan = db.plans.find(p => p.id === id);
      if (!plan) return jsonResponse({ error: 'Plan not found' }, 404);
      
      plan.popular = !plan.popular;
      return jsonResponse(plan);
    }

    return jsonResponse({ error: 'Action not supported' }, 400);
  } catch (err: any) {
    return jsonResponse({ error: err.message }, 500);
  }
}

// --- DELETE HANDLERS ---
export async function DELETE(
  request: Request,
  { params }: { params: Params }
) {
  const { path } = await params;
  const resource = path[0];
  const id = path[1];

  try {
    if (!id) return jsonResponse({ error: 'ID is required' }, 400);

    switch (resource) {
      case 'members': {
        const index = db.members.findIndex(m => m.id === id);
        if (index === -1) return jsonResponse({ error: 'Member not found' }, 404);
        db.members.splice(index, 1);
        return jsonResponse({ success: true, message: 'Member deleted successfully' });
      }

      case 'trainers': {
        const index = db.trainers.findIndex(t => t.id === id);
        if (index === -1) return jsonResponse({ error: 'Trainer not found' }, 404);
        db.trainers.splice(index, 1);
        // Unassign from members
        db.members.forEach(m => {
          if (m.trainerId === id) m.trainerId = '';
        });
        return jsonResponse({ success: true, message: 'Trainer removed' });
      }

      case 'plans': {
        const index = db.plans.findIndex(p => p.id === id);
        if (index === -1) return jsonResponse({ error: 'Plan not found' }, 404);
        db.plans.splice(index, 1);
        return jsonResponse({ success: true, message: 'Plan removed' });
      }

      case 'workouts': {
        const index = db.workouts.findIndex(w => w.id === id);
        if (index === -1) return jsonResponse({ error: 'Workout template not found' }, 404);
        db.workouts.splice(index, 1);
        db.members.forEach(m => {
          if (m.assignedWorkoutId === id) delete m.assignedWorkoutId;
        });
        return jsonResponse({ success: true, message: 'Workout deleted' });
      }

      case 'diets': {
        const index = db.diets.findIndex(d => d.id === id);
        if (index === -1) return jsonResponse({ error: 'Diet template not found' }, 404);
        db.diets.splice(index, 1);
        db.members.forEach(m => {
          if (m.assignedDietId === id) delete m.assignedDietId;
        });
        return jsonResponse({ success: true, message: 'Diet deleted' });
      }

      default:
        return jsonResponse({ error: 'Resource not supported for delete' }, 400);
    }
  } catch (err: any) {
    return jsonResponse({ error: err.message }, 500);
  }
}
