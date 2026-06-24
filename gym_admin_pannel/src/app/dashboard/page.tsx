'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { motion } from 'framer-motion';
import { 
  Users, Award, CalendarCheck, DollarSign, ShieldAlert,
  ArrowUpRight, Activity, TrendingUp, Sparkles, Loader2, LogIn
} from 'lucide-react';
import { Card, CardContent, CardHeader, CardTitle } from '@/components/ui/card';
import DashboardCharts from '@/components/dashboard-charts';

interface DashboardData {
  stats: {
    totalMembers: number;
    activeMembers: number;
    totalTrainers: number;
    todayAttendance: number;
    monthlyRevenue: number;
    activeMemberships: number;
  };
  charts: {
    growth: any[];
    revenue: any[];
    attendance: any[];
    weightProgress: any[];
  };
  recentActivities: {
    id: string;
    type: string;
    title: string;
    description: string;
    time: string;
  }[];
}

const fetchDashboardData = async (): Promise<DashboardData> => {
  const res = await fetch('/api/dashboard');
  if (!res.ok) throw new Error('Failed to load dashboard data');
  return res.json();
};

export default function DashboardPage() {
  const { data, isLoading, isError } = useQuery<DashboardData>({
    queryKey: ['dashboard'],
    queryFn: fetchDashboardData,
    refetchInterval: 5000, // Refetch every 5 seconds to simulate live API data stream!
  });

  if (isLoading) {
    return (
      <div className="flex h-[calc(100vh-80px)] w-full items-center justify-center bg-[#0E0F12]">
        <div className="flex flex-col items-center gap-3">
          <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
          <span className="text-xs font-semibold text-[#8E9297] tracking-widest uppercase">Fetching Analytics...</span>
        </div>
      </div>
    );
  }

  if (isError || !data) {
    return (
      <div className="flex h-[calc(100vh-80px)] w-full items-center justify-center bg-[#0E0F12] text-red-500">
        <div className="flex flex-col items-center gap-2">
          <ShieldAlert className="h-10 w-10 text-red-500" />
          <span className="text-sm font-bold">Failed to load analytics dashboard. Please check API connection.</span>
        </div>
      </div>
    );
  }

  const { stats, charts, recentActivities } = data;

  const cardContainerVariants = {
    hidden: { opacity: 0 },
    show: {
      opacity: 1,
      transition: {
        staggerChildren: 0.05
      }
    }
  };

  const cardItemVariants = {
    hidden: { opacity: 0, y: 15 },
    show: { opacity: 1, y: 0 }
  };

  const kpis = [
    { title: 'Total Members', value: stats.totalMembers, footer: '+12% this month', icon: Users, color: '#7CE047' },
    { title: 'Active Members', value: stats.activeMembers, footer: `${Math.round((stats.activeMembers / stats.totalMembers) * 100)}% Active Rate`, icon: Sparkles, color: '#7CE047' },
    { title: 'Total Trainers', value: stats.totalTrainers, footer: 'All coaches active', icon: Award, color: '#5BAA32' },
    { title: 'Today\'s Attendance', value: stats.todayAttendance, footer: 'Gate scan logs validated', icon: CalendarCheck, color: '#2196F3' },
    { title: 'Monthly Revenue', value: `$${stats.monthlyRevenue.toLocaleString()}`, footer: 'Billing cycles complete', icon: DollarSign, color: '#7CE047' },
    { title: 'Active Memberships', value: stats.activeMemberships, footer: 'No pending suspensions', icon: TrendingUp, color: '#7CE047' },
  ];

  return (
    <div className="p-6 md:p-8 space-y-8 bg-[#0E0F12] min-h-full relative">
      
      {/* Dynamic ambient header block */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl md:text-4xl font-extrabold tracking-wider text-white uppercase">
            EXECUTIVE <span className="text-[#7CE047]">DASHBOARD</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Real-time telemetry, membership ratios, financial flows, and active check-ins.
          </p>
        </div>
      </div>

      {/* Statistics Cards Grid */}
      <motion.div 
        variants={cardContainerVariants}
        initial="hidden"
        animate="show"
        className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-6"
      >
        {kpis.map((kpi, idx) => {
          const IconComponent = kpi.icon;
          return (
            <motion.div key={idx} variants={cardItemVariants}>
              <Card className="bg-[#1C1E22] border-[#2C3038] hover:border-[#7CE047]/50 transition-all duration-300 group overflow-hidden relative">
                {/* Visual accent left line */}
                <div className="absolute left-0 top-0 bottom-0 w-[3px] bg-[#2C3038] group-hover:bg-[#7CE047] transition-all" />
                <CardHeader className="flex flex-row items-center justify-between pb-2">
                  <CardTitle className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">
                    {kpi.title}
                  </CardTitle>
                  <IconComponent className="h-5 w-5 text-[#8E9297] group-hover:text-[#7CE047] transition-all" />
                </CardHeader>
                <CardContent>
                  <div className="text-3xl font-heading font-extrabold tracking-wide text-white mt-1">
                    {kpi.value}
                  </div>
                  <p className="text-[10px] font-semibold text-[#8E9297] uppercase tracking-wider mt-1 flex items-center gap-1">
                    <span className="inline-block w-1.5 h-1.5 rounded-full bg-[#7CE047]" />
                    {kpi.footer}
                  </p>
                </CardContent>
              </Card>
            </motion.div>
          );
        })}
      </motion.div>

      {/* Interactive Charts Panels */}
      <DashboardCharts 
        growthData={charts.growth}
        revenueData={charts.revenue}
        attendanceData={charts.attendance}
        progressData={charts.weightProgress}
      />

      {/* Recent Activity Feeds */}
      <div className="grid grid-cols-1 gap-6">
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
          <CardHeader className="flex flex-row items-center justify-between border-b border-[#2C3038] pb-4">
            <div>
              <CardTitle className="font-heading text-lg font-bold tracking-wider uppercase">
                Recent Activities Log
              </CardTitle>
              <CardDescription className="text-[#8E9297] text-xs mt-0.5">
                Live stream audit trail of gate logins, payments, and member registrations
              </CardDescription>
            </div>
            <Activity className="h-5 w-5 text-[#7CE047]" />
          </CardHeader>
          <CardContent className="pt-6">
            <div className="space-y-4">
              {recentActivities.map((act) => (
                <div key={act.id} className="flex items-start gap-4 p-3.5 rounded-xl bg-[#252930]/40 border border-[#2C3038]/50 hover:bg-[#252930]/70 transition-all duration-200">
                  <div className="flex items-center justify-center w-9 h-9 rounded-lg bg-[#252930] border border-[#2C3038] shrink-0 text-[#7CE047]">
                    {act.type === 'member_signup' && <Users className="h-4.5 w-4.5" />}
                    {act.type === 'payment' && <DollarSign className="h-4.5 w-4.5" />}
                    {act.type === 'attendance' && <LogIn className="h-4.5 w-4.5" />}
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-center">
                      <h4 className="text-sm font-bold text-white truncate">{act.title}</h4>
                      <span className="text-[10px] text-[#8E9297] font-semibold">{act.time}</span>
                    </div>
                    <p className="text-xs text-[#8E9297] mt-1 font-medium leading-normal">{act.description}</p>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>
      </div>

    </div>
  );
}
