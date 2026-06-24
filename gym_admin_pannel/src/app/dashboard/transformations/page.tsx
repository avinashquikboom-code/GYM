'use client';

import React, { useState, useEffect } from 'react';
import { useQuery } from '@tanstack/react-query';
import { 
  Activity, Scale, Ruler, Sparkles, AlertCircle, Loader2,
  TrendingDown, TrendingUp, HelpCircle
} from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';

const fetchMembers = async () => {
  const res = await fetch('/api/members');
  if (!res.ok) throw new Error('Failed to load members');
  return res.json();
};

export default function TransformationsPage() {
  const [selectedMemberId, setSelectedMemberId] = useState<string>('');

  const { data: members = [], isLoading } = useQuery<any[]>({
    queryKey: ['members'],
    queryFn: fetchMembers
  });

  useEffect(() => {
    if (members.length > 0 && !selectedMemberId) {
      // Default to first active member
      const active = members.find(m => m.status === 'active') || members[0];
      setSelectedMemberId(active.id);
    }
  }, [members, selectedMemberId]);

  const activeMember = members.find(m => m.id === selectedMemberId);

  // Dummy baseline values for comparison
  const getBaseline = (m: any) => {
    return {
      weight: m.weightHistory?.[0]?.value || m.currentWeight + 4,
      fat: m.bodyFatHistory?.[0]?.value || m.bodyFat + 3,
      muscle: m.muscleMassHistory?.[0]?.value || m.muscleMass - 2,
      chest: m.measurements?.chest - 4 || 92,
      waist: m.measurements?.waist + 6 || 84,
      biceps: m.measurements?.biceps - 4 || 30,
    };
  };

  const getGoals = (m: any) => {
    return {
      weight: m.currentWeight - 3,
      fat: m.bodyFat - 2.5,
      muscle: m.muscleMass + 1.5,
      chest: m.measurements?.chest + 2 || 100,
      waist: m.measurements?.waist - 4 || 74,
      biceps: m.measurements?.biceps + 2 || 34,
    };
  };

  return (
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
      {/* Header and selector */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            BODY <span className="text-[#7CE047]">TRANSFORMATIONS</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Compare chest/waist/bicep measurements, fat percentages, and physical targets.
          </p>
        </div>

        {/* Member dropdown selector */}
        {members.length > 0 && (
          <div className="flex items-center gap-3">
            <span className="text-xs text-[#8E9297] font-semibold uppercase tracking-wider">Select Client</span>
            <select 
              value={selectedMemberId}
              onChange={(e) => setSelectedMemberId(e.target.value)}
              className="bg-[#1C1E22] border border-[#2C3038] text-xs rounded-xl p-2.5 outline-none font-medium text-white min-w-56"
            >
              {members.map(m => (
                <option key={m.id} value={m.id}>{m.name} ({m.id})</option>
              ))}
            </select>
          </div>
        )}
      </div>

      {isLoading ? (
        <div className="flex items-center justify-center py-20">
          <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
        </div>
      ) : !activeMember ? (
        <div className="text-center py-12 text-[#8E9297]">
          <AlertCircle className="h-10 w-10 mx-auto text-[#8E9297]/50 mb-3" />
          <p className="text-sm font-semibold">No member roster active</p>
        </div>
      ) : (() => {
        const base = getBaseline(activeMember);
        const goal = getGoals(activeMember);
        
        return (
          <div className="space-y-8">
            
            {/* Visual comparison grid */}
            <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
              <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
                <CardHeader className="py-4 border-b border-[#2C3038]/50 text-center">
                  <CardTitle className="font-heading text-sm font-bold uppercase tracking-wider text-[#8E9297]">Before Body</CardTitle>
                </CardHeader>
                <CardContent className="pt-6">
                  <div className="w-full h-72 rounded-xl bg-[#252930] flex items-center justify-center border border-[#2C3038] relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1517838277536-f5f99be501cd?q=80&w=300&auto=format&fit=crop" className="object-cover w-full h-full grayscale" alt="Before" />
                    <div className="absolute bottom-2 left-2 bg-[#0E0F12]/80 px-2 py-1 rounded-md text-[9px] font-bold uppercase text-[#8E9297]">
                      Baseline Metrics
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
                <CardHeader className="py-4 border-b border-[#2C3038]/50 text-center">
                  <CardTitle className="font-heading text-sm font-bold uppercase tracking-wider text-[#7CE047]">Current Progress</CardTitle>
                </CardHeader>
                <CardContent className="pt-6">
                  <div className="w-full h-72 rounded-xl bg-[#252930] flex items-center justify-center border border-[#7CE047]/30 relative overflow-hidden">
                    <img src={activeMember.avatarUrl} className="object-cover w-full h-full" alt="Current" />
                    <div className="absolute bottom-2 left-2 bg-[#7CE047]/80 text-[#0E0F12] px-2 py-1 rounded-md text-[9px] font-bold uppercase">
                      Current Body
                    </div>
                  </div>
                </CardContent>
              </Card>

              <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
                <CardHeader className="py-4 border-b border-[#2C3038]/50 text-center">
                  <CardTitle className="font-heading text-sm font-bold uppercase tracking-wider text-[#2196F3]">Target Goal</CardTitle>
                </CardHeader>
                <CardContent className="pt-6">
                  <div className="w-full h-72 rounded-xl bg-[#252930] flex items-center justify-center border border-[#2C3038] relative overflow-hidden">
                    <img src="https://images.unsplash.com/photo-1548690312-e3b507d8c110?q=80&w=300&auto=format&fit=crop" className="object-cover w-full h-full grayscale" alt="Goal" />
                    <div className="absolute bottom-2 left-2 bg-[#2196F3]/80 px-2 py-1 rounded-md text-[9px] font-bold uppercase text-white">
                      Goal Target
                    </div>
                  </div>
                </CardContent>
              </Card>
            </div>

            {/* Measurement parameters comparative summary */}
            <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
              <CardHeader className="border-b border-[#2C3038] pb-4">
                <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider">Metrics Parameter Comparison</CardTitle>
                <CardDescription className="text-xs text-[#8E9297]">Compare physical tape measurements, weights, and fat percentages.</CardDescription>
              </CardHeader>
              <CardContent className="pt-6">
                <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                  {/* Weight */}
                  <div className="p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038] flex flex-col justify-between">
                    <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Total Weight</span>
                    <div className="flex justify-between items-baseline mt-4">
                      <div>
                        <span className="block text-[9px] text-[#8E9297] uppercase font-bold">Baseline</span>
                        <span className="text-sm font-bold text-white mt-1">{base.weight} kg</span>
                      </div>
                      <div className="text-center">
                        <span className="block text-[9px] text-[#7CE047] uppercase font-bold">Current</span>
                        <span className="text-xl font-heading font-extrabold text-white mt-1">{activeMember.currentWeight} kg</span>
                      </div>
                      <div className="text-right">
                        <span className="block text-[9px] text-[#2196F3] uppercase font-bold">Goal</span>
                        <span className="text-sm font-bold text-white mt-1">{goal.weight} kg</span>
                      </div>
                    </div>
                  </div>

                  {/* Body Fat */}
                  <div className="p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038] flex flex-col justify-between">
                    <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Body Fat</span>
                    <div className="flex justify-between items-baseline mt-4">
                      <div>
                        <span className="block text-[9px] text-[#8E9297] uppercase font-bold">Baseline</span>
                        <span className="text-sm font-bold text-white mt-1">{base.fat}%</span>
                      </div>
                      <div className="text-center">
                        <span className="block text-[9px] text-[#7CE047] uppercase font-bold">Current</span>
                        <span className="text-xl font-heading font-extrabold text-[#7CE047] mt-1">{activeMember.bodyFat}%</span>
                      </div>
                      <div className="text-right">
                        <span className="block text-[9px] text-[#2196F3] uppercase font-bold">Goal</span>
                        <span className="text-sm font-bold text-white mt-1">{goal.fat}%</span>
                      </div>
                    </div>
                  </div>

                  {/* Muscle Mass */}
                  <div className="p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038] flex flex-col justify-between">
                    <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Muscle Mass</span>
                    <div className="flex justify-between items-baseline mt-4">
                      <div>
                        <span className="block text-[9px] text-[#8E9297] uppercase font-bold">Baseline</span>
                        <span className="text-sm font-bold text-white mt-1">{base.muscle} kg</span>
                      </div>
                      <div className="text-center">
                        <span className="block text-[9px] text-[#7CE047] uppercase font-bold">Current</span>
                        <span className="text-xl font-heading font-extrabold text-[#2196F3] mt-1">{activeMember.muscleMass} kg</span>
                      </div>
                      <div className="text-right">
                        <span className="block text-[9px] text-[#2196F3] uppercase font-bold">Goal</span>
                        <span className="text-sm font-bold text-white mt-1">{goal.muscle} kg</span>
                      </div>
                    </div>
                  </div>

                  {/* Chest */}
                  <div className="p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038] flex flex-col justify-between">
                    <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Chest Tape</span>
                    <div className="flex justify-between items-baseline mt-4">
                      <div>
                        <span className="block text-[9px] text-[#8E9297] uppercase font-bold">Baseline</span>
                        <span className="text-sm font-bold text-white mt-1">{base.chest} cm</span>
                      </div>
                      <div className="text-center">
                        <span className="block text-[9px] text-[#7CE047] uppercase font-bold">Current</span>
                        <span className="text-xl font-heading font-extrabold text-white mt-1">{activeMember.measurements?.chest || 98} cm</span>
                      </div>
                      <div className="text-right">
                        <span className="block text-[9px] text-[#2196F3] uppercase font-bold">Goal</span>
                        <span className="text-sm font-bold text-white mt-1">{goal.chest} cm</span>
                      </div>
                    </div>
                  </div>

                  {/* Waist */}
                  <div className="p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038] flex flex-col justify-between">
                    <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Waist Tape</span>
                    <div className="flex justify-between items-baseline mt-4">
                      <div>
                        <span className="block text-[9px] text-[#8E9297] uppercase font-bold">Baseline</span>
                        <span className="text-sm font-bold text-white mt-1">{base.waist} cm</span>
                      </div>
                      <div className="text-center">
                        <span className="block text-[9px] text-[#7CE047] uppercase font-bold">Current</span>
                        <span className="text-xl font-heading font-extrabold text-white mt-1">{activeMember.measurements?.waist || 78} cm</span>
                      </div>
                      <div className="text-right">
                        <span className="block text-[9px] text-[#2196F3] uppercase font-bold">Goal</span>
                        <span className="text-sm font-bold text-white mt-1">{goal.waist} cm</span>
                      </div>
                    </div>
                  </div>

                  {/* Biceps */}
                  <div className="p-4 rounded-xl bg-[#252930]/40 border border-[#2C3038] flex flex-col justify-between">
                    <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Biceps Tape</span>
                    <div className="flex justify-between items-baseline mt-4">
                      <div>
                        <span className="block text-[9px] text-[#8E9297] uppercase font-bold">Baseline</span>
                        <span className="text-sm font-bold text-white mt-1">{base.biceps} cm</span>
                      </div>
                      <div className="text-center">
                        <span className="block text-[9px] text-[#7CE047] uppercase font-bold">Current</span>
                        <span className="text-xl font-heading font-extrabold text-white mt-1">{activeMember.measurements?.biceps || 34} cm</span>
                      </div>
                      <div className="text-right">
                        <span className="block text-[9px] text-[#2196F3] uppercase font-bold">Goal</span>
                        <span className="text-sm font-bold text-white mt-1">{goal.biceps} cm</span>
                      </div>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

          </div>
        );
      })()}
    </div>
  );
}
