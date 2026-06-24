'use client';

import React, { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { ArrowLeft, User, Dumbbell, Apple, CalendarCheck, DollarSign, Trophy, Activity } from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Badge } from '@/components/ui/badge';
import { Tabs, TabsContent, TabsList, TabsTrigger } from '@/components/ui/tabs';
import { mockMembers } from '@/lib/mock-data';

const fetchMember = async (id: string) => {
  const member = mockMembers.find(m => m.id === id);
  if (!member) throw new Error('Member not found');
  return member;
};

export default function MemberProfilePage({ params }: { params: { id: string } }) {
  const router = useRouter();
  const { data: member, isLoading, isError } = useQuery({
    queryKey: ['member', params.id],
    queryFn: () => fetchMember(params.id),
  });

  if (isLoading) {
    return (
      <div className="flex items-center justify-center h-96">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-primary"></div>
      </div>
    );
  }

  if (isError || !member) {
    return (
      <div className="flex items-center justify-center h-96">
        <p className="text-destructive">Member not found</p>
      </div>
    );
  }

  return (
    <div className="p-6 md:p-8 space-y-6 bg-background min-h-full">
      {/* Header */}
      <div className="flex items-center gap-4">
        <Button variant="ghost" size="icon" onClick={() => router.back()}>
          <ArrowLeft className="h-5 w-5" />
        </Button>
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            MEMBER <span className="text-primary">PROFILE</span>
          </h1>
          <p className="text-xs text-muted-foreground font-medium tracking-wide mt-1">
            View detailed information and progress tracking
          </p>
        </div>
      </div>

      {/* Profile Card */}
      <Card className="bg-card border-border">
        <CardContent className="p-6">
          <div className="flex flex-col md:flex-row gap-6">
            <Avatar className="h-24 w-24 border-2 border-primary">
              <AvatarImage src={member.profilePhoto} alt={member.name} />
              <AvatarFallback className="text-2xl bg-primary text-background">
                {member.name.charAt(0)}
              </AvatarFallback>
            </Avatar>
            <div className="flex-1 space-y-4">
              <div>
                <h2 className="text-2xl font-bold text-foreground">{member.name}</h2>
                <p className="text-sm text-muted-foreground">{member.email}</p>
                <p className="text-sm text-muted-foreground">{member.mobile}</p>
              </div>
              <div className="flex flex-wrap gap-2">
                <Badge className="bg-primary/10 text-primary border-primary/30">
                  {member.status}
                </Badge>
                <Badge variant="secondary">{member.membershipPlan}</Badge>
                <Badge variant="outline">ID: {member.id}</Badge>
              </div>
            </div>
            <div className="grid grid-cols-2 gap-4">
              <div className="text-center p-4 bg-muted/50 rounded-lg">
                <p className="text-2xl font-bold text-primary">{member.currentWeight}</p>
                <p className="text-xs text-muted-foreground">Weight (kg)</p>
              </div>
              <div className="text-center p-4 bg-muted/50 rounded-lg">
                <p className="text-2xl font-bold text-destructive">{member.bodyFatPercentage}%</p>
                <p className="text-xs text-muted-foreground">Body Fat</p>
              </div>
              <div className="text-center p-4 bg-muted/50 rounded-lg">
                <p className="text-2xl font-bold text-foreground">{member.bmi}</p>
                <p className="text-xs text-muted-foreground">BMI</p>
              </div>
              <div className="text-center p-4 bg-muted/50 rounded-lg">
                <p className="text-2xl font-bold text-foreground">{member.muscleMass}</p>
                <p className="text-xs text-muted-foreground">Muscle Mass</p>
              </div>
            </div>
          </div>
        </CardContent>
      </Card>

      {/* Tabs */}
      <Tabs defaultValue="overview" className="space-y-4">
        <TabsList className="bg-card border-border">
          <TabsTrigger value="overview" className="data-[state=active]:bg-primary data-[state=active]:text-background">
            <User className="h-4 w-4 mr-2" /> Overview
          </TabsTrigger>
          <TabsTrigger value="workout" className="data-[state=active]:bg-primary data-[state=active]:text-background">
            <Dumbbell className="h-4 w-4 mr-2" /> Workout
          </TabsTrigger>
          <TabsTrigger value="diet" className="data-[state=active]:bg-primary data-[state=active]:text-background">
            <Apple className="h-4 w-4 mr-2" /> Diet
          </TabsTrigger>
          <TabsTrigger value="attendance" className="data-[state=active]:bg-primary data-[state=active]:text-background">
            <CalendarCheck className="h-4 w-4 mr-2" /> Attendance
          </TabsTrigger>
          <TabsTrigger value="payments" className="data-[state=active]:bg-primary data-[state=active]:text-background">
            <DollarSign className="h-4 w-4 mr-2" /> Payments
          </TabsTrigger>
          <TabsTrigger value="transformation" className="data-[state=active]:bg-primary data-[state=active]:text-background">
            <Trophy className="h-4 w-4 mr-2" /> Transformation
          </TabsTrigger>
        </TabsList>

        <TabsContent value="overview" className="space-y-4">
          <Card className="bg-card border-border">
            <CardHeader>
              <CardTitle>Personal Information</CardTitle>
              <CardDescription>Member details and assigned trainer</CardDescription>
            </CardHeader>
            <CardContent className="space-y-4">
              <div className="grid grid-cols-2 gap-4">
                <div>
                  <p className="text-sm text-muted-foreground">Assigned Trainer</p>
                  <p className="font-semibold">{member.assignedTrainer || 'Not assigned'}</p>
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Join Date</p>
                  <p className="font-semibold">{member.joinDate}</p>
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Expiry Date</p>
                  <p className="font-semibold">{member.expiryDate}</p>
                </div>
                <div>
                  <p className="text-sm text-muted-foreground">Membership Plan</p>
                  <p className="font-semibold">{member.membershipPlan}</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="workout" className="space-y-4">
          <Card className="bg-card border-border">
            <CardHeader>
              <CardTitle>Workout Plan</CardTitle>
              <CardDescription>Assigned workout routine and exercises</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">No workout plan assigned yet.</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="diet" className="space-y-4">
          <Card className="bg-card border-border">
            <CardHeader>
              <CardTitle>Diet Plan</CardTitle>
              <CardDescription>Nutrition plan and meal schedule</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">No diet plan assigned yet.</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="attendance" className="space-y-4">
          <Card className="bg-card border-border">
            <CardHeader>
              <CardTitle>Attendance History</CardTitle>
              <CardDescription>Check-in and check-out records</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">No attendance records available.</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="payments" className="space-y-4">
          <Card className="bg-card border-border">
            <CardHeader>
              <CardTitle>Payment History</CardTitle>
              <CardDescription>Transaction records and invoices</CardDescription>
            </CardHeader>
            <CardContent>
              <p className="text-muted-foreground">No payment records available.</p>
            </CardContent>
          </Card>
        </TabsContent>

        <TabsContent value="transformation" className="space-y-4">
          <Card className="bg-card border-border">
            <CardHeader>
              <CardTitle>Body Transformation</CardTitle>
              <CardDescription>Progress photos and measurement tracking</CardDescription>
            </CardHeader>
            <CardContent>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div className="aspect-square bg-muted/50 rounded-lg flex items-center justify-center">
                  <Activity className="h-12 w-12 text-muted-foreground" />
                  <p className="text-sm text-muted-foreground ml-2">Before Photo</p>
                </div>
                <div className="aspect-square bg-muted/50 rounded-lg flex items-center justify-center">
                  <Activity className="h-12 w-12 text-muted-foreground" />
                  <p className="text-sm text-muted-foreground ml-2">Current Photo</p>
                </div>
                <div className="aspect-square bg-muted/50 rounded-lg flex items-center justify-center">
                  <Trophy className="h-12 w-12 text-muted-foreground" />
                  <p className="text-sm text-muted-foreground ml-2">Goal Photo</p>
                </div>
              </div>
            </CardContent>
          </Card>
        </TabsContent>
      </Tabs>
    </div>
  );
}
