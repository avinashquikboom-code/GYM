'use client';

import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { 
  Dumbbell, Plus, Trash2, CheckCircle2, Loader2, Sparkles, 
  Clock, Flame, ShieldAlert, Award, FileText, ChevronRight
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { toast } from 'sonner';

const exerciseSchema = z.object({
  name: z.string().min(2, 'Exercise name required'),
  sets: z.string().min(1, 'Sets count required'),
  reps: z.string().min(1, 'Reps range required'),
  restTime: z.string().min(1, 'Rest duration required'),
  notes: z.string().optional(),
});

const workoutFormSchema = z.object({
  name: z.string().min(2, 'Plan Name must be at least 2 characters'),
  category: z.enum(['Fat Loss', 'Muscle Gain', 'Strength', 'Cardio']),
  exercises: z.array(exerciseSchema).min(1, 'Please add at least 1 exercise'),
});

type WorkoutFormInputs = z.infer<typeof workoutFormSchema>;

const fetchWorkouts = async () => {
  const res = await fetch('/api/workouts');
  if (!res.ok) throw new Error('Failed to load workouts');
  return res.json();
};

export default function WorkoutsPage() {
  const queryClient = useQueryClient();
  const [isOpen, setIsOpen] = useState(false);
  const [activeCategory, setActiveCategory] = useState<string>('all');

  const { data: workouts = [], isLoading } = useQuery<any[]>({
    queryKey: ['workouts'],
    queryFn: fetchWorkouts
  });

  const { register, control, handleSubmit, reset, formState: { errors } } = useForm<WorkoutFormInputs>({
    resolver: zodResolver(workoutFormSchema),
    defaultValues: {
      name: '',
      category: 'Muscle Gain',
      exercises: [{ name: '', sets: '3', reps: '10', restTime: '60s', notes: '' }]
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'exercises'
  });

  const createMutation = useMutation({
    mutationFn: async (data: WorkoutFormInputs) => {
      // Map sets from string to number on post
      const formattedData = {
        ...data,
        exercises: data.exercises.map(ex => ({
          ...ex,
          sets: parseInt(ex.sets) || 3
        }))
      };
      
      const res = await fetch('/api/workouts', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formattedData)
      });
      if (!res.ok) throw new Error('Failed to create workout');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workouts'] });
      toast.success('Workout template created successfully');
      reset();
      setIsOpen(false);
    }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => {
      const res = await fetch(`/api/workouts/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Failed to delete workout');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['workouts'] });
      toast.success('Workout template deleted');
    }
  });

  const filteredWorkouts = activeCategory === 'all' 
    ? workouts 
    : workouts.filter(w => w.category === activeCategory);

  return (
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
      {/* Header and trigger */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            WORKOUT <span className="text-[#7CE047]">TEMPLATES</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Build and assign dynamic exercise templates categorized by training targets.
          </p>
        </div>

        <Dialog open={isOpen} onOpenChange={setIsOpen}>
          <DialogTrigger asChild>
            <Button className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold text-xs uppercase tracking-wider rounded-xl gap-2 px-5 h-11">
              <Plus className="h-4 w-4" /> Create Template
            </Button>
          </DialogTrigger>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-xl max-h-[80vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle className="font-heading text-xl font-bold tracking-wide uppercase text-white">Create Workout Plan</DialogTitle>
              <DialogDescription className="text-xs text-[#8E9297]">Assemble a list of movements, sets, and rest times.</DialogDescription>
            </DialogHeader>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))} className="space-y-4 pt-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Plan Name</Label>
                  <Input {...register('name')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. Hypertrophy Pull Day" />
                  {errors.name && <p className="text-[10px] text-red-500">{errors.name.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Category</Label>
                  <select {...register('category')} className="w-full h-[40px] bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none">
                    <option value="Muscle Gain">Muscle Gain</option>
                    <option value="Fat Loss">Fat Loss</option>
                    <option value="Strength">Strength</option>
                    <option value="Cardio">Cardio</option>
                  </select>
                </div>
              </div>

              {/* Dynamic exercises arrays list */}
              <div className="space-y-3 pt-3 border-t border-[#2C3038]/50">
                <div className="flex justify-between items-center">
                  <Label className="text-xs font-bold text-white uppercase tracking-wider">Exercise List ({fields.length})</Label>
                  <Button 
                    type="button" 
                    variant="outline" 
                    size="sm"
                    className="bg-[#252930] border-[#2C3038] hover:bg-[#2C3038] text-[10px] rounded-lg h-7"
                    onClick={() => append({ name: '', sets: '3', reps: '10', restTime: '60s', notes: '' })}
                  >
                    Add Row
                  </Button>
                </div>

                <div className="space-y-3">
                  {fields.map((field, idx) => (
                    <div key={field.id} className="p-3 rounded-lg border border-[#2C3038] bg-[#252930]/30 space-y-3 relative">
                      <div className="grid grid-cols-3 gap-2">
                        <div className="col-span-2 space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Exercise Name</Label>
                          <Input {...register(`exercises.${idx}.name` as const)} className="bg-[#252930] border-[#2C3038] h-8 text-xs" placeholder="e.g. Lat Pulldown" />
                        </div>
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Sets</Label>
                          <Input {...register(`exercises.${idx}.sets` as const)} type="number" className="bg-[#252930] border-[#2C3038] h-8 text-xs" />
                        </div>
                      </div>

                      <div className="grid grid-cols-3 gap-2">
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Reps</Label>
                          <Input {...register(`exercises.${idx}.reps` as const)} className="bg-[#252930] border-[#2C3038] h-8 text-xs" placeholder="8-12" />
                        </div>
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Rest Time</Label>
                          <Input {...register(`exercises.${idx}.restTime` as const)} className="bg-[#252930] border-[#2C3038] h-8 text-xs" placeholder="90s" />
                        </div>
                        <div className="flex items-end justify-end pb-0.5">
                          <Button 
                            type="button" 
                            disabled={fields.length === 1}
                            onClick={() => remove(idx)}
                            className="bg-red-500/10 text-red-500 hover:bg-red-500/20 border border-red-500/30 h-8 rounded-lg text-xs"
                          >
                            Remove
                          </Button>
                        </div>
                      </div>
                    </div>
                  ))}
                </div>
              </div>

              <DialogFooter className="pt-4 border-t border-[#2C3038]">
                <Button type="button" variant="ghost" onClick={() => setIsOpen(false)} className="text-[#8E9297] rounded-xl">Cancel</Button>
                <Button type="submit" disabled={createMutation.isPending} className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] rounded-xl font-bold uppercase text-xs">
                  {createMutation.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />} Save Template
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      {/* Category filter toggles */}
      <div className="flex flex-wrap gap-2">
        {['all', 'Muscle Gain', 'Fat Loss', 'Strength', 'Cardio'].map((cat) => (
          <Button 
            key={cat}
            variant={activeCategory === cat ? 'default' : 'outline'}
            onClick={() => setActiveCategory(cat)}
            className={`rounded-xl text-xs px-4 h-9 font-semibold ${
              activeCategory === cat 
                ? 'bg-[#7CE047] text-[#0E0F12] hover:bg-[#6bd039]' 
                : 'bg-[#1C1E22] border-[#2C3038] text-[#8E9297] hover:text-white'
            }`}
          >
            {cat === 'all' ? 'All Workouts' : cat}
          </Button>
        ))}
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {filteredWorkouts.map((workout) => (
            <Card key={workout.id} className="bg-[#1C1E22] border-[#2C3038] text-white hover:border-[#7CE047]/30 transition-all duration-300 relative group overflow-hidden flex flex-col justify-between">
              <div className="absolute top-0 left-0 right-0 h-[2px] bg-[#2C3038] group-hover:bg-[#7CE047] transition-all" />
              <CardHeader className="flex flex-row justify-between items-start pt-6 pb-2">
                <div className="space-y-1">
                  <Badge className="bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30 rounded-xl text-[9px] uppercase font-bold px-2 py-0.5">
                    {workout.category}
                  </Badge>
                  <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider text-white pt-1">{workout.name}</CardTitle>
                </div>
                <Button 
                  variant="ghost" 
                  size="icon"
                  className="text-[#FF5252] hover:bg-[#FF5252]/10 rounded-xl shrink-0"
                  onClick={() => {
                    if (confirm(`Delete plan ${workout.name}?`)) {
                      deleteMutation.mutate(workout.id);
                    }
                  }}
                >
                  <Trash2 className="h-4.5 w-4.5" />
                </Button>
              </CardHeader>
              <CardContent className="py-4 space-y-3 flex-grow">
                <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Exercise List</span>
                <div className="space-y-2 max-h-56 overflow-y-auto pr-1">
                  {workout.exercises.map((ex: any, idx: number) => (
                    <div key={idx} className="p-2.5 rounded-lg bg-[#252930]/40 border border-[#2C3038]/50 flex items-center justify-between text-xs font-semibold">
                      <div className="flex flex-col min-w-0">
                        <span className="text-white truncate">{ex.name}</span>
                        {ex.notes && <span className="text-[9px] text-[#8E9297] font-medium truncate italic mt-0.5">{ex.notes}</span>}
                      </div>
                      <div className="flex items-center gap-3 shrink-0 text-[#8E9297] text-[10px]">
                        <span>{ex.sets} Sets</span> &bull; <span>{ex.reps} Reps</span> &bull; <span>{ex.restTime} Rest</span>
                      </div>
                    </div>
                  ))}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      )}
    </div>
  );
}
