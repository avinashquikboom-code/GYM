import { NextResponse } from 'next/server';
import { mockTrainers } from '@/lib/mock-data';

export async function GET() {
  return NextResponse.json(mockTrainers);
}
