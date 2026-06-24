import { NextResponse } from 'next/server';
import { mockMembers } from '@/lib/mock-data';

export async function PATCH(
  request: Request,
  { params }: { params: { id: string } }
) {
  const { status } = await request.json();
  const index = mockMembers.findIndex((m) => m.id === params.id);
  if (index === -1) {
    return NextResponse.json({ error: 'Member not found' }, { status: 404 });
  }
  
  mockMembers[index].status = status;
  return NextResponse.json(mockMembers[index]);
}
