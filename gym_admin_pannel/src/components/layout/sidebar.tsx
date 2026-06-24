'use client';

import { useState } from 'react';
import Link from 'next/link';
import { usePathname } from 'next/navigation';
import { cn } from '@/lib/utils';
import { Button } from '@/components/ui/button';
import { ScrollArea } from '@/components/ui/scroll-area';
import {
  LayoutDashboard,
  Users,
  UserCog,
  CreditCard,
  Dumbbell,
  Apple,
  CalendarCheck,
  IndianRupee,
  Trophy,
  Bell,
  FileText,
  Settings,
  LogOut,
  ChevronLeft,
  ChevronRight,
  Menu,
} from 'lucide-react';
import { useAuth } from '@/context/auth-context';
import { motion } from 'framer-motion';

const menuItems = [
  { icon: LayoutDashboard, label: 'Dashboard', href: '/dashboard' },
  { icon: Users, label: 'Members', href: '/dashboard/members' },
  { icon: UserCog, label: 'Trainers', href: '/dashboard/trainers' },
  { icon: CreditCard, label: 'Membership Plans', href: '/dashboard/plans' },
  { icon: Dumbbell, label: 'Workout Plans', href: '/dashboard/workouts' },
  { icon: Apple, label: 'Diet Plans', href: '/dashboard/diets' },
  { icon: CalendarCheck, label: 'Attendance', href: '/dashboard/attendance' },
  { icon: IndianRupee, label: 'Payments', href: '/dashboard/payments' },
  { icon: Trophy, label: 'Transformations', href: '/dashboard/transformations' },
  { icon: Bell, label: 'Notifications', href: '/dashboard/notifications' },
  { icon: FileText, label: 'Reports', href: '/dashboard/reports' },
  { icon: Settings, label: 'Settings', href: '/dashboard/settings' },
];

export function Sidebar() {
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileOpen, setIsMobileOpen] = useState(false);
  const pathname = usePathname();
  const { logout, user } = useAuth();

  const toggleCollapse = () => setIsCollapsed(!isCollapsed);
  const toggleMobile = () => setIsMobileOpen(!isMobileOpen);

  return (
    <>
      {/* Mobile overlay */}
      {isMobileOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-40 lg:hidden"
          onClick={toggleMobile}
        />
      )}

      {/* Mobile menu button */}
      <Button
        variant="ghost"
        size="icon"
        className="lg:hidden fixed top-4 left-4 z-50 bg-card border-border"
        onClick={toggleMobile}
      >
        <Menu className="h-5 w-5" />
      </Button>

      {/* Sidebar */}
      <motion.aside
        initial={{ x: -300 }}
        animate={{ x: isMobileOpen ? 0 : -300 }}
        transition={{ type: 'spring', damping: 25 }}
        className={cn(
          'fixed left-0 top-0 z-50 h-screen bg-card border-r border-border transition-all duration-300 lg:translate-x-0 lg:static lg:z-0',
          isCollapsed ? 'lg:w-20' : 'lg:w-64',
          isMobileOpen ? 'w-64' : '-translate-x-full'
        )}
      >
        <div className="flex flex-col h-full">
          {/* Logo */}
          <div className="flex items-center justify-between p-4 border-b border-border">
            {!isCollapsed && (
              <motion.div
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                className="flex items-center gap-2"
              >
                <div className="w-10 h-10 bg-primary rounded-lg flex items-center justify-center glow-green-sm">
                  <Dumbbell className="w-6 h-6 text-background" />
                </div>
                <span className="font-bold text-lg text-foreground">Gym Admin</span>
              </motion.div>
            )}
            <Button
              variant="ghost"
              size="icon"
              onClick={toggleCollapse}
              className="hidden lg:flex ml-auto"
            >
              {isCollapsed ? (
                <ChevronRight className="h-4 w-4" />
              ) : (
                <ChevronLeft className="h-4 w-4" />
              )}
            </Button>
          </div>

          {/* Navigation */}
          <ScrollArea className="flex-1 p-4">
            <nav className="space-y-2">
              {menuItems.map((item) => {
                const Icon = item.icon;
                const isActive = pathname === item.href || pathname?.startsWith(item.href + '/');

                return (
                  <Link key={item.href} href={item.href} onClick={() => setIsMobileOpen(false)}>
                    <Button
                      variant={isActive ? 'secondary' : 'ghost'}
                      className={cn(
                        'w-full justify-start transition-all duration-200',
                        isActive && 'bg-primary text-background hover:bg-primary/90',
                        isCollapsed && 'lg:justify-center'
                      )}
                    >
                      <Icon className={cn('h-5 w-5', !isCollapsed && 'mr-3')} />
                      {!isCollapsed && <span className="font-medium">{item.label}</span>}
                    </Button>
                  </Link>
                );
              })}
            </nav>
          </ScrollArea>

          {/* User & Logout */}
          <div className="p-4 border-t border-border space-y-2">
            {!isCollapsed && (
              <div className="flex items-center gap-3 p-3 rounded-lg bg-muted/50">
                <div className="w-10 h-10 bg-primary rounded-full flex items-center justify-center">
                  <span className="text-background font-semibold">
                    {user?.name?.charAt(0) || 'A'}
                  </span>
                </div>
                <div className="flex-1 min-w-0">
                  <p className="text-sm font-medium text-foreground truncate">
                    {user?.name || 'Admin'}
                  </p>
                  <p className="text-xs text-muted-foreground truncate">
                    {user?.role || 'admin'}
                  </p>
                </div>
              </div>
            )}
            <Button
              variant="ghost"
              className={cn(
                'w-full justify-start text-destructive hover:text-destructive hover:bg-destructive/10',
                isCollapsed && 'lg:justify-center'
              )}
              onClick={logout}
            >
              <LogOut className={cn('h-5 w-5', !isCollapsed && 'mr-3')} />
              {!isCollapsed && <span className="font-medium">Logout</span>}
            </Button>
          </div>
        </div>
      </motion.aside>
    </>
  );
}
