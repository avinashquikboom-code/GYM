'use client';

import React from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { 
  Settings, KeyRound, Building2, BellRing, ShieldCheck, 
  Loader2, Sparkles, CheckCircle2 
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { toast } from 'sonner';

const profileSchema = z.object({
  gymName: z.string().min(2, 'Gym Name required'),
  email: z.string().email('Please enter a valid email address'),
  mobile: z.string().min(8, 'Phone number required'),
  address: z.string().min(5, 'Address details required'),
});

const passwordSchema = z.object({
  currentPassword: z.string().min(6, 'Current Password required'),
  newPassword: z.string().min(6, 'New Password must be at least 6 characters'),
  confirmPassword: z.string().min(6, 'Confirmation required'),
}).refine(data => data.newPassword === data.confirmPassword, {
  message: "New passwords do not match",
  path: ["confirmPassword"]
});

type ProfileInputs = z.infer<typeof profileSchema>;
type PasswordInputs = z.infer<typeof passwordSchema>;

export default function SettingsPage() {
  
  const { register: regProfile, handleSubmit: handleProfileSubmit } = useForm<ProfileInputs>({
    defaultValues: {
      gymName: 'GYM - Executive Hub',
      email: 'hq@gym.com',
      mobile: '+1 555-0900',
      address: '100 Fitness Plaza, New York, NY'
    }
  });

  const { register: regPass, handleSubmit: handlePassSubmit, reset: resetPass, formState: { errors: errorsPass } } = useForm<PasswordInputs>({
    resolver: zodResolver(passwordSchema)
  });

  const onProfileSave = (data: ProfileInputs) => {
    toast.success('Gym configurations updated successfully!', {
      description: 'Changes will sync to Member & Trainer mobile apps shortly.',
    });
  };

  const onPasswordSave = (data: PasswordInputs) => {
    toast.success('Administrator security password changed');
    resetPass();
  };

  return (
    <div className="p-6 md:p-8 space-y-6 bg-background min-h-full">
      {/* Header */}
      <div>
        <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
          CONSOLE <span className="text-[#7CE047]">SETTINGS</span>
        </h1>
        <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
          Adjust central gym information, member preferences, gate access rules, and credentials.
        </p>
      </div>

      <Tabs defaultValue="gym-info" className="space-y-6">
        <TabsList className="bg-[#1C1E22] border border-[#2C3038] p-1 rounded-xl flex flex-wrap h-auto gap-1">
          <TabsTrigger value="gym-info" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <Building2 className="h-3.5 w-3.5 mr-1.5" /> Gym Information
          </TabsTrigger>
          <TabsTrigger value="security" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <KeyRound className="h-3.5 w-3.5 mr-1.5" /> Security & Passwords
          </TabsTrigger>
          <TabsTrigger value="preferences" className="rounded-lg py-2 px-4 text-xs font-semibold data-[state=active]:bg-[#7CE047] data-[state=active]:text-[#0E0F12]">
            <BellRing className="h-3.5 w-3.5 mr-1.5" /> Operations
          </TabsTrigger>
        </TabsList>

        {/* 1. GYM INFORMATION TAB */}
        <TabsContent value="gym-info">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white max-w-lg">
            <CardHeader>
              <CardTitle className="font-heading text-base font-bold uppercase tracking-wider text-white">General Parameters</CardTitle>
              <CardDescription className="text-xs text-[#8E9297]">Branding labels distributed to mobile applications.</CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleProfileSubmit(onProfileSave)} className="space-y-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Gym HQ Name</Label>
                  <Input {...regProfile('gymName')} className="bg-[#252930] border-[#2C3038]" />
                </div>
                <div className="grid grid-cols-2 gap-4">
                  <div className="space-y-1.5">
                    <Label className="text-xs text-[#8E9297]">Support Email</Label>
                    <Input {...regProfile('email')} className="bg-[#252930] border-[#2C3038]" />
                  </div>
                  <div className="space-y-1.5">
                    <Label className="text-xs text-[#8E9297]">Contact Phone</Label>
                    <Input {...regProfile('mobile')} className="bg-[#252930] border-[#2C3038]" />
                  </div>
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Physical Address</Label>
                  <Input {...regProfile('address')} className="bg-[#252930] border-[#2C3038]" />
                </div>
                <Button type="submit" className="w-full bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold uppercase text-xs rounded-xl h-11">
                  Save Gym Info
                </Button>
              </form>
            </CardContent>
          </Card>
        </TabsContent>

        {/* 2. SECURITY PASSWORD CHANGE */}
        <TabsContent value="security">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white max-w-lg">
            <CardHeader>
              <CardTitle className="font-heading text-base font-bold uppercase tracking-wider text-white">Change Credentials</CardTitle>
              <CardDescription className="text-xs text-[#8E9297]">Modify executive control panel login passphrase.</CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={handlePassSubmit(onPasswordSave)} className="space-y-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Current Password</Label>
                  <Input {...regPass('currentPassword')} type="password" className="bg-[#252930] border-[#2C3038]" />
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">New Password</Label>
                  <Input {...regPass('newPassword')} type="password" className="bg-[#252930] border-[#2C3038]" />
                  {errorsPass.newPassword && <p className="text-[10px] text-red-500">{errorsPass.newPassword.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Confirm New Password</Label>
                  <Input {...regPass('confirmPassword')} type="password" className="bg-[#252930] border-[#2C3038]" />
                  {errorsPass.confirmPassword && <p className="text-[10px] text-red-500">{errorsPass.confirmPassword.message}</p>}
                </div>
                <Button type="submit" className="w-full bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold uppercase text-xs rounded-xl h-11">
                  Update Password
                </Button>
              </form>
            </CardContent>
          </Card>
        </TabsContent>

        {/* 3. OPERATIONS SETTINGS */}
        <TabsContent value="preferences">
          <Card className="bg-[#1C1E22] border-[#2C3038] text-white max-w-lg">
            <CardHeader>
              <CardTitle className="font-heading text-base font-bold uppercase tracking-wider text-white">System Operations</CardTitle>
              <CardDescription className="text-xs text-[#8E9297]">Configure auto-renewals and gate scanners.</CardDescription>
            </CardHeader>
            <CardContent className="space-y-5 text-sm font-semibold">
              <div className="flex items-center justify-between p-3 rounded-xl bg-[#252930]/40 border border-[#2C3038]">
                <div className="space-y-0.5">
                  <span className="block text-xs font-bold text-white">Auto-billing Renewals</span>
                  <span className="text-[10px] text-[#8E9297] font-medium">Auto-renew billing logs on expiration.</span>
                </div>
                <input type="checkbox" defaultChecked className="w-4 h-4 accent-[#7CE047]" />
              </div>
              <div className="flex items-center justify-between p-3 rounded-xl bg-[#252930]/40 border border-[#2C3038]">
                <div className="space-y-0.5">
                  <span className="block text-xs font-bold text-white">Gate Scan Auto-suspensions</span>
                  <span className="text-[10px] text-[#8E9297] font-medium">Deny gate entry if plan is in suspended state.</span>
                </div>
                <input type="checkbox" defaultChecked className="w-4 h-4 accent-[#7CE047]" />
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
