'use client';

import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { 
  Award, Star, Mail, Phone, Calendar, Briefcase, Plus, Edit2, 
  Trash2, X, Users, Loader2, Sparkles, AlertCircle, CheckCircle2, UserMinus, Search
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { toast } from 'sonner';

const trainerFormSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters'),
  email: z.string().email('Please enter a valid email address'),
  mobile: z.string().min(8, 'Please enter a valid phone number'),
  experience: z.string().min(1, 'Please enter years of experience'),
  certifications: z.string().min(2, 'Please list certifications separated by commas'),
});

type TrainerFormInputs = z.infer<typeof trainerFormSchema>;

const fetchTrainers = async () => {
  const res = await fetch('/api/trainers');
  if (!res.ok) throw new Error('Failed to load trainers');
  const data = await res.json();
  // Return dummy data if API is empty
  if (data.length === 0) {
    return [
      {
        id: 'TRN-001',
        name: 'Sarah Johnson',
        email: 'sarah.j@gym.com',
        mobile: '+91 98765 43210',
        experience: 5,
        certifications: 'CPT, Yoga Instructor, CrossFit Level 2',
        rating: 4.8,
        status: 'active',
        avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150&auto=format&fit=crop'
      },
      {
        id: 'TRN-002',
        name: 'Michael Chen',
        email: 'michael.chen@gym.com',
        mobile: '+91 98765 43211',
        experience: 8,
        certifications: 'CSCS, Nutrition Specialist, Strength Coach',
        rating: 4.9,
        status: 'active',
        avatarUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&auto=format&fit=crop'
      },
      {
        id: 'TRN-003',
        name: 'Emma Rodriguez',
        email: 'emma.r@gym.com',
        mobile: '+91 98765 43212',
        experience: 4,
        certifications: 'Pilates Instructor, Zumba, Personal Training',
        rating: 4.7,
        status: 'active',
        avatarUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&auto=format&fit=crop'
      }
    ];
  }
  return data;
};

const fetchMembers = async () => {
  const res = await fetch('/api/members');
  if (!res.ok) throw new Error('Failed to load members');
  return res.json();
};

