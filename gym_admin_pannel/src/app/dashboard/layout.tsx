'use client';

import React, { useEffect, useState } from 'react';
import { useAuth } from '@/context/auth-context';
import { useRouter, usePathname } from 'next/navigation';
import Link from 'next/link';
import { 
  LayoutDashboard, Users, Award, CreditCard, Dumbbell, Apple, 
  CalendarDays, DollarSign, Activity, Bell, BarChart3, Settings, 
  LogOut, Menu, ChevronLeft, ChevronRight, CheckCircle2, AlertCircle
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Sheet, SheetContent, SheetTrigger } from '@/components/ui/sheet';
import { ScrollArea } from '@/components/ui/scroll-area';
import { Popover, PopoverContent, PopoverTrigger } from '@/components/ui/popover';
import { Badge } from '@/components/ui/badge';
import { toast } from 'sonner';

// Define layout links mapping
const sidebarItems = [
  { label: 'Dashboard', path: '/dashboard', icon: LayoutDashboard },
  { label: 'Members', path: '/dashboard/members', icon: Users },
  { label: 'Trainers', path: '/dashboard/trainers', icon: Award },
  { label: 'Membership Plans', path: '/dashboard/plans', icon: CreditCard },
  { label: 'Workout Plans', path: '/dashboard/workouts', icon: Dumbbell },
  { label: 'Diet Plans', path: '/dashboard/diets', icon: Apple },
  { label: 'Attendance', path: '/dashboard/attendance', icon: CalendarDays },
  { label: 'Payments', path: '/dashboard/payments', icon: DollarSign },
  { label: 'Body Transformations', path: '/dashboard/transformations', icon: Activity },
  { label: 'Notifications', path: '/dashboard/notifications', icon: Bell },
  { label: 'Reports', path: '/dashboard/reports', icon: BarChart3 },
  { label: 'Settings', path: '/dashboard/settings', icon: Settings },
];

