import { NextResponse } from 'next/server';
import { mockMembers } from '@/lib/mock-data';

export async function GET() {
  return NextResponse.json(mockMembers);
}

export async function POST(request: Request) {
  const body = await request.json();
  const newMember = {
    id: String(mockMembers.length + 1),
    ...body,
    status: 'active',
    joinDate: new Date().toISOString().split('T')[0],
    bmi: Number(body.currentWeight) / 1.75, // Mock BMI calculation
    muscleMass: Math.floor(Math.random() * 10) + 25,
  };
  
  mockMembers.push(newMember);
  return NextResponse.json(newMember);
}