export default function TrainersPage() {
  const queryClient = useQueryClient();
  
  // Modal states
  const [isAddOpen, setIsAddOpen] = useState(false);
  const [isProfileOpen, setIsProfileOpen] = useState(false);
  const [isAssignOpen, setIsAssignOpen] = useState(false);
  const [selectedTrainer, setSelectedTrainer] = useState<any | null>(null);
  
  // Search state
  const [search, setSearch] = useState('');

  // Forms
  const { register: regAdd, handleSubmit: handleAddSubmit, reset: resetAdd, formState: { errors: errorsAdd } } = useForm<TrainerFormInputs>({
    resolver: zodResolver(trainerFormSchema)
  });

  // React Queries
  const { data: trainers = [], isLoading: loadingTrainers } = useQuery<any[]>({
    queryKey: ['trainers'],
    queryFn: fetchTrainers
  });

  const { data: members = [] } = useQuery<any[]>({
    queryKey: ['members'],
    queryFn: fetchMembers
  });

  // Mutations
  const addMutation = useMutation({
    mutationFn: async (data: TrainerFormInputs) => {
      const res = await fetch('/api/trainers', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      if (!res.ok) throw new Error('Failed to register trainer');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['trainers'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
      toast.success('Trainer Coach Registered Successfully!');
      resetAdd();
      setIsAddOpen(false);
    }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => {
      const res = await fetch(`/api/trainers/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Deletion failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['trainers'] });
      queryClient.invalidateQueries({ queryKey: ['members'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
      toast.success('Trainer removed successfully');
      setIsProfileOpen(false);
    }
  });

  const assignMemberMutation = useMutation({
    mutationFn: async ({ memberId, trainerId }: { memberId: string; trainerId: string }) => {
      const res = await fetch(`/api/members/${memberId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ trainerId })
      });
      if (!res.ok) throw new Error('Assignment failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['trainers'] });
      queryClient.invalidateQueries({ queryKey: ['members'] });
      toast.success('Member assigned to trainer!');
      setIsAssignOpen(false);
      // Refresh current profile modal view
      if (selectedTrainer) {
        const refreshed = trainers.find(t => t.id === selectedTrainer.id);
        setSelectedTrainer(refreshed);
      }
    }
  });

  const removeMemberMutation = useMutation({
    mutationFn: async (memberId: string) => {
      const res = await fetch(`/api/members/${memberId}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ trainerId: '' })
      });
      if (!res.ok) throw new Error('Unassignment failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['trainers'] });
      queryClient.invalidateQueries({ queryKey: ['members'] });
      toast.success('Member unassigned from trainer');
      if (selectedTrainer) {
        const refreshed = trainers.find(t => t.id === selectedTrainer.id);
        setSelectedTrainer(refreshed);
      }
    }
  });

  const viewTrainerProfile = (trainer: any) => {
    setSelectedTrainer(trainer);
    setIsProfileOpen(true);
  };

  const filteredTrainers = trainers.filter(t => 
    t.name.toLowerCase().includes(search.toLowerCase()) ||
    t.certifications.some((c: string) => c.toLowerCase().includes(search.toLowerCase()))
  );

  // Members who don't have a trainer assigned yet
  const unassignedMembers = members.filter(m => !m.trainerId);

  return (
    <div className="p-6 md:p-8 space-y-6 bg-background min-h-full">
      {/* Header block */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            PERSONAL <span className="text-[#7CE047]">TRAINERS</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Manage fitness certifications, experience credentials, ratings, and client assignments.
          </p>
        </div>

        {/* Register Dialog */}
        <Dialog open={isAddOpen} onOpenChange={setIsAddOpen}>
          <DialogTrigger className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold text-xs uppercase tracking-wider rounded-xl gap-2 px-5 h-11 inline-flex shrink-0 items-center justify-center border border-transparent">
            <Plus className="h-4 w-4" /> Register Coach
          </DialogTrigger>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-md">
            <DialogHeader>
              <DialogTitle className="font-heading text-xl font-bold tracking-wide uppercase text-white">
                Register Personal Trainer
              </DialogTitle>
              <DialogDescription className="text-xs text-[#8E9297]">
                Enter coach details. Certifications must be separated by commas.
              </DialogDescription>
            </DialogHeader>
            <form onSubmit={handleAddSubmit((data) => addMutation.mutate(data))} className="space-y-4 pt-4">
              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Trainer Name</Label>
                <Input {...regAdd('name')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. Coach Marcus" />
                {errorsAdd.name && <p className="text-[10px] text-red-500">{errorsAdd.name.message}</p>}
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Email Address</Label>
                  <Input {...regAdd('email')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. coach@gym.com" />
                  {errorsAdd.email && <p className="text-[10px] text-red-500">{errorsAdd.email.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Mobile Number</Label>
                  <Input {...regAdd('mobile')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. +1 555-0188" />
                  {errorsAdd.mobile && <p className="text-[10px] text-red-500">{errorsAdd.mobile.message}</p>}
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Experience (Years)</Label>
                  <Input {...regAdd('experience')} type="number" className="bg-[#252930] border-[#2C3038]" placeholder="e.g. 5" />
                  {errorsAdd.experience && <p className="text-[10px] text-red-500">{errorsAdd.experience.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Certifications</Label>
                  <Input {...regAdd('certifications')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. NASM-CPT, FMS" />
                  {errorsAdd.certifications && <p className="text-[10px] text-red-500">{errorsAdd.certifications.message}</p>}
                </div>
              </div>

              <DialogFooter className="pt-4 border-t border-[#2C3038]">
                <Button type="button" variant="ghost" onClick={() => setIsAddOpen(false)} className="text-[#8E9297] rounded-xl">Cancel</Button>
                <Button type="submit" disabled={addMutation.isPending} className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] rounded-xl font-bold uppercase text-xs">
                  {addMutation.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />} Save Trainer
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      {/* Search Filter Panel */}
      <div className="relative max-w-md">
        <Search className="absolute left-3 top-3 h-4 w-4 text-[#8E9297]" />
        <Input 
          value={search}
          onChange={(e) => setSearch(e.target.value)}
          placeholder="Search trainers by name or certifications..." 
          className="pl-9 bg-[#1C1E22] border-[#2C3038] placeholder:text-[#8E9297]/50 rounded-xl"
        />
      </div>

      {/* Grid of trainers */}
      {loadingTrainers ? (
        <div className="flex items-center justify-center py-20">
          <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {filteredTrainers.length === 0 ? (
            <p className="text-xs text-[#8E9297] text-center col-span-full py-12">No trainers registered matching active filters.</p>
          ) : (
            filteredTrainers.map((t) => {
              const assignedCount = members.filter(m => m.trainerId === t.id).length;
              return (
                <Card key={t.id} className="bg-[#1C1E22] border-[#2C3038] hover:border-[#7CE047]/30 transition-all duration-300 relative group overflow-hidden">
                  <div className="absolute top-0 left-0 right-0 h-[2px] bg-[#2C3038] group-hover:bg-[#7CE047] transition-all" />
                  <CardHeader className="flex flex-row items-center gap-4 pb-3 pt-6">
                    <Avatar className="h-14 w-14 border border-[#2C3038] group-hover:border-[#7CE047]/30 transition-all">
                      <AvatarImage src={t.avatarUrl} alt={t.name} />
                      <AvatarFallback>{t.name[0]}</AvatarFallback>
                    </Avatar>
                    <div className="space-y-1">
                      <h3 className="font-heading text-lg font-bold tracking-wide uppercase text-white">{t.name}</h3>
                      <div className="flex items-center gap-1.5 text-xs text-[#FFC107]">
                        <Star className="h-3.5 w-3.5 fill-current" />
                        <span className="font-bold">{t.rating}</span>
                        <span className="text-[#8E9297] text-[10px] font-semibold">({t.experience}y Exp)</span>
                      </div>
                    </div>
                  </CardHeader>
                  <CardContent className="space-y-3 pb-6">
                    <div className="flex flex-wrap gap-1">
                      {t.certifications.slice(0, 3).map((c: string, idx: number) => (
                        <Badge key={idx} variant="secondary" className="bg-[#252930] border border-[#2C3038] text-[9px] font-semibold text-[#8E9297] rounded-md px-1.5 py-0.5">
                          {c}
                        </Badge>
                      ))}
                    </div>
                    <div className="grid grid-cols-2 gap-4 border-t border-[#2C3038]/50 pt-3 text-center text-xs font-semibold text-[#8E9297]">
                      <div>
                        Assigned Roster
                        <strong className="block text-[#7CE047] text-base font-heading font-bold mt-1">{assignedCount} Members</strong>
                      </div>
                      <div>
                        Success Rate
                        <strong className="block text-white text-base font-heading font-bold mt-1">{t.successRate}%</strong>
                      </div>
                    </div>
                  </CardContent>
                  <CardFooter className="bg-[#17191d]/30 border-t border-[#2C3038]/50 py-3 flex gap-2">
                    <Button 
                      variant="ghost" 
                      className="w-full text-xs font-bold uppercase tracking-wider text-white hover:bg-[#252930] rounded-xl"
                      onClick={() => viewTrainerProfile(t)}
                    >
                      View Profile
                    </Button>
                  </CardFooter>
                </Card>
              );
            })
          )}
        </div>
      )}

      {/* Trainer Profile Details Modal */}
      {selectedTrainer && (
        <Dialog open={isProfileOpen} onOpenChange={setIsProfileOpen}>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-2xl max-h-[85vh] overflow-y-auto">
            <DialogHeader className="border-b border-[#2C3038] pb-4">
              <div className="flex items-center gap-4">
                <Avatar className="h-16 w-16 border border-[#2C3038]">
                  <AvatarImage src={selectedTrainer.avatarUrl} alt={selectedTrainer.name} />
                  <AvatarFallback>{selectedTrainer.name[0]}</AvatarFallback>
                </Avatar>
                <div>
                  <DialogTitle className="font-heading text-2xl font-bold uppercase tracking-wider text-white">{selectedTrainer.name}</DialogTitle>
                  <DialogDescription className="text-xs text-[#8E9297] flex items-center gap-2 mt-1">
                    <span>{selectedTrainer.email}</span> &bull; <span>{selectedTrainer.mobile}</span>
                  </DialogDescription>
                </div>
              </div>
            </DialogHeader>

            <div className="grid grid-cols-1 md:grid-cols-3 gap-6 py-6 border-b border-[#2C3038]">
              {/* Profile indicators */}
              <div className="bg-[#252930]/30 p-4 rounded-xl border border-[#2C3038] text-center space-y-1">
                <span className="block text-[10px] font-bold text-[#8E9297] uppercase">Coach Rating</span>
                <span className="text-2xl font-heading font-extrabold text-[#FFC107] flex items-center justify-center gap-1">
                  <Star className="h-5 w-5 fill-current" /> {selectedTrainer.rating}
                </span>
              </div>
              <div className="bg-[#252930]/30 p-4 rounded-xl border border-[#2C3038] text-center space-y-1">
                <span className="block text-[10px] font-bold text-[#8E9297] uppercase">Coach Attendance</span>
                <span className="text-2xl font-heading font-extrabold text-[#7CE047] block">{selectedTrainer.attendanceRate}%</span>
              </div>
              <div className="bg-[#252930]/30 p-4 rounded-xl border border-[#2C3038] text-center space-y-1">
                <span className="block text-[10px] font-bold text-[#8E9297] uppercase">Client Success Rate</span>
                <span className="text-2xl font-heading font-extrabold text-[#2196F3] block">{selectedTrainer.successRate}%</span>
              </div>
            </div>

            <div className="space-y-4 py-4">
              <h4 className="font-heading text-sm font-bold uppercase tracking-wider text-white">Certifications & Badges</h4>
              <div className="flex flex-wrap gap-2">
                {selectedTrainer.certifications.map((c: string, idx: number) => (
                  <Badge key={idx} className="bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30 rounded-xl px-3 py-1 font-semibold text-xs">
                    {c}
                  </Badge>
                ))}
              </div>
            </div>

            {/* Trainer client roster management */}
            <div className="space-y-4 pt-4">
              <div className="flex justify-between items-center">
                <h4 className="font-heading text-sm font-bold uppercase tracking-wider text-white">Assigned Members Roster</h4>
                <Button 
                  onClick={() => setIsAssignOpen(true)}
                  className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] text-xs font-bold uppercase tracking-wider px-3 h-8 rounded-lg"
                >
                  <Plus className="h-3.5 w-3.5 mr-1" /> Assign Client
                </Button>
              </div>

              {/* Members Table */}
              <div className="border border-[#2C3038] rounded-xl overflow-hidden bg-[#252930]/10">
                <table className="w-full text-left">
                  <thead>
                    <tr className="border-b border-[#2C3038] bg-[#252930]/20 text-[10px] font-bold text-[#8E9297] uppercase">
                      <th className="p-3">Client Info</th>
                      <th className="p-3">Plan</th>
                      <th className="p-3 text-right">Action</th>
                    </tr>
                  </thead>
                  <tbody className="text-xs">
                    {members.filter(m => m.trainerId === selectedTrainer.id).length === 0 ? (
                      <tr>
                        <td colSpan={3} className="p-6 text-center text-xs text-[#8E9297]">No members assigned to this trainer yet.</td>
                      </tr>
                    ) : (
                      members.filter(m => m.trainerId === selectedTrainer.id).map(m => (
                        <tr key={m.id} className="border-b border-[#2C3038] last:border-none">
                          <td className="p-3">
                            <div className="flex items-center gap-2">
                              <Avatar className="h-7 w-7 border border-[#2C3038]">
                                <AvatarImage src={m.avatarUrl} />
                                <AvatarFallback>{m.name[0]}</AvatarFallback>
                              </Avatar>
                              <span className="font-bold text-white">{m.name}</span>
                            </div>
                          </td>
                          <td className="p-3 text-[#8E9297]">{m.planId.replace('PLAN-', '')}</td>
                          <td className="p-3 text-right">
                            <Button 
                              variant="ghost" 
                              size="icon" 
                              onClick={() => removeMemberMutation.mutate(m.id)}
                              className="h-7 w-7 text-[#FF5252] hover:bg-[#FF5252]/10 rounded-lg"
                              title="Unassign Member"
                            >
                              <UserMinus className="h-4 w-4" />
                            </Button>
                          </td>
                        </tr>
                      ))
                    )}
                  </tbody>
                </table>
              </div>
            </div>

            <DialogFooter className="pt-6 border-t border-[#2C3038] mt-6 flex justify-between">
              <Button 
                type="button" 
                variant="ghost" 
                onClick={() => {
                  if (confirm(`Remove Personal Coach ${selectedTrainer.name}? This will unassign all their clients.`)) {
                    deleteMutation.mutate(selectedTrainer.id);
                  }
                }}
                className="text-[#FF5252] hover:bg-[#FF5252]/10 rounded-xl"
              >
                <Trash2 className="h-4 w-4 mr-2" /> Delete Trainer Profile
              </Button>
              <Button type="button" variant="ghost" onClick={() => setIsProfileOpen(false)} className="text-[#8E9297] rounded-xl">Close Profile</Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

      {/* Assign Client Modal Dialog */}
      {selectedTrainer && (
        <Dialog open={isAssignOpen} onOpenChange={setIsAssignOpen}>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-sm">
            <DialogHeader>
              <DialogTitle className="font-heading text-lg font-bold uppercase tracking-wider text-white">Assign Member Client</DialogTitle>
              <DialogDescription className="text-xs text-[#8E9297]">Select a client without an assigned coach.</DialogDescription>
            </DialogHeader>
            <div className="py-4 space-y-4">
              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Choose Client</Label>
                {unassignedMembers.length === 0 ? (
                  <p className="text-xs text-[#FF5252] font-semibold bg-red-500/5 p-3 rounded-lg border border-red-500/20">All gym members are currently assigned to trainers.</p>
                ) : (
                  <select 
                    id="assign-member-select"
                    className="w-full bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none"
                  >
                    {unassignedMembers.map(m => (
                      <option key={m.id} value={m.id}>{m.name} ({m.id})</option>
                    ))}
                  </select>
                )}
              </div>
            </div>
            <DialogFooter className="border-t border-[#2C3038] pt-4">
              <Button type="button" variant="ghost" onClick={() => setIsAssignOpen(false)} className="text-[#8E9297] rounded-xl">Cancel</Button>
              <Button 
                type="button" 
                disabled={unassignedMembers.length === 0}
                onClick={() => {
                  const selectEl = document.getElementById('assign-member-select') as HTMLSelectElement;
                  if (selectEl && selectEl.value) {
                    assignMemberMutation.mutate({ memberId: selectEl.value, trainerId: selectedTrainer.id });
                  }
                }}
                className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold uppercase text-xs rounded-xl"
              >
                Confirm Assignment
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      )}

    </div>
  );
}
