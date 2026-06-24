import { NextResponse } from 'next/server';

export async function POST(request: Request) {
  const { email, password } = await request.json();

  // Mock authentication - replace with actual auth logic
  if (email && password) {
    const user = {
      id: '1',
      name: 'Admin User',
      email: email,
      role: 'admin',
    };

    const token = 'mock-jwt-token-' + Date.now();

    return NextResponse.json({ user, token });
  }

  return NextResponse.json({ error: 'Invalid credentials' }, { status: 401 });
}
