'use client';

import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { 
  CreditCard, Plus, Check, Star, Trash2, Loader2, Sparkles, AlertCircle 
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { toast } from 'sonner';

const planFormSchema = z.object({
  name: z.string().min(2, 'Tier Name must be at least 2 characters'),
  price: z.string().min(1, 'Please enter pricing'),
  duration: z.enum(['month', 'quarter', 'year']),
  features: z.string().min(2, 'Please list features separated by commas'),
});

type PlanFormInputs = z.infer<typeof planFormSchema>;

const fetchPlans = async () => {
  const res = await fetch('/api/plans');
  if (!res.ok) throw new Error('Failed to load plans');
  const data = await res.json();
  // Return dummy data if API is empty
  if (data.length === 0) {
    return [
      {
        id: 'PLAN-BASIC',
        name: 'Basic',
        price: 999,
        duration: 'month',
        features: ['Gym Access', 'Basic Equipment', 'Locker Room', 'Parking'],
        popular: false
      },
      {
        id: 'PLAN-PRO',
        name: 'Pro',
        price: 1999,
        duration: 'month',
        features: ['All Basic Features', 'Personal Trainer (2 sessions)', 'Group Classes', 'Nutrition Plan', 'Sauna Access'],
        popular: true
      },
      {
        id: 'PLAN-ELITE',
        name: 'Elite',
        price: 3499,
        duration: 'month',
        features: ['All Pro Features', 'Unlimited Personal Training', 'Private Locker', 'Massage Therapy', 'Supplements Discount', 'Priority Booking'],
        popular: false
      }
    ];
  }
  return data;
};

export default function PlansPage() {
  const queryClient = useQueryClient();
  const [isOpen, setIsOpen] = useState(false);

  const { data: plans = [], isLoading } = useQuery<any[]>({
    queryKey: ['plans'],
    queryFn: fetchPlans
  });

  const { register, handleSubmit, reset, formState: { errors } } = useForm<PlanFormInputs>({
    resolver: zodResolver(planFormSchema)
  });

  const createMutation = useMutation({
    mutationFn: async (data: PlanFormInputs) => {
      const res = await fetch('/api/plans', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      if (!res.ok) throw new Error('Failed to create plan');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['plans'] });
      toast.success('Membership tier configured successfully');
      reset();
      setIsOpen(false);
    }
  });

  const togglePopularMutation = useMutation({
    mutationFn: async (id: string) => {
      const res = await fetch(`/api/plans/${id}`, { method: 'PATCH' });
      if (!res.ok) throw new Error('Failed to update popular tag');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['plans'] });
      toast.success('Feature status toggled!');
    }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => {
      const res = await fetch(`/api/plans/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Deletion failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['plans'] });
      toast.success('Membership plan deleted');
    }
  });

  return (
    <div className="p-6 md:p-8 space-y-6 bg-background min-h-full">
      {/* Header and trigger */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            MEMBERSHIP <span className="text-[#7CE047]">TIERS</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Configure billing packages, prices, renewal frequencies, and benefits templates.
          </p>
        </div>

        <Dialog open={isOpen} onOpenChange={setIsOpen}>
          <DialogTrigger className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold text-xs uppercase tracking-wider rounded-xl gap-2 px-5 h-11 inline-flex shrink-0 items-center justify-center border border-transparent">
            <Plus className="h-4 w-4" /> Add New Tier
          </DialogTrigger>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-md">
            <DialogHeader>
              <DialogTitle className="font-heading text-xl font-bold tracking-wide uppercase text-white">Create Membership Plan</DialogTitle>
              <DialogDescription className="text-xs text-[#8E9297]">Configure features and pricing options.</DialogDescription>
            </DialogHeader>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))} className="space-y-4 pt-4">
              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Tier Name</Label>
                <Input {...register('name')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. Platinum Premium" />
                {errors.name && <p className="text-[10px] text-red-500">{errors.name.message}</p>}
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Price (₹)</Label>
                  <Input {...register('price')} type="number" className="bg-[#252930] border-[#2C3038]" placeholder="e.g. 59" />
                  {errors.price && <p className="text-[10px] text-red-500">{errors.price.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Duration</Label>
                  <select {...register('duration')} className="w-full h-[40px] bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none">
                    <option value="month">Monthly</option>
                    <option value="quarter">Quarterly</option>
                    <option value="year">Yearly</option>
                  </select>
                </div>
              </div>

              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Package Features</Label>
                <Input {...register('features')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. 24/7 Access, Free Trainer Session" />
                {errors.features && <p className="text-[10px] text-red-500">{errors.features.message}</p>}
              </div>

              <DialogFooter className="pt-4 border-t border-[#2C3038]">
                <Button type="button" variant="ghost" onClick={() => setIsOpen(false)} className="text-[#8E9297] rounded-xl">Cancel</Button>
                <Button type="submit" disabled={createMutation.isPending} className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] rounded-xl font-bold uppercase text-xs">
                  {createMutation.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />} Create Tier
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
          {plans.map((plan, index) => (
            <Card 
              key={plan.id} 
              className={`relative overflow-hidden transition-all duration-500 hover:scale-105 hover:shadow-2xl ${
                plan.popular 
                  ? 'bg-gradient-to-br from-[#7CE047]/20 to-[#1C1E22] border-[#7CE047] shadow-[#7CE047]/20' 
                  : index === 0 
                    ? 'bg-gradient-to-br from-[#2196F3]/10 to-[#1C1E22] border-[#2196F3]/30' 
                    : 'bg-gradient-to-br from-[#9C27B0]/10 to-[#1C1E22] border-[#9C27B0]/30'
              } border-2`}
            >
              {plan.popular && (
                <div className="absolute top-0 right-0 bg-[#7CE047] text-[#0E0F12] text-[10px] font-extrabold uppercase px-3 py-1 rounded-bl-xl flex items-center gap-1 animate-pulse">
                  <Star className="h-3 w-3 fill-current" /> Most Popular
                </div>
              )}
              
              <CardHeader className="pt-8 pb-4">
                <div className="flex items-center gap-3 mb-2">
                  <div className={`w-12 h-12 rounded-xl flex items-center justify-center ${
                    plan.popular 
                      ? 'bg-[#7CE047] text-[#0E0F12]' 
                      : index === 0 
                        ? 'bg-[#2196F3] text-white' 
                        : 'bg-[#9C27B0] text-white'
                  }`}>
                    <CreditCard className="h-6 w-6" />
                  </div>
                  <div>
                    <CardTitle className={`font-heading text-xl font-bold uppercase tracking-wider ${
                      plan.popular ? 'text-[#7CE047]' : 'text-white'
                    }`}>{plan.name}</CardTitle>
                    <CardDescription className="text-[10px] text-[#8E9297] font-mono">{plan.id}</CardDescription>
                  </div>
                </div>
              </CardHeader>
              
              <CardContent className="space-y-6 pb-6">
                <div className="relative">
                  <div className="flex items-baseline gap-1">
                    <span className={`text-5xl font-heading font-extrabold ${
                      plan.popular 
                        ? 'text-[#7CE047]' 
                        : index === 0 
                          ? 'text-[#2196F3]' 
                          : 'text-[#9C27B0]'
                    }`}>₹{plan.price}</span>
                    <span className="text-sm text-[#8E9297] font-semibold uppercase">/{plan.duration}</span>
                  </div>
                  <div className="h-1 w-full bg-[#2C3038] rounded-full mt-2 overflow-hidden">
                    <div 
                      className={`h-full rounded-full ${
                        plan.popular 
                          ? 'bg-[#7CE047]' 
                          : index === 0 
                            ? 'bg-[#2196F3]' 
                            : 'bg-[#9C27B0]'
                      }`} 
                      style={{ width: `${(plan.price / 3499) * 100}%` }}
                    />
                  </div>
                </div>

                <ul className="space-y-3 text-sm">
                  {plan.features.map((feat: string, idx: number) => (
                    <li key={idx} className="flex items-center gap-3 text-white group">
                      <div className={`w-6 h-6 rounded-lg flex items-center justify-center shrink-0 ${
                        plan.popular 
                          ? 'bg-[#7CE047]/20 text-[#7CE047]' 
                          : index === 0 
                            ? 'bg-[#2196F3]/20 text-[#2196F3]' 
                            : 'bg-[#9C27B0]/20 text-[#9C27B0]'
                      } group-hover:scale-110 transition-transform`}>
                        <Check className="h-3.5 w-3.5" />
                      </div>
                      <span className="group-hover:translate-x-1 transition-transform">{feat}</span>
                    </li>
                  ))}
                </ul>
              </CardContent>
              
              <CardFooter className={`bg-gradient-to-t ${
                plan.popular 
                  ? 'from-[#7CE047]/10' 
                  : index === 0 
                    ? 'from-[#2196F3]/10' 
                    : 'from-[#9C27B0]/10'
              } border-t border-[#2C3038]/50 py-4 flex gap-2`}>
                <Button 
                  variant="ghost" 
                  size="sm"
                  className={`flex-1 text-xs font-bold uppercase tracking-wider rounded-xl transition-all hover:scale-105 ${
                    plan.popular 
                      ? 'text-[#7CE047] hover:bg-[#7CE047]/20' 
                      : index === 0 
                        ? 'text-[#2196F3] hover:bg-[#2196F3]/20' 
                        : 'text-[#9C27B0] hover:bg-[#9C27B0]/20'
                  }`}
                  onClick={() => togglePopularMutation.mutate(plan.id)}
                >
                  {plan.popular ? 'Unfeature' : 'Feature'}
                </Button>
                <Button 
                  variant="ghost" 
                  size="icon"
                  className="text-[#FF5252] hover:bg-[#FF5252]/10 rounded-xl shrink-0 hover:scale-110 transition-all"
                  onClick={() => {
                    if (confirm(`Delete plan ${plan.name}?`)) {
                      deleteMutation.mutate(plan.id);
                    }
                  }}
                >
                  <Trash2 className="h-4.5 w-4.5" />
                </Button>
              </CardFooter>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
