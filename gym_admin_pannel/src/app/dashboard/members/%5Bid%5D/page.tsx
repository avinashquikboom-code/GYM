'use client';

import React, { use } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { 
  Dumbbell, Apple, Calendar, DollarSign, Activity, Settings, 
  Ruler, History, ArrowLeft, Loader2, Sparkles, Scale, Percent, 
  TrendingUp, CheckCircle, HelpCircle, XCircle, AlertCircle
} from 'lucide-react';
import Link from 'next/link';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import { 
  AreaChart, Area, LineChart, Line, XAxis, YAxis, 
  CartesianGrid, Tooltip, ResponsiveContainer 
} from 'recharts';
import { toast } from 'sonner';

interface MemberDetailParams {
  params: Promise<{ id: string }>;
}

const fetchMemberDetail = async (id: string) => {
  const res = await fetch(`/api/members/${id}`);
  if (!res.ok) throw new Error('Member not found');
  return res.json();
};

const fetchWorkoutsList = async () => {
  const res = await fetch('/api/workouts');
  return res.json();
};

const fetchDietsList = async () => {
  const res = await fetch('/api/diets');
  return res.json();
};

export default function MemberDetailPage({ params }: MemberDetailParams) {
  const { id } = use(params);
  const queryClient = useQueryClient();

  // Queries
  const { data: member, isLoading, isError } = useQuery<any>({
    queryKey: ['member', id],
    queryFn: () => fetchMemberDetail(id),
  });

  const { data: workouts = [] } = useQuery<any[]>({
    queryKey: ['workouts'],
    queryFn: fetchWorkoutsList,
  });

  const { data: diets = [] } = useQuery<any[]>({
    queryKey: ['diets'],
    queryFn: fetchDietsList,
  });

  // Assign Workout Mutation
  const assignWorkoutMutation = useMutation({
    mutationFn: async (workoutId: string) => {
      const res = await fetch(`/api/members/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ assignedWorkoutId: workoutId })
      });
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['member', id] });
      toast.success('Workout plan assigned successfully');
    }
  });

  // Assign Diet Mutation
  const assignDietMutation = useMutation({
    mutationFn: async (dietId: string) => {
      const res = await fetch(`/api/members/${id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ assignedDietId: dietId })
      });
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['member', id] });
      toast.success('Diet plan assigned successfully');
    }
  });

  if (isLoading) {
    return (
      <div className="flex h-[calc(100vh-80px)] w-full items-center justify-center bg-[#0E0F12]">
        <div className="flex flex-col items-center gap-3">
          <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
          <span className="text-xs font-semibold text-[#8E9297] tracking-widest uppercase">Loading Profile...</span>
        </div>
      </div>
    );
  }

  if (isError || !member) {
    return (
      <div className="flex h-[calc(100vh-80px)] w-full items-center justify-center bg-[#0E0F12] text-red-500">
        <div className="flex flex-col items-center gap-2">
          <AlertCircle className="h-10 w-10 text-red-500" />
          <span className="text-sm font-bold">Profile not found. Make sure ID matches database register.</span>
          <Link href="/dashboard/members">
            <Button variant="outline" className="mt-4 border-[#2C3038] text-white">Back to Directory</Button>
          </Link>
        </div>
      </div>
    );
  }

  const tooltipStyle = {
    backgroundColor: '#1C1E22',
    borderColor: '#2C3038',
    color: '#FFFFFF',
    borderRadius: '12px',
    fontSize: '11px',
  };

  return (
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
      {/* Back link */}
      <div className="flex items-center gap-3">
        <Link href="/dashboard/members">
          <Button variant="ghost" size="icon" className="text-[#8E9297] hover:text-white hover:bg-[#252930] rounded-xl">
            <ArrowLeft className="h-5 w-5" />
          </Button>
        </Link>
        <div className="flex flex-col">
          <span className="text-xs font-semibold text-[#8E9297] uppercase tracking-widest">MEMBERS PROFILE</span>
          <h2 className="text-base font-bold text-white leading-none mt-0.5">Details Overview</h2>
        </div>
      </div>

      {/* Profile summary header banner card */}
      <Card className="bg-[#1C1E22] border-[#2C3038] text-white overflow-hidden relative">
        <div className="absolute top-0 left-0 right-0 h-[2px] bg-[#7CE047]" />
        <CardContent className="p-6">
          <div className="flex flex-col md:flex-row gap-6 items-center justify-between">
            <div className="flex flex-col md:flex-row gap-5 items-center md:items-start text-center md:text-left">
              <Avatar className="h-20 w-20 border-2 border-[#2C3038]">
                <AvatarImage src={member.avatarUrl} alt={member.name} />
                <AvatarFallback>{member.name[0]}</AvatarFallback>
              </Avatar>
              <div className="space-y-1.5">
                <div className="flex items-center gap-3 justify-center md:justify-start">
                  <h1 className="font-heading text-2xl font-extrabold tracking-wide uppercase text-white">{member.name}</h1>
                  <Badge className={`rounded-xl px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
                    member.status === 'active' ? 'bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30' : 'bg-red-500/10 text-red-500 border border-red-500/30'
                  }`}>
                    {member.status}
                  </Badge>
                </div>
                <p className="text-xs text-[#8E9297] font-medium">{member.email} &bull; {member.mobile}</p>
                <div className="flex flex-wrap gap-2 justify-center md:justify-start">
                  <Badge variant="secondary" className="bg-[#252930] text-[#8E9297] hover:bg-[#252930] border border-[#2C3038] rounded-lg text-[9px] font-semibold">
                    ID: {member.id}
                  </Badge>
                  <Badge variant="secondary" className="bg-[#252930] text-[#8E9297] hover:bg-[#252930] border border-[#2C3038] rounded-lg text-[9px] font-semibold">
                    Plan: {member.planDetails?.name || 'Standard'}
                  </Badge>
                  <Badge variant="secondary" className="bg-[#252930] text-[#8E9297] hover:bg-[#252930] border border-[#2C3038] rounded-lg text-[9px] font-semibold">
                    Coach: {member.trainerDetails?.name || 'Self-Training'}
                  </Badge>
                </div>
              </div>
            </div>

            {/* Quick Metrics bubbles */}
            <div className="flex gap-6 shrink-0 border-t md:border-t-0 md:border-l border-[#2C3038] pt-6 md:pt-0 md:pl-8 w-full md:w-auto justify-around">
              <div className="flex flex-col items-center">
                <Scale className="h-5 w-5 text-[#7CE047] mb-1" />
                <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Weight</span>
                <span className="text-lg font-heading font-extrabold text-white mt-0.5">{member.currentWeight} kg</span>
              </div>
              <div className="flex flex-col items-center">
                <Percent className="h-5 w-5 text-[#FF5252] mb-1" />
                <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Body Fat</span>
                <span className="text-lg font-heading font-extrabold text-white mt-0.5">{member.bodyFat}%</span>
              </div>
              <div className="flex flex-col items-center">
                <TrendingUp className="h-5 w-5 text-[#2196F3] mb-1" />
                <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">BMI</span>
                <span className="text-lg font-heading font-extrabold text-white mt-0.5">{member.bmi}</span>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Tabs Menu navigation */}
      <Tabs defaultValue="overview" className="space-y-6">
        <TabsList className="bg-[#1C1E22] border border-[#2C3038] p-1 rounded-xl flex flex-wrap h-auto gap-1">
          <TabsTrigger value="overview" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <History className="h-3.5 w-3.5 mr-1.5" /> Overview
          </TabsTrigger>
          <TabsTrigger value="workout" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <Dumbbell className="h-3.5 w-3.5 mr-1.5" /> Workout Plan
          </TabsTrigger>
          <TabsTrigger value="diet" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <Apple className="h-3.5 w-3.5 mr-1.5" /> Diet Plan
          </TabsTrigger>
          <TabsTrigger value="attendance" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <Calendar className="h-3.5 w-3.5 mr-1.5" /> Attendance
          </TabsTrigger>
          <TabsTrigger value="payments" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <DollarSign className="h-3.5 w-3.5 mr-1.5" /> Payments
          </TabsTrigger>
          <TabsTrigger value="transformation" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <Activity className="h-3.5 w-3.5 mr-1.5" /> Transformation
          </TabsTrigger>
          <TabsTrigger value="measurements" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <Ruler className="h-3.5 w-3.5 mr-1.5" /> Measurements
          </TabsTrigger>
        </TabsList>

        {/* 1. OVERVIEW TAB CONTENT */}
        <TabsContent value="overview" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
            
            {/* Weight Progression Chart */}
            <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
              <CardHeader className="pb-2">
                <CardTitle className="font-heading text-base font-bold text-white uppercase tracking-wider">Weight History Progress</CardTitle>
                <CardDescription className="text-xs text-[#8E9297]">Roster weight log progression timeline chart</CardDescription>
              </CardHeader>
              <CardContent className="h-64 pt-4">
                <ResponsiveContainer width="100%" height="100%">
                  <AreaChart data={member.weightHistory} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
                    <defs>
                      <linearGradient id="colorWeight" x1="0" y1="0" x2="0" y2="1">
                        <stop offset="5%" stopColor="#7CE047" stopOpacity={0.3} />
                        <stop offset="95%" stopColor="#7CE047" stopOpacity={0} />
                      </linearGradient>
                    </defs>
                    <CartesianGrid stroke="#2C3038" strokeDasharray="3 3" vertical={false} />
                    <XAxis dataKey="date" stroke="#8E9297" fontSize={10} tickLine={false} />
                    <YAxis stroke="#8E9297" fontSize={10} tickLine={false} domain={['dataMin - 5', 'dataMax + 5']} />
                    <Tooltip contentStyle={tooltipStyle} />
                    <Area type="monotone" dataKey="value" stroke="#7CE047" strokeWidth={2.5} fillOpacity={1} fill="url(#colorWeight)" name="Weight (kg)" />
                  </AreaChart>
                </ResponsiveContainer>
              </CardContent>
            </Card>

            {/* Timeline log tracker */}
            <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
              <CardHeader>
                <CardTitle className="font-heading text-base font-bold text-white uppercase tracking-wider">Member Timeline</CardTitle>
                <CardDescription className="text-xs text-[#8E9297]">Vertical audit history trail of checkins and updates</CardDescription>
              </CardHeader>
              <CardContent className="max-h-64 overflow-y-auto pr-1">
                <div className="space-y-4 relative pl-4 border-l border-[#2C3038]">
                  {member.timeline.map((event: any, idx: number) => (
                    <div key={idx} className="relative">
                      <div className="absolute left-[-21px] top-1.5 w-2.5 h-2.5 rounded-full bg-[#7CE047] border border-[#0E0F12]" />
                      <div className="flex justify-between items-center">
                        <h4 className="text-xs font-bold text-white">{event.title}</h4>
                        <span className="text-[9px] text-[#8E9297] font-semibold">{event.date}</span>
                      </div>
                      <p className="text-[11px] text-[#8E9297] mt-1 font-medium leading-normal">{event.description}</p>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* 2. WORKOUT TAB CONTENT */}
        <TabsContent value="workout">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
            <CardHeader className="flex flex-row items-center justify-between border-b border-[#2C3038] pb-4">
              <div>
                <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider">Workout Routine</CardTitle>
                <CardDescription className="text-xs text-[#8E9297]">Exercises list assigned by Personal Trainer</CardDescription>
              </div>
              
              {/* Workout assign dropdown picker */}
              <div className="flex items-center gap-3">
                <select 
                  value={member.assignedWorkoutId || ''} 
                  onChange={(e) => assignWorkoutMutation.mutate(e.target.value)}
                  className="bg-[#252930] border border-[#2C3038] text-xs rounded-xl p-2.5 outline-none font-medium text-white min-w-48"
                >
                  <option value="">Select Routine to Assign</option>
                  {workouts.map((w: any) => <option key={w.id} value={w.id}>{w.name}</option>)}
                </select>
              </div>
            </CardHeader>
            <CardContent className="pt-6">
              {!member.workoutDetails ? (
                <div className="text-center py-12 text-[#8E9297]">
                  <Dumbbell className="h-10 w-10 mx-auto text-[#8E9297]/50 mb-3" />
                  <p className="text-sm font-semibold">No active workout plan assigned</p>
                  <p className="text-xs mt-1 text-[#8E9297]/70">Choose a workout routine template from the dropdown above to assign.</p>
                </div>
              ) : (
                <div className="space-y-4">
                  <div className="flex justify-between items-center bg-[#252930]/30 p-3 rounded-xl border border-[#2C3038]/40">
                    <span className="text-sm font-bold text-white">{member.workoutDetails.name}</span>
                    <Badge className="bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30 rounded-xl text-[9px] uppercase font-bold">
                      {member.workoutDetails.category}
                    </Badge>
                  </div>
                  <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                    {member.workoutDetails.exercises.map((ex: any, idx: number) => (
                      <div key={idx} className="p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038]/50">
                        <h4 className="text-xs font-bold text-white">{ex.name}</h4>
                        <div className="grid grid-cols-3 gap-2 mt-3 text-center">
                          <div className="bg-[#252930] p-1.5 rounded-lg border border-[#2C3038]/40">
                            <span className="block text-[9px] font-bold text-[#8E9297] uppercase">Sets</span>
                            <span className="text-sm font-heading font-bold text-white">{ex.sets}</span>
                          </div>
                          <div className="bg-[#252930] p-1.5 rounded-lg border border-[#2C3038]/40">
                            <span className="block text-[9px] font-bold text-[#8E9297] uppercase">Reps</span>
                            <span className="text-sm font-heading font-bold text-white">{ex.reps}</span>
                          </div>
                          <div className="bg-[#252930] p-1.5 rounded-lg border border-[#2C3038]/40">
                            <span className="block text-[9px] font-bold text-[#8E9297] uppercase">Rest</span>
                            <span className="text-sm font-heading font-bold text-white">{ex.restTime}</span>
                          </div>
                        </div>
                        {ex.notes && <p className="text-[10px] text-[#8E9297] mt-3 bg-[#252930]/20 p-2 rounded-lg border border-[#2C3038]/20 italic">{ex.notes}</p>}
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* 3. DIET TAB CONTENT */}
        <TabsContent value="diet">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
            <CardHeader className="flex flex-row items-center justify-between border-b border-[#2C3038] pb-4">
              <div>
                <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider">Diet Routine Nutrition</CardTitle>
                <CardDescription className="text-xs text-[#8E9297]">Target meal schedules and daily caloric intake</CardDescription>
              </div>

              {/* Diet Assign select */}
              <div className="flex items-center gap-3">
                <select 
                  value={member.assignedDietId || ''} 
                  onChange={(e) => assignDietMutation.mutate(e.target.value)}
                  className="bg-[#252930] border border-[#2C3038] text-xs rounded-xl p-2.5 outline-none font-medium text-white min-w-48"
                >
                  <option value="">Select Diet to Assign</option>
                  {diets.map((d: any) => <option key={d.id} value={d.id}>{d.name}</option>)}
                </select>
              </div>
            </CardHeader>
            <CardContent className="pt-6">
              {!member.dietDetails ? (
                <div className="text-center py-12 text-[#8E9297]">
                  <Apple className="h-10 w-10 mx-auto text-[#8E9297]/50 mb-3" />
                  <p className="text-sm font-semibold">No active diet plan assigned</p>
                  <p className="text-xs mt-1 text-[#8E9297]/70">Choose a nutrition template from the dropdown above to assign.</p>
                </div>
              ) : (
                <div className="space-y-6">
                  {/* Macro Totals Header */}
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-4 p-4 rounded-xl bg-[#252930]/30 border border-[#2C3038]/50">
                    <div className="text-center">
                      <span className="block text-[10px] font-bold text-[#8E9297] uppercase">Calories Target</span>
                      <span className="text-lg font-heading font-extrabold text-[#7CE047] mt-1 block">
                        {member.dietDetails.meals.reduce((sum: number, m: any) => sum + m.calories, 0)} kcal
                      </span>
                    </div>
                    <div className="text-center">
                      <span className="block text-[10px] font-bold text-[#8E9297] uppercase">Protein</span>
                      <span className="text-lg font-heading font-extrabold text-[#2196F3] mt-1 block">
                        {member.dietDetails.meals.reduce((sum: number, m: any) => sum + m.protein, 0)}g
                      </span>
                    </div>
                    <div className="text-center">
                      <span className="block text-[10px] font-bold text-[#8E9297] uppercase">Carbohydrates</span>
                      <span className="text-lg font-heading font-extrabold text-[#FFC107] mt-1 block">
                        {member.dietDetails.meals.reduce((sum: number, m: any) => sum + m.carbs, 0)}g
                      </span>
                    </div>
                    <div className="text-center">
                      <span className="block text-[10px] font-bold text-[#8E9297] uppercase">Fats</span>
                      <span className="text-lg font-heading font-extrabold text-[#FF5252] mt-1 block">
                        {member.dietDetails.meals.reduce((sum: number, m: any) => sum + m.fats, 0)}g
                      </span>
                    </div>
                  </div>

                  {/* Meals List */}
                  <div className="space-y-4">
                    {member.dietDetails.meals.map((meal: any, idx: number) => (
                      <div key={idx} className="flex flex-col sm:flex-row sm:items-center justify-between p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038]/50 gap-4">
                        <div className="space-y-1">
                          <span className="text-[10px] font-bold text-[#7CE047] uppercase tracking-wider">{meal.category}</span>
                          <h4 className="text-sm font-bold text-white">{meal.name}</h4>
                        </div>
                        <div className="flex gap-4 text-xs font-semibold text-[#8E9297] shrink-0">
                          <span>Cals: <strong className="text-white">{meal.calories}</strong></span>
                          <span>P: <strong className="text-white">{meal.protein}g</strong></span>
                          <span>C: <strong className="text-white">{meal.carbs}g</strong></span>
                          <span>F: <strong className="text-white">{meal.fats}g</strong></span>
                        </div>
                      </div>
                    ))}
                  </div>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* 4. ATTENDANCE TAB CONTENT */}
        <TabsContent value="attendance">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
            <CardHeader>
              <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider">Gate Check-in Logs</CardTitle>
              <CardDescription className="text-xs text-[#8E9297]">Client entry validator logs history</CardDescription>
            </CardHeader>
            <CardContent>
              {member.attendance.length === 0 ? (
                <p className="text-center py-8 text-xs text-[#8E9297]">No attendance logs registered for this member.</p>
              ) : (
                <div className="overflow-x-auto">
                  <table className="w-full text-left">
                    <thead>
                      <tr className="border-b border-[#2C3038] text-xs font-bold text-[#8E9297] uppercase">
                        <th className="pb-3">Gate Name</th>
                        <th className="pb-3">Time Checked In</th>
                        <th className="pb-3">Date</th>
                        <th className="pb-3">Status</th>
                      </tr>
                    </thead>
                    <tbody className="text-xs font-medium">
                      {member.attendance.map((log: any) => (
                        <tr key={log.id} className="border-b border-[#2C3038] last:border-none">
                          <td className="py-4 text-white font-bold">{log.gate}</td>
                          <td className="py-4 text-[#8E9297]">{log.time}</td>
                          <td className="py-4 text-[#8E9297]">{log.date}</td>
                          <td className="py-4">
                            <Badge className={`rounded-xl px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
                              log.status === 'present' 
                                ? 'bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30' 
                                : log.status === 'late' 
                                  ? 'bg-[#FFC107]/10 text-[#FFC107] border border-[#FFC107]/30' 
                                  : 'bg-[#FF5252]/10 text-[#FF5252] border border-[#FF5252]/30'
                            }`}>
                              {log.status}
                            </Badge>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* 5. PAYMENTS TAB CONTENT */}
        <TabsContent value="payments">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
            <CardHeader>
              <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider">Invoices & Billing History</CardTitle>
              <CardDescription className="text-xs text-[#8E9297]">Billing cycles audit trail records</CardDescription>
            </CardHeader>
            <CardContent>
              {member.payments.length === 0 ? (
                <p className="text-center py-8 text-xs text-[#8E9297]">No payments history found.</p>
              ) : (
                <div className="overflow-x-auto">
                  <table className="w-full text-left">
                    <thead>
                      <tr className="border-b border-[#2C3038] text-xs font-bold text-[#8E9297] uppercase">
                        <th className="pb-3">Invoice ID</th>
                        <th className="pb-3">Amount</th>
                        <th className="pb-3">Billing Type</th>
                        <th className="pb-3">Invoice Date</th>
                        <th className="pb-3 text-right">Status</th>
                      </tr>
                    </thead>
                    <tbody className="text-xs font-medium">
                      {member.payments.map((p: any) => (
                        <tr key={p.id} className="border-b border-[#2C3038] last:border-none">
                          <td className="py-4 font-mono text-white">{p.id}</td>
                          <td className="py-4 font-bold text-white">${p.amount}</td>
                          <td className="py-4 text-[#8E9297]">{p.type}</td>
                          <td className="py-4 text-[#8E9297]">{p.date}</td>
                          <td className="py-4 text-right">
                            <Badge className={`rounded-xl px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
                              p.status === 'paid' 
                                ? 'bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30' 
                                : p.status === 'pending'
                                  ? 'bg-[#FFC107]/10 text-[#FFC107] border border-[#FFC107]/30'
                                  : 'bg-[#FF5252]/10 text-[#FF5252] border border-[#FF5252]/30'
                            }`}>
                              {p.status}
                            </Badge>
                          </td>
                        </tr>
                      ))}
                    </tbody>
                  </table>
                </div>
              )}
            </CardContent>
          </Card>
        </TabsContent>

        {/* 6. TRANSFORMATION TAB CONTENT */}
        <TabsContent value="transformation" className="space-y-6">
          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            <Card className="bg-[#1C1E22] border-[#2C3038] text-white text-center">
              <CardHeader>
                <CardTitle className="font-heading text-sm font-bold uppercase tracking-wider text-[#8E9297]">Before Body</CardTitle>
              </CardHeader>
              <CardContent className="flex flex-col items-center">
                <div className="w-full h-64 rounded-xl bg-[#252930] flex items-center justify-center border border-[#2C3038] relative overflow-hidden">
                  <Avatar className="w-full h-full rounded-none">
                    <AvatarImage src="https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300&auto=format&fit=crop" className="object-cover" />
                  </Avatar>
                  <div className="absolute bottom-2 left-2 bg-[#0E0F12]/80 px-2 py-1 rounded-md text-[10px] font-bold uppercase text-[#8E9297]">
                    Jan Baseline
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="bg-[#1C1E22] border-[#2C3038] text-white text-center">
              <CardHeader>
                <CardTitle className="font-heading text-sm font-bold uppercase tracking-wider text-[#7CE047]">Current Body</CardTitle>
              </CardHeader>
              <CardContent className="flex flex-col items-center">
                <div className="w-full h-64 rounded-xl bg-[#252930] flex items-center justify-center border border-[#7CE047]/30 relative overflow-hidden">
                  <Avatar className="w-full h-full rounded-none">
                    <AvatarImage src={member.avatarUrl} className="object-cover" />
                  </Avatar>
                  <div className="absolute bottom-2 left-2 bg-[#7CE047]/80 text-[#0E0F12] px-2 py-1 rounded-md text-[10px] font-bold uppercase">
                    Active Profile
                  </div>
                </div>
              </CardContent>
            </Card>

            <Card className="bg-[#1C1E22] border-[#2C3038] text-white text-center">
              <CardHeader>
                <CardTitle className="font-heading text-sm font-bold uppercase tracking-wider text-[#2196F3]">Goal Body Target</CardTitle>
              </CardHeader>
              <CardContent className="flex flex-col items-center">
                <div className="w-full h-64 rounded-xl bg-[#252930] flex items-center justify-center border border-[#2C3038] relative overflow-hidden">
                  <Avatar className="w-full h-full rounded-none">
                    <AvatarImage src="https://images.unsplash.com/photo-1548690312-e3b507d8c110?q=80&w=300&auto=format&fit=crop" className="object-cover" />
                  </Avatar>
                  <div className="absolute bottom-2 left-2 bg-[#2196F3]/80 px-2 py-1 rounded-md text-[10px] font-bold uppercase text-white">
                    Target Goal
                  </div>
                </div>
              </CardContent>
            </Card>
          </div>
        </TabsContent>

        {/* 7. MEASUREMENTS TAB CONTENT */}
        <TabsContent value="measurements">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
            <CardHeader>
              <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider">Physical Body Tape Measurements</CardTitle>
              <CardDescription className="text-xs text-[#8E9297]">Compare historical chest, waist, and biceps logs</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
                <div className="bg-[#252930]/40 p-5 rounded-xl border border-[#2C3038] text-center">
                  <span className="block text-xs font-bold text-[#8E9297] uppercase">Chest Circumference</span>
                  <span className="text-3xl font-heading font-extrabold text-white mt-2 block">{member.measurements?.chest || 98} cm</span>
                  <span className="text-[10px] text-[#7CE047] font-semibold mt-1 block">Baseline: 94 cm (+4 cm)</span>
                </div>
                <div className="bg-[#252930]/40 p-5 rounded-xl border border-[#2C3038] text-center">
                  <span className="block text-xs font-bold text-[#8E9297] uppercase">Waist Circumference</span>
                  <span className="text-3xl font-heading font-extrabold text-white mt-2 block">{member.measurements?.waist || 78} cm</span>
                  <span className="text-[10px] text-[#7CE047] font-semibold mt-1 block">Baseline: 84 cm (-6 cm)</span>
                </div>
                <div className="bg-[#252930]/40 p-5 rounded-xl border border-[#2C3038] text-center">
                  <span className="block text-xs font-bold text-[#8E9297] uppercase">Biceps (L/R)</span>
                  <span className="text-3xl font-heading font-extrabold text-white mt-2 block">{member.measurements?.biceps || 34} cm</span>
                  <span className="text-[10px] text-[#7CE047] font-semibold mt-1 block">Baseline: 30 cm (+4 cm)</span>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
