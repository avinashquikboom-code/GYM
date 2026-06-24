import { NextResponse } from 'next/server';
import { mockMembershipPlans } from '@/lib/mock-data';

export async function GET() {
  return NextResponse.json(mockMembershipPlans);
}
