'use client';

import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useForm, useFieldArray } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { 
  Apple, Plus, Trash2, CheckCircle2, Loader2, Sparkles, 
  Scale, Flame, ShieldAlert, FileText, ChevronRight
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { toast } from 'sonner';

const mealSchema = z.object({
  category: z.enum(['Breakfast', 'Lunch', 'Snack', 'Dinner']),
  name: z.string().min(2, 'Meal description required'),
  calories: z.string().min(1, 'Calories required'),
  protein: z.string().min(1, 'Protein (g) required'),
  carbs: z.string().min(1, 'Carbohydrates (g) required'),
  fats: z.string().min(1, 'Fats (g) required'),
});

const dietFormSchema = z.object({
  name: z.string().min(2, 'Plan Name must be at least 2 characters'),
  meals: z.array(mealSchema).min(1, 'Please add at least 1 meal'),
});

type DietFormInputs = z.infer<typeof dietFormSchema>;

const fetchDiets = async () => {
  const res = await fetch('/api/diets');
  if (!res.ok) throw new Error('Failed to load diets');
  const data = await res.json();
  // Return dummy data if API is empty
  if (data.length === 0) {
    return [
      {
        id: 'DIET-001',
        name: 'Ketogenic Fat Loss',
        meals: [
          { category: 'Breakfast', name: 'Eggs and bacon', calories: 450, protein: 30, carbs: 5, fats: 35 },
          { category: 'Lunch', name: 'Grilled chicken salad', calories: 500, protein: 45, carbs: 8, fats: 30 },
          { category: 'Snack', name: 'Almonds and cheese', calories: 300, protein: 15, carbs: 5, fats: 25 },
          { category: 'Dinner', name: 'Salmon with asparagus', calories: 550, protein: 40, carbs: 10, fats: 40 }
        ]
      },
      {
        id: 'DIET-002',
        name: 'Muscle Building',
        meals: [
          { category: 'Breakfast', name: 'Oatmeal with protein powder', calories: 500, protein: 35, carbs: 60, fats: 10 },
          { category: 'Lunch', name: 'Rice and chicken breast', calories: 600, protein: 50, carbs: 70, fats: 15 },
          { category: 'Snack', name: 'Greek yogurt with berries', calories: 250, protein: 20, carbs: 30, fats: 5 },
          { category: 'Dinner', name: 'Steak with sweet potato', calories: 700, protein: 55, carbs: 50, fats: 30 }
        ]
      },
      {
        id: 'DIET-003',
        name: 'Balanced Maintenance',
        meals: [
          { category: 'Breakfast', name: 'Whole grain toast with avocado', calories: 400, protein: 12, carbs: 45, fats: 20 },
          { category: 'Lunch', name: 'Quinoa bowl with vegetables', calories: 550, protein: 25, carbs: 65, fats: 18 },
          { category: 'Snack', name: 'Apple and peanut butter', calories: 280, protein: 8, carbs: 35, fats: 12 },
          { category: 'Dinner', name: 'Turkey and vegetable stir-fry', calories: 480, protein: 35, carbs: 40, fats: 15 }
        ]
      }
    ];
  }
  return data;
};

export default function DietsPage() {
  const queryClient = useQueryClient();
  const [isOpen, setIsOpen] = useState(false);

  const { data: diets = [], isLoading } = useQuery<any[]>({
    queryKey: ['diets'],
    queryFn: fetchDiets
  });

  const { register, control, handleSubmit, reset, formState: { errors } } = useForm<DietFormInputs>({
    resolver: zodResolver(dietFormSchema),
    defaultValues: {
      name: '',
      meals: [{ category: 'Breakfast', name: '', calories: '400', protein: '30', carbs: '45', fats: '10' }]
    }
  });

  const { fields, append, remove } = useFieldArray({
    control,
    name: 'meals'
  });

  const createMutation = useMutation({
    mutationFn: async (data: DietFormInputs) => {
      // Map strings to numbers on post
      const formattedData = {
        ...data,
        meals: data.meals.map(m => ({
          ...m,
          calories: parseInt(m.calories) || 0,
          protein: parseInt(m.protein) || 0,
          carbs: parseInt(m.carbs) || 0,
          fats: parseInt(m.fats) || 0,
        }))
      };
      
      const res = await fetch('/api/diets', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formattedData)
      });
      if (!res.ok) throw new Error('Failed to create diet');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['diets'] });
      toast.success('Diet template constructed successfully');
      reset();
      setIsOpen(false);
    }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => {
      const res = await fetch(`/api/diets/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Deletion failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['diets'] });
      toast.success('Diet template deleted');
    }
  });

  return (
    <div className="p-6 md:p-8 space-y-6 bg-background min-h-full">
      {/* Header and trigger */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            DIET <span className="text-[#7CE047]">TEMPLATES</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Configure meal schedules, target macros, and caloric targets.
          </p>
        </div>

        <Dialog open={isOpen} onOpenChange={setIsOpen}>
          <DialogTrigger className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold text-xs uppercase tracking-wider rounded-xl gap-2 px-5 h-11 inline-flex shrink-0 items-center justify-center border border-transparent">
            <Plus className="h-4 w-4" /> Create Template
          </DialogTrigger>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-xl max-h-[80vh] overflow-y-auto">
            <DialogHeader>
              <DialogTitle className="font-heading text-xl font-bold tracking-wide uppercase text-white">Create Diet Plan</DialogTitle>
              <DialogDescription className="text-xs text-[#8E9297]">Assemble meal items, categories, and targets.</DialogDescription>
            </DialogHeader>
            <form onSubmit={handleSubmit((data) => createMutation.mutate(data))} className="space-y-4 pt-4">
              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Plan Name</Label>
                <Input {...register('name')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. Ketogenic Cut Ripped" />
                {errors.name && <p className="text-[10px] text-red-500">{errors.name.message}</p>}
              </div>

              {/* Dynamic meals array */}
              <div className="space-y-3 pt-3 border-t border-[#2C3038]/50">
                <div className="flex justify-between items-center">
                  <Label className="text-xs font-bold text-white uppercase tracking-wider">Meal List ({fields.length})</Label>
                  <Button 
                    type="button" 
                    variant="outline" 
                    size="sm"
                    className="bg-[#252930] border-[#2C3038] hover:bg-[#2C3038] text-[10px] rounded-lg h-7"
                    onClick={() => append({ category: 'Breakfast', name: '', calories: '400', protein: '30', carbs: '45', fats: '10' })}
                  >
                    Add Meal
                  </Button>
                </div>

                <div className="space-y-3">
                  {fields.map((field, idx) => (
                    <div key={field.id} className="p-3 rounded-lg border border-[#2C3038] bg-[#252930]/30 space-y-3 relative">
                      <div className="grid grid-cols-3 gap-2">
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Meal Category</Label>
                          <select {...register(`meals.${idx}.category` as const)} className="w-full h-8 bg-[#252930] border border-[#2C3038] text-xs text-white rounded-md p-1 outline-none">
                            <option value="Breakfast">Breakfast</option>
                            <option value="Lunch">Lunch</option>
                            <option value="Snack">Snack</option>
                            <option value="Dinner">Dinner</option>
                          </select>
                        </div>
                        <div className="col-span-2 space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Meal Items description</Label>
                          <Input {...register(`meals.${idx}.name` as const)} className="bg-[#252930] border-[#2C3038] h-8 text-xs" placeholder="e.g. Salmon and asparagus" />
                        </div>
                      </div>

                      <div className="grid grid-cols-4 gap-2">
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Calories</Label>
                          <Input {...register(`meals.${idx}.calories` as const)} type="number" className="bg-[#252930] border-[#2C3038] h-8 text-xs" />
                        </div>
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Protein (g)</Label>
                          <Input {...register(`meals.${idx}.protein` as const)} type="number" className="bg-[#252930] border-[#2C3038] h-8 text-xs" />
                        </div>
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Carbs (g)</Label>
                          <Input {...register(`meals.${idx}.carbs` as const)} type="number" className="bg-[#252930] border-[#2C3038] h-8 text-xs" />
                        </div>
                        <div className="space-y-1">
                          <Label className="text-[10px] text-[#8E9297]">Fats (g)</Label>
                          <Input {...register(`meals.${idx}.fats` as const)} type="number" className="bg-[#252930] border-[#2C3038] h-8 text-xs" />
                        </div>
                      </div>

                      <div className="flex justify-end pt-1">
                        <Button 
                          type="button" 
                          disabled={fields.length === 1}
                          onClick={() => remove(idx)}
                          className="bg-red-500/10 text-red-500 hover:bg-red-500/20 border border-red-500/30 h-7 rounded-lg text-[10px]"
                        >
                          Remove Meal
                        </Button>
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

      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
        </div>
      ) : (
        <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
          {diets.map((diet) => {
            const totalCals = diet.meals.reduce((sum: number, m: any) => sum + m.calories, 0);
            const totalProtein = diet.meals.reduce((sum: number, m: any) => sum + m.protein, 0);
            const totalCarbs = diet.meals.reduce((sum: number, m: any) => sum + m.carbs, 0);
            const totalFats = diet.meals.reduce((sum: number, m: any) => sum + m.fats, 0);

            return (
              <Card key={diet.id} className="bg-[#1C1E22] border-[#2C3038] text-white hover:border-[#7CE047]/30 transition-all duration-300 relative group overflow-hidden flex flex-col justify-between">
                <div className="absolute top-0 left-0 right-0 h-[2px] bg-[#2C3038] group-hover:bg-[#7CE047] transition-all" />
                <CardHeader className="flex flex-row justify-between items-start pt-6 pb-2">
                  <div className="space-y-1">
                    <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider text-white">{diet.name}</CardTitle>
                    <CardDescription className="text-xs text-[#8E9297] font-mono">Plan ID: {diet.id}</CardDescription>
                  </div>
                  <Button 
                    variant="ghost" 
                    size="icon"
                    className="text-[#FF5252] hover:bg-[#FF5252]/10 rounded-xl shrink-0"
                    onClick={() => {
                      if (confirm(`Delete plan ${diet.name}?`)) {
                        deleteMutation.mutate(diet.id);
                      }
                    }}
                  >
                    <Trash2 className="h-4.5 w-4.5" />
                  </Button>
                </CardHeader>
                <CardContent className="py-4 space-y-4 flex-grow">
                  {/* Macros Header */}
                  <div className="grid grid-cols-4 gap-2 p-2.5 rounded-lg bg-[#252930]/30 border border-[#2C3038]/50 text-center text-[10px] font-bold text-[#8E9297]">
                    <div>Cals <strong className="block text-[#7CE047] text-xs font-heading font-extrabold mt-0.5">{totalCals}</strong></div>
                    <div>P(g) <strong className="block text-[#2196F3] text-xs font-heading font-extrabold mt-0.5">{totalProtein}</strong></div>
                    <div>C(g) <strong className="block text-[#FFC107] text-xs font-heading font-extrabold mt-0.5">{totalCarbs}</strong></div>
                    <div>F(g) <strong className="block text-[#FF5252] text-xs font-heading font-extrabold mt-0.5">{totalFats}</strong></div>
                  </div>

                  <div className="space-y-2 max-h-56 overflow-y-auto pr-1">
                    {diet.meals.map((meal: any, idx: number) => (
                      <div key={idx} className="p-2.5 rounded-lg bg-[#252930]/40 border border-[#2C3038]/50 flex items-center justify-between text-xs font-semibold">
                        <div className="flex flex-col min-w-0">
                          <span className="text-[10px] text-[#7CE047] uppercase tracking-wider leading-none">{meal.category}</span>
                          <span className="text-white truncate mt-1">{meal.name}</span>
                        </div>
                        <span className="text-[10px] text-[#8E9297] shrink-0 font-bold bg-[#252930] px-2 py-0.5 rounded border border-[#2C3038]/40">
                          {meal.calories} kcal
                        </span>
                      </div>
                    ))}
                  </div>
                </CardContent>
              </Card>
            );
          })}
        </div>
      )}
    </div>
  );
}
