import { NextResponse } from 'next/server';
import {
  mockDashboardStats,
  getMembershipGrowthData,
  getRevenueData,
  getAttendanceData,
} from '@/lib/mock-data';

export async function GET() {
  const data = {
    stats: mockDashboardStats,
    charts: {
      growth: getMembershipGrowthData(),
      revenue: getRevenueData(),
      attendance: getAttendanceData(),
      weightProgress: [
        { month: 'Jan', weight: 82 },
        { month: 'Feb', weight: 80 },
        { month: 'Mar', weight: 79 },
        { month: 'Apr', weight: 78 },
        { month: 'May', weight: 77 },
        { month: 'Jun', weight: 76 },
      ],
    },
    recentActivities: [
      {
        id: '1',
        type: 'member_signup',
        title: 'New Member Registered',
        description: 'Rahul Sharma joined with Gold membership plan',
        time: '2 minutes ago',
      },
      {
        id: '2',
        type: 'payment',
        title: 'Payment Received',
        description: 'Priya Patel renewed Platinum membership - ₹9,000',
        time: '15 minutes ago',
      },
      {
        id: '3',
        type: 'attendance',
        title: 'Check-in Recorded',
        description: '45 members checked in today via QR code',
        time: '1 hour ago',
      },
      {
        id: '4',
        type: 'member_signup',
        title: 'Trainer Assignment',
        description: 'Vikram Singh assigned 3 new members',
        time: '2 hours ago',
      },
    ],
  };

  return NextResponse.json(data);
}
