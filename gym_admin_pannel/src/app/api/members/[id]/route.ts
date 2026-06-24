import { NextResponse } from 'next/server';
import { mockMembers } from '@/lib/mock-data';

export async function GET(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const member = mockMembers.find((m) => m.id === id);
  if (!member) {
    return NextResponse.json({ error: 'Member not found' }, { status: 404 });
  }
  return NextResponse.json(member);
}

export async function PUT(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const body = await request.json();
  const index = mockMembers.findIndex((m) => m.id === id);
  if (index === -1) {
    return NextResponse.json({ error: 'Member not found' }, { status: 404 });
  }
  
  mockMembers[index] = { ...mockMembers[index], ...body };
  return NextResponse.json(mockMembers[index]);
}

export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params;
  const index = mockMembers.findIndex((m) => m.id === id);
  if (index === -1) {
    return NextResponse.json({ error: 'Member not found' }, { status: 404 });
  }
  
  mockMembers.splice(index, 1);
  return NextResponse.json({ success: true });
}
