'use client';

import React from 'react';
import {
  AreaChart, Area, BarChart, Bar, LineChart, Line,
  XAxis, YAxis, CartesianGrid, Tooltip, Legend, ResponsiveContainer
} from 'recharts';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';

interface DashboardChartsProps {
  growthData: any[];
  revenueData: any[];
  attendanceData: any[];
  progressData: any[];
}

export default function DashboardCharts({
  growthData,
  revenueData,
  attendanceData,
  progressData
}: DashboardChartsProps) {
  
  const tooltipStyle = {
    backgroundColor: '#15151a',
    borderColor: '#27272a',
    color: '#f1f5f9',
    borderRadius: '12px',
    fontSize: '12px',
    fontFamily: 'var(--font-montserrat), sans-serif',
  };

  return (
    <div className="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
      {/* 1. Revenue Area Chart */}
      <Card className="card-gradient border-border/50 text-foreground shadow-lg">
        <CardHeader>
          <CardTitle className="font-heading text-lg font-bold tracking-wider text-foreground uppercase">
            Revenue Analytics
          </CardTitle>
          <CardDescription className="text-muted-foreground text-xs">
            Dynamic monthly revenue curves representing membership billings
          </CardDescription>
        </CardHeader>
        <CardContent className="h-72">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={revenueData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
              <defs>
                <linearGradient id="colorRev" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="#10b981" stopOpacity={0.3} />
                  <stop offset="95%" stopColor="#10b981" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid stroke="#27272a" strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="month" stroke="#94a3b8" fontSize={10} tickLine={false} />
              <YAxis stroke="#94a3b8" fontSize={10} tickLine={false} />
              <Tooltip contentStyle={tooltipStyle} />
              <Area type="monotone" dataKey="revenue" stroke="#10b981" strokeWidth={3} fillOpacity={1} fill="url(#colorRev)" name="Monthly Revenue (₹)" />
            </AreaChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* 2. Membership Growth Bar Chart */}
      <Card className="card-gradient border-border/50 text-foreground shadow-lg">
        <CardHeader>
          <CardTitle className="font-heading text-lg font-bold tracking-wider text-foreground uppercase">
            Membership Growth
          </CardTitle>
          <CardDescription className="text-muted-foreground text-xs">
            Total active members and coaches registered over time
          </CardDescription>
        </CardHeader>
        <CardContent className="h-72">
          <ResponsiveContainer width="100%" height="100%">
            <BarChart data={growthData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
              <CartesianGrid stroke="#27272a" strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="month" stroke="#94a3b8" fontSize={10} tickLine={false} />
              <YAxis stroke="#94a3b8" fontSize={10} tickLine={false} />
              <Tooltip contentStyle={tooltipStyle} />
              <Bar dataKey="members" fill="#10b981" name="Members" radius={[4, 4, 0, 0]} />
              <Bar dataKey="trainers" fill="#06b6d4" name="Trainers" radius={[4, 4, 0, 0]} />
            </BarChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* 3. Gate Attendance Line Chart */}
      <Card className="card-gradient border-border/50 text-foreground shadow-lg">
        <CardHeader>
          <CardTitle className="font-heading text-lg font-bold tracking-wider text-foreground uppercase">
            Attendance Analytics
          </CardTitle>
          <CardDescription className="text-muted-foreground text-xs">
            Daily check-in gate volumes for the current week
          </CardDescription>
        </CardHeader>
        <CardContent className="h-72">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={attendanceData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
              <CartesianGrid stroke="#27272a" strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="day" stroke="#94a3b8" fontSize={10} tickLine={false} />
              <YAxis stroke="#94a3b8" fontSize={10} tickLine={false} />
              <Line type="monotone" dataKey="present" stroke="#10b981" strokeWidth={3} activeDot={{ r: 6 }} name="Present" />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>

      {/* 4. Combined Weight & Body Fat Progress */}
      <Card className="card-gradient border-border/50 text-foreground shadow-lg">
        <CardHeader>
          <CardTitle className="font-heading text-lg font-bold tracking-wider text-foreground uppercase">
            Weight & Body Fat Timelines
          </CardTitle>
          <CardDescription className="text-muted-foreground text-xs">
            Average client weight fluctuations and body fat percentage trends
          </CardDescription>
        </CardHeader>
        <CardContent className="h-72">
          <ResponsiveContainer width="100%" height="100%">
            <LineChart data={progressData} margin={{ top: 10, right: 10, left: -20, bottom: 0 }}>
              <CartesianGrid stroke="#27272a" strokeDasharray="3 3" vertical={false} />
              <XAxis dataKey="month" stroke="#94a3b8" fontSize={10} tickLine={false} />
              <YAxis stroke="#94a3b8" fontSize={10} tickLine={false} />
              <Tooltip contentStyle={tooltipStyle} />
              <Line type="monotone" dataKey="weight" stroke="#10b981" strokeWidth={2} name="Avg Weight (kg)" />
              <Line type="monotone" dataKey="fat" stroke="#ef4444" strokeWidth={2} name="Avg Body Fat (%)" />
            </LineChart>
          </ResponsiveContainer>
        </CardContent>
      </Card>
    </div>
  );
}