export default function DashboardLayout({ children }: { children: React.ReactNode }) {
  const { user, loading, logout } = useAuth();
  const router = useRouter();
  const pathname = usePathname();
  
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const [todayDate, setTodayDate] = useState('');
  const [mockNotifications, setMockNotifications] = useState([
    { id: '1', title: 'Plan Expiring Soon', desc: 'Jordan Belfort is expiring in 3 days.', unread: true, time: '10m ago' },
    { id: '2', title: 'Scan Error Logged', desc: 'Clara Oswald gate scan access denied.', unread: true, time: '1h ago' },
    { id: '3', title: 'New Trainer Registered', desc: 'Sarah Jenkins certs approved.', unread: false, time: 'Yesterday' }
  ]);

  // Auth Guard protection
  useEffect(() => {
    if (!loading && !user) {
      router.push('/');
    }
  }, [user, loading, router]);

  // Set today's date formatted
  useEffect(() => {
    const now = new Date();
    const options: Intl.DateTimeFormatOptions = { weekday: 'long', day: 'numeric', month: 'long' };
    setTodayDate(now.toLocaleDateString('en-US', options));
  }, []);

  if (loading || !user) {
    return (
      <div className="flex h-screen w-screen items-center justify-center bg-[#0E0F12] text-white">
        <div className="flex flex-col items-center gap-3">
          <Dumbbell className="h-10 w-10 text-[#7CE047] animate-spin" />
          <span className="text-sm font-semibold tracking-wider uppercase text-[#8E9297]">Loading Session...</span>
        </div>
      </div>
    );
  }

  const unreadCount = mockNotifications.filter(n => n.unread).length;

  const markAllRead = () => {
    setMockNotifications(mockNotifications.map(n => ({ ...n, unread: false })));
    toast.success('Marked all notifications as read');
  };

  const SidebarContent = () => (
    <div className="flex flex-col h-full bg-[#1C1E22] border-r border-[#2C3038]">
      {/* Brand Header */}
      <div className="flex items-center gap-3 h-20 px-6 border-b border-[#2C3038] shrink-0">
        <div className="flex items-center justify-center w-10 h-10 rounded-xl bg-[#252930] border border-[#2C3038] shadow-inner shrink-0">
          <Dumbbell className="h-5 w-5 text-[#7CE047]" />
        </div>
        {!isCollapsed && (
          <div className="flex flex-col">
            <h1 className="font-heading text-lg font-bold tracking-wider uppercase leading-none">
              GYM <span className="text-[#7CE047]">ADMIN</span>
            </h1>
            <span className="text-[10px] font-semibold text-[#8E9297] uppercase tracking-wider mt-0.5">Control Center</span>
          </div>
        )}
      </div>

      {/* Nav Menu Links */}
      <ScrollArea className="flex-grow py-6 px-4">
        <nav className="space-y-1.5">
          {sidebarItems.map((item) => {
            const isActive = pathname === item.path || pathname?.startsWith(item.path + '/');
            const Icon = item.icon;
            
            return (
              <Link key={item.path} href={item.path}>
                <button
                  className={`w-full flex items-center gap-4 px-4 py-3 rounded-xl transition-all duration-200 group text-left ${
                    isActive 
                      ? 'bg-[#7CE047]/10 text-[#7CE047] font-semibold border-l-2 border-[#7CE047] pl-3.5' 
                      : 'text-[#8E9297] hover:text-white hover:bg-[#252930]'
                  }`}
                  onClick={() => setIsMobileOpen(false)}
                >
                  <Icon className={`h-5 w-5 shrink-0 ${isActive ? 'text-[#7CE047]' : 'text-[#8E9297] group-hover:text-white'}`} />
                  {!isCollapsed && <span className="text-sm font-medium tracking-wide">{item.label}</span>}
                </button>
              </Link>
            );
          })}
        </nav>
      </ScrollArea>

      {/* Profile summary footer */}
      <div className="p-4 border-t border-[#2C3038] shrink-0 bg-[#17191d]/40">
        {!isCollapsed ? (
          <div className="flex items-center gap-3">
            <Avatar className="h-10 w-10 border border-[#2C3038]">
              <AvatarImage src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=80&auto=format&fit=crop" />
              <AvatarFallback>AM</AvatarFallback>
            </Avatar>
            <div className="flex flex-col min-w-0 flex-1">
              <span className="text-sm font-bold truncate text-white leading-tight">{user.name}</span>
              <span className="text-[10px] font-semibold text-[#8E9297] uppercase tracking-wider">{user.role}</span>
            </div>
            <Button variant="ghost" size="icon" className="text-[#8E9297] hover:text-[#FF5252] hover:bg-[#FF5252]/10 rounded-xl" onClick={logout} title="Logout">
              <LogOut className="h-5 w-5" />
            </Button>
          </div>
        ) : (
          <div className="flex flex-col items-center gap-3 py-2">
            <Avatar className="h-9 w-9 border border-[#2C3038]">
              <AvatarImage src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=80&auto=format&fit=crop" />
              <AvatarFallback>AM</AvatarFallback>
            </Avatar>
            <Button variant="ghost" size="icon" className="text-[#8E9297] hover:text-[#FF5252] hover:bg-[#FF5252]/10 rounded-xl" onClick={logout}>
              <LogOut className="h-5 w-5" />
            </Button>
          </div>
        )}
      </div>
    </div>
  );

  return (
    <div className="flex h-screen w-screen bg-[#0E0F12] text-white overflow-hidden font-sans">
      
      {/* Desktop Sidebar (hidden on mobile/tablet) */}
      <aside className={`hidden md:block transition-all duration-300 ${isCollapsed ? 'w-20' : 'w-[280px]'} h-full shrink-0`}>
        <SidebarContent />
      </aside>

      {/* Main Container Area */}
      <div className="flex flex-col flex-1 h-full min-w-0">
        
        {/* Top Navbar */}
        <header className="h-20 bg-[#0E0F12]/80 backdrop-blur-md border-b border-[#2C3038] flex items-center justify-between px-6 shrink-0 z-20">
          <div className="flex items-center gap-4">
            
            {/* Sidebar toggle button (desktop) */}
            <Button
              variant="ghost"
              size="icon"
              className="hidden md:flex text-[#8E9297] hover:text-white hover:bg-[#252930] rounded-xl"
              onClick={() => setIsCollapsed(!isCollapsed)}
            >
              {isCollapsed ? <ChevronRight className="h-5 w-5" /> : <ChevronLeft className="h-5 w-5" />}
            </Button>

            {/* Hamburger sheet drawer trigger (mobile) */}
            <Sheet open={isMobileOpen} onOpenChange={setIsMobileOpen}>
              <SheetTrigger asChild>
                <Button
                  variant="ghost"
                  size="icon"
                  className="md:hidden text-[#8E9297] hover:text-white hover:bg-[#252930] rounded-xl"
                >
                  <Menu className="h-5 w-5" />
                </Button>
              </SheetTrigger>
              <SheetContent side="left" className="p-0 border-none w-[280px]">
                <SidebarContent />
              </SheetContent>
            </Sheet>

            {/* Page Module Title Breadcrumb */}
            <div className="flex flex-col">
              <span className="text-xs font-semibold text-[#8E9297] uppercase tracking-widest">GYM HUB</span>
              <h2 className="text-base font-bold tracking-wide capitalize text-white mt-0.5">
                {pathname?.split('/').pop() || 'Dashboard'}
              </h2>
            </div>
          </div>

          <div className="flex items-center gap-4">
            {/* Date Badge */}
            <span className="hidden sm:inline-flex items-center bg-[#1C1E22] border border-[#2C3038] text-xs font-semibold text-[#8E9297] px-4 py-2 rounded-xl">
              {todayDate}
            </span>

            {/* Alert Notifications Center Bell */}
            <Popover>
              <PopoverTrigger asChild>
                <Button variant="ghost" size="icon" className="relative text-[#8E9297] hover:text-white hover:bg-[#252930] rounded-xl">
                  <Bell className="h-5 w-5" />
                  {unreadCount > 0 && (
                    <span className="absolute top-1.5 right-1.5 flex h-2 w-2 rounded-full bg-[#7CE047]" />
                  )}
                </Button>
              </PopoverTrigger>
              <PopoverContent className="w-80 bg-[#1C1E22] border-[#2C3038] text-white p-4 shadow-xl rounded-2xl mr-2">
                <div className="flex items-center justify-between pb-3 border-b border-[#2C3038] mb-3">
                  <span className="text-xs font-bold uppercase tracking-wider text-[#8E9297]">
                    Notifications ({unreadCount})
                  </span>
                  {unreadCount > 0 && (
                    <button className="text-[10px] font-bold text-[#7CE047] hover:underline" onClick={markAllRead}>
                      Mark all read
                    </button>
                  )}
                </div>
                <div className="space-y-3 max-h-60 overflow-y-auto pr-1">
                  {mockNotifications.length === 0 ? (
                    <p className="text-xs text-[#8E9297] text-center py-4">No notifications</p>
                  ) : (
                    mockNotifications.map(notif => (
                      <div key={notif.id} className={`flex items-start gap-2.5 p-2 rounded-lg transition ${notif.unread ? 'bg-[#7CE047]/5' : ''}`}>
                        {notif.title.includes('Error') || notif.title.includes('Deny') ? (
                          <AlertCircle className="h-4 w-4 text-[#FF5252] shrink-0 mt-0.5" />
                        ) : (
                          <CheckCircle2 className="h-4 w-4 text-[#7CE047] shrink-0 mt-0.5" />
                        )}
                        <div className="flex flex-col min-w-0">
                          <span className="text-xs font-bold text-white leading-tight">{notif.title}</span>
                          <span className="text-[10px] text-[#8E9297] mt-0.5 leading-normal">{notif.desc}</span>
                          <span className="text-[8px] text-[#8E9297]/50 mt-1 font-semibold">{notif.time}</span>
                        </div>
                      </div>
                    ))
                  )}
                </div>
              </PopoverContent>
            </Popover>

            {/* Quick Profile Summary Dropdown link */}
            <div className="flex items-center gap-2 border-l border-[#2C3038] pl-4">
              <Avatar className="h-9 w-9 border border-[#2C3038]">
                <AvatarImage src="https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=80&auto=format&fit=crop" />
                <AvatarFallback>AM</AvatarFallback>
              </Avatar>
              <div className="hidden lg:flex flex-col text-left">
                <span className="text-xs font-bold leading-none text-white">{user.name}</span>
                <span className="text-[9px] font-semibold text-[#8E9297] uppercase tracking-wider mt-0.5">{user.role}</span>
              </div>
            </div>
          </div>
        </header>

        {/* Dynamic Content Panel Scroll area */}
        <main className="flex-1 overflow-y-auto bg-[#0E0F12] relative">
          {children}
        </main>
      </div>
    </div>
  );
}
