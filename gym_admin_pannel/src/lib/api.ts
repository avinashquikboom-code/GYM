// API Client Configuration
const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || '/api';

export async function apiRequest<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<T> {
  const token = typeof window !== 'undefined' ? localStorage.getItem('auth_token') : null;

  const response = await fetch(`${API_BASE_URL}${endpoint}`, {
    ...options,
    headers: {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
      ...options.headers,
    },
  });

  if (!response.ok) {
    throw new Error(`API Error: ${response.statusText}`);
  }

  return response.json();
}

// Auth API
export const authApi = {
  login: (credentials: { email: string; password: string }) =>
    apiRequest<{ user: any; token: string }>('/auth/login', {
      method: 'POST',
      body: JSON.stringify(credentials),
    }),
  
  logout: () =>
    apiRequest('/auth/logout', { method: 'POST' }),
  
  me: () =>
    apiRequest<any>('/auth/me'),
};

// Members API
export const membersApi = {
  getAll: (params?: any) =>
    apiRequest(`/members?${new URLSearchParams(params)}`),
  
  getById: (id: string) =>
    apiRequest(`/members/${id}`),
  
  create: (data: any) =>
    apiRequest('/members', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  
  update: (id: string, data: any) =>
    apiRequest(`/members/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  
  delete: (id: string) =>
    apiRequest(`/members/${id}`, { method: 'DELETE' }),
  
  suspend: (id: string) =>
    apiRequest(`/members/${id}/suspend`, { method: 'POST' }),
};

// Trainers API
export const trainersApi = {
  getAll: (params?: any) =>
    apiRequest(`/trainers?${new URLSearchParams(params)}`),
  
  getById: (id: string) =>
    apiRequest(`/trainers/${id}`),
  
  create: (data: any) =>
    apiRequest('/trainers', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  
  update: (id: string, data: any) =>
    apiRequest(`/trainers/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  
  delete: (id: string) =>
    apiRequest(`/trainers/${id}`, { method: 'DELETE' }),
  
  assignMember: (trainerId: string, memberId: string) =>
    apiRequest(`/trainers/${trainerId}/assign/${memberId}`, { method: 'POST' }),
  
  removeMember: (trainerId: string, memberId: string) =>
    apiRequest(`/trainers/${trainerId}/remove/${memberId}`, { method: 'POST' }),
};

// Dashboard API
export const dashboardApi = {
  getStats: () =>
    apiRequest('/dashboard/stats'),
  
  getMembershipGrowth: () =>
    apiRequest('/dashboard/membership-growth'),
  
  getRevenueAnalytics: () =>
    apiRequest('/dashboard/revenue'),
  
  getAttendanceAnalytics: () =>
    apiRequest('/dashboard/attendance'),
};

// Workout Plans API
export const workoutPlansApi = {
  getAll: () => apiRequest('/workout-plans'),
  getById: (id: string) => apiRequest(`/workout-plans/${id}`),
  create: (data: any) =>
    apiRequest('/workout-plans', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: (id: string, data: any) =>
    apiRequest(`/workout-plans/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  delete: (id: string) => apiRequest(`/workout-plans/${id}`, { method: 'DELETE' }),
  assign: (planId: string, memberId: string) =>
    apiRequest(`/workout-plans/${planId}/assign/${memberId}`, { method: 'POST' }),
};

// Diet Plans API
export const dietPlansApi = {
  getAll: () => apiRequest('/diet-plans'),
  getById: (id: string) => apiRequest(`/diet-plans/${id}`),
  create: (data: any) =>
    apiRequest('/diet-plans', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: (id: string, data: any) =>
    apiRequest(`/diet-plans/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  delete: (id: string) => apiRequest(`/diet-plans/${id}`, { method: 'DELETE' }),
  assign: (planId: string, memberId: string) =>
    apiRequest(`/diet-plans/${planId}/assign/${memberId}`, { method: 'POST' }),
};

// Attendance API
export const attendanceApi = {
  getToday: () => apiRequest('/attendance/today'),
  getByDate: (date: string) => apiRequest(`/attendance/${date}`),
  getMonthly: (month: string) => apiRequest(`/attendance/monthly/${month}`),
  markPresent: (memberId: string) =>
    apiRequest(`/attendance/mark/${memberId}`, { method: 'POST' }),
};

// Payments API
export const paymentsApi = {
  getAll: (params?: any) =>
    apiRequest(`/payments?${new URLSearchParams(params)}`),
  getById: (id: string) => apiRequest(`/payments/${id}`),
  create: (data: any) =>
    apiRequest('/payments', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: (id: string, data: any) =>
    apiRequest(`/payments/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  getRevenue: () => apiRequest('/payments/revenue'),
  getPending: () => apiRequest('/payments/pending'),
};

// Transformations API
export const transformationsApi = {
  getAll: () => apiRequest('/transformations'),
  getById: (id: string) => apiRequest(`/transformations/${id}`),
  getByMember: (memberId: string) => apiRequest(`/transformations/member/${memberId}`),
  create: (data: any) =>
    apiRequest('/transformations', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  update: (id: string, data: any) =>
    apiRequest(`/transformations/${id}`, {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  getTop: () => apiRequest('/transformations/top'),
};

// Notifications API
export const notificationsApi = {
  getAll: () => apiRequest('/notifications'),
  send: (data: any) =>
    apiRequest('/notifications', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
  markAsRead: (id: string) =>
    apiRequest(`/notifications/${id}/read`, { method: 'POST' }),
};

// Reports API
export const reportsApi = {
  generate: (type: string, params: any) =>
    apiRequest(`/reports/generate/${type}`, {
      method: 'POST',
      body: JSON.stringify(params),
    }),
  exportPdf: (reportId: string) => apiRequest(`/reports/${reportId}/pdf`),
  exportExcel: (reportId: string) => apiRequest(`/reports/${reportId}/excel`),
};

// Settings API
export const settingsApi = {
  getGymInfo: () => apiRequest('/settings/gym'),
  updateGymInfo: (data: any) =>
    apiRequest('/settings/gym', {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  getMembershipSettings: () => apiRequest('/settings/membership'),
  updateMembershipSettings: (data: any) =>
    apiRequest('/settings/membership', {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  updateProfile: (data: any) =>
    apiRequest('/settings/profile', {
      method: 'PUT',
      body: JSON.stringify(data),
    }),
  changePassword: (data: any) =>
    apiRequest('/settings/password', {
      method: 'POST',
      body: JSON.stringify(data),
    }),
};
