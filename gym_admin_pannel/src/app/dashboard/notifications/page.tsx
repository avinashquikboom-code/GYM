'use client';

import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { 
  Bell, Send, Mail, Users, CheckCircle, Clock, 
  Trash2, Loader2, Sparkles, AlertCircle 
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Textarea } from '@/components/ui/textarea';
import { toast } from 'sonner';

const notificationFormSchema = z.object({
  target: z.string().min(1, 'Please select target channel'),
  type: z.enum(['Membership Renewal', 'Workout Reminder', 'Diet Reminder', 'Announcements']),
  message: z.string().min(5, 'Message must be at least 5 characters long'),
});

type NotificationInputs = z.infer<typeof notificationFormSchema>;

const fetchNotifications = async () => {
  const res = await fetch('/api/notifications');
  if (!res.ok) throw new Error('Failed to load notifications');
  return res.json();
};

const fetchMembers = async () => {
  const res = await fetch('/api/members');
  return res.json();
};

export default function NotificationsPage() {
  const queryClient = useQueryClient();

  const { data: notifications = [], isLoading } = useQuery<any[]>({
    queryKey: ['notifications'],
    queryFn: fetchNotifications
  });

  const { data: members = [] } = useQuery<any[]>({
    queryKey: ['members'],
    queryFn: fetchMembers
  });

  const { register, handleSubmit, reset, formState: { errors } } = useForm<NotificationInputs>({
    resolver: zodResolver(notificationFormSchema),
    defaultValues: {
      target: 'All Members',
      type: 'Announcements',
      message: ''
    }
  });

  const sendMutation = useMutation({
    mutationFn: async (data: NotificationInputs) => {
      const res = await fetch('/api/notifications', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      if (!res.ok) throw new Error('Failed to send notification');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['notifications'] });
      toast.success('Broadcast notification dispatched!');
      reset();
    }
  });

  return (
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
      {/* Header */}
      <div>
        <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
          NOTIFICATION <span className="text-[#7CE047]">CENTER</span>
        </h1>
        <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
          Dispatch push reminders, workout alerts, diet targets, and announcements to mobile clients.
        </p>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        {/* Send Broadcast form */}
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white lg:col-span-1 h-fit">
          <CardHeader>
            <CardTitle className="font-heading text-base font-bold uppercase tracking-wider">Send Notification</CardTitle>
            <CardDescription className="text-xs text-[#8E9297]">Compose template or custom alerts.</CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit((data) => sendMutation.mutate(data))} className="space-y-4">
              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Target Audience</Label>
                <select {...register('target')} className="w-full bg-[#252930] border border-[#2C3038] text-xs text-white rounded-md p-2.5 outline-none font-medium">
                  <option value="All Members">All Members (Broadcast)</option>
                  <option value="All Trainers">All Personal Trainers</option>
                  {members.map((m: any) => <option key={m.id} value={m.name}>{m.name} ({m.id})</option>)}
                </select>
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Notification Type</Label>
                <select {...register('type')} className="w-full bg-[#252930] border border-[#2C3038] text-xs text-white rounded-md p-2.5 outline-none font-medium">
                  <option value="Announcements">General Announcement</option>
                  <option value="Membership Renewal">Membership Renewal Notice</option>
                  <option value="Workout Reminder">Workout Card Reminder</option>
                  <option value="Diet Reminder">Diet Targets Card Reminder</option>
                </select>
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Message Content</Label>
                <textarea 
                  {...register('message')} 
                  rows={4} 
                  placeholder="Enter message details here..." 
                  className="w-full bg-[#252930] border border-[#2C3038] text-xs text-white rounded-md p-2.5 outline-none font-medium focus:border-[#7CE047] placeholder:text-[#8E9297]/40"
                />
                {errors.message && <p className="text-[10px] text-red-500">{errors.message.message}</p>}
              </div>

              <Button type="submit" disabled={sendMutation.isPending} className="w-full bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold uppercase text-xs rounded-xl h-11">
                {sendMutation.isPending ? <Loader2 className="h-4 w-4 animate-spin" /> : <Send className="h-4 w-4 mr-2" />} Dispatch Alert
              </Button>
            </form>
          </CardContent>
        </Card>

        {/* Dispatch Log lists */}
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white lg:col-span-2">
          <CardHeader>
            <CardTitle className="font-heading text-base font-bold uppercase tracking-wider">Sent Messages Log</CardTitle>
            <CardDescription className="text-xs text-[#8E9297]">View historically sent broadcast records.</CardDescription>
          </CardHeader>
          <CardContent>
            {isLoading ? (
              <div className="flex items-center justify-center py-20">
                <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
              </div>
            ) : notifications.length === 0 ? (
              <p className="text-xs text-[#8E9297] text-center py-12">No notifications have been dispatched yet.</p>
            ) : (
              <div className="space-y-4 max-h-[500px] overflow-y-auto pr-1">
                {notifications.map((notif) => (
                  <div key={notif.id} className="p-4 rounded-xl bg-[#252930]/30 border border-[#2C3038] flex items-start gap-4">
                    <div className="flex items-center justify-center w-8 h-8 rounded-lg bg-[#252930] border border-[#2C3038] text-[#7CE047] shrink-0">
                      <Bell className="h-4 w-4" />
                    </div>
                    <div className="space-y-1.5 flex-1 min-w-0">
                      <div className="flex justify-between items-center">
                        <span className="text-xs font-bold text-white">To: {notif.target}</span>
                        <span className="text-[9px] text-[#8E9297] font-semibold">{new Date(notif.sentAt).toLocaleTimeString('en-US', { hour: '2-digit', minute: '2-digit' })}</span>
                      </div>
                      <p className="text-xs text-white/90 leading-relaxed font-medium">{notif.message}</p>
                      <div className="flex gap-2">
                        <Badge className="bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30 text-[8px] uppercase tracking-wider font-bold rounded-lg px-2 py-0.5">
                          {notif.type}
                        </Badge>
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            )}
          </CardContent>
        </Card>

      </div>
    </div>
  );
}
