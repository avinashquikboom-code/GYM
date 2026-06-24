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
  return res.json();
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
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
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
          {plans.map((plan) => (
            <Card key={plan.id} className={`bg-[#1C1E22] border-[#2C3038] hover:border-[#7CE047]/30 transition-all duration-300 relative group overflow-hidden ${plan.popular ? 'border-[#7CE047]/50 shadow-lg shadow-[#7CE047]/5' : ''}`}>
              {plan.popular && (
                <div className="absolute top-3 right-3 bg-[#7CE047] text-[#0E0F12] text-[8px] font-extrabold uppercase px-2 py-0.5 rounded-full flex items-center gap-1">
                  <Star className="h-2 w-2 fill-current" /> Featured Choice
                </div>
              )}
              <CardHeader className="pt-6 pb-2">
                <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider text-white">{plan.name}</CardTitle>
                <CardDescription className="text-xs text-[#8E9297] font-mono">Plan ID: {plan.id}</CardDescription>
              </CardHeader>
              <CardContent className="space-y-6 pb-6">
                <div className="flex items-baseline gap-1 mt-2">
                  <span className="text-4xl font-heading font-extrabold text-[#7CE047]">₹{plan.price}</span>
                  <span className="text-xs text-[#8E9297] font-semibold uppercase">/ per {plan.duration}</span>
                </div>

                <ul className="space-y-2.5 text-xs text-[#8E9297] font-medium border-t border-[#2C3038]/50 pt-4 flex-grow">
                  {plan.features.map((feat: string, idx: number) => (
                    <li key={idx} className="flex items-center gap-2 text-white">
                      <Check className="h-4 w-4 text-[#7CE047] shrink-0" />
                      <span>{feat}</span>
                    </li>
                  ))}
                </ul>
              </CardContent>
              <CardFooter className="bg-[#17191d]/30 border-t border-[#2C3038]/50 py-3 flex gap-2">
                <Button 
                  variant="ghost" 
                  size="sm"
                  className="w-full text-xs font-bold uppercase tracking-wider text-white hover:bg-[#252930] rounded-xl"
                  onClick={() => togglePopularMutation.mutate(plan.id)}
                >
                  {plan.popular ? 'Unfeature' : 'Feature Tier'}
                </Button>
                <Button 
                  variant="ghost" 
                  size="icon"
                  className="text-[#FF5252] hover:bg-[#FF5252]/10 rounded-xl shrink-0"
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
