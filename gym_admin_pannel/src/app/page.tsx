'use client';

import React, { useState } from 'react';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { useAuth } from '@/context/auth-context';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Dumbbell, Eye, EyeOff, KeyRound, Loader2, Mail, Activity, Trophy, Flame } from 'lucide-react';
import { toast } from 'sonner';

const loginSchema = z.object({
  email: z.string().email('Please enter a valid email address'),
  password: z.string().min(6, 'Password must be at least 6 characters long'),
});

type LoginInputs = z.infer<typeof loginSchema>;

export default function LoginPage() {
  const { login } = useAuth();
  const [showPassword, setShowPassword] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);

  const {
    register,
    handleSubmit,
    formState: { errors },
  } = useForm<LoginInputs>({
    resolver: zodResolver(loginSchema),
    defaultValues: {
      email: '',
      password: '',
    },
  });

  const onSubmit = async (data: LoginInputs) => {
    setIsSubmitting(true);
    const success = await login(data.email, data.password);
    setIsSubmitting(false);
  };

  const handleForgotPassword = () => {
    toast.info('Password reset instructions sent to your email (Simulated)', {
      description: 'Check your inbox for password reset link.',
    });
  };

  return (
    <div className="flex min-h-screen items-center justify-center bg-gradient-to-br from-slate-950 via-slate-900 to-slate-950 px-4 font-sans antialiased text-white relative overflow-hidden">
      {/* Dynamic gym-themed background */}
      <div className="absolute inset-0 overflow-hidden">
        {/* Animated gradient orbs */}
        <div className="absolute top-[-10%] left-[-10%] w-[40vw] h-[40vw] rounded-full bg-emerald-500/10 blur-[100px] animate-pulse" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[40vw] h-[40vw] rounded-full bg-orange-500/10 blur-[100px] animate-pulse delay-1000" />
        <div className="absolute top-[30%] right-[20%] w-[20vw] h-[20vw] rounded-full bg-purple-500/5 blur-[80px] animate-pulse delay-500" />
        
        {/* Grid pattern overlay */}
        <div className="absolute inset-0 opacity-5" style={{
          backgroundImage: `linear-gradient(rgba(255,255,255,0.1) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.1) 1px, transparent 1px)`,
          backgroundSize: '50px 50px'
        }} />
      </div>

      {/* Floating fitness icons */}
      <div className="absolute top-20 left-20 opacity-10 animate-bounce">
        <Dumbbell className="h-16 w-16" />
      </div>
      <div className="absolute bottom-32 right-32 opacity-10 animate-bounce delay-700">
        <Activity className="h-14 w-14" />
      </div>
      <div className="absolute top-1/2 right-20 opacity-10 animate-bounce delay-300">
        <Trophy className="h-12 w-12" />
      </div>
      <div className="absolute bottom-20 left-32 opacity-10 animate-bounce delay-1000">
        <Flame className="h-10 w-10" />
      </div>

      <div className="w-full max-w-[440px] z-10">
        {/* Brand Logo Header */}
        <div className="flex flex-col items-center mb-8">
          <div className="relative">
            <div className="flex items-center justify-center w-20 h-20 rounded-3xl bg-gradient-to-br from-emerald-500 to-emerald-600 shadow-2xl shadow-emerald-500/30 mb-4 relative overflow-hidden">
              <div className="absolute inset-0 bg-gradient-to-br from-white/20 to-transparent" />
              <Dumbbell className="h-10 w-10 text-white relative z-10" />
            </div>
            <div className="absolute -bottom-1 -right-1 w-6 h-6 bg-orange-500 rounded-full flex items-center justify-center">
              <Flame className="h-3 w-3 text-white" />
            </div>
          </div>
          <h1 className="font-heading text-4xl font-extrabold tracking-tight uppercase mb-1">
            <span className="bg-gradient-to-r from-emerald-400 to-emerald-600 bg-clip-text text-transparent">GYM</span>
            <span className="text-white">ADMIN</span>
          </h1>
          <p className="text-sm text-slate-400 font-medium tracking-wide">Fitness Management Portal</p>
        </div>

        <Card className="bg-slate-900/80 backdrop-blur-xl border-slate-700/50 shadow-2xl relative overflow-hidden">
          {/* Animated gradient border */}
          <div className="absolute inset-0 bg-gradient-to-r from-emerald-500/20 via-orange-500/20 to-emerald-500/20 animate-gradient-x opacity-30" />
          
          {/* Card content */}
          <div className="relative">
            {/* Top accent line */}
            <div className="h-1 bg-gradient-to-r from-emerald-500 via-orange-500 to-emerald-500 animate-gradient-x" />

            <CardHeader className="space-y-2 pb-6 pt-8">
              <CardTitle className="text-2xl font-bold text-center text-white tracking-wide">
                Welcome Back
              </CardTitle>
              <CardDescription className="text-center text-slate-400 text-sm font-medium">
                Access your gym management dashboard
              </CardDescription>
            </CardHeader>
            <CardContent>
              <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
                <div className="space-y-2">
                  <Label htmlFor="email" className="text-xs font-bold text-slate-300 uppercase tracking-wider">
                    Email Address
                  </Label>
                  <div className="relative">
                    <Mail className="absolute left-3.5 top-3 h-4 w-4 text-slate-500" />
                    <Input
                      id="email"
                      type="email"
                      placeholder="admin@gym.com"
                      className="pl-10 bg-slate-800/50 border-slate-700 text-white focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 placeholder:text-slate-600 rounded-xl h-12 transition-all duration-200"
                      {...register('email')}
                    />
                  </div>
                  {errors.email && (
                    <p className="text-xs text-red-400 font-semibold mt-1 pl-1">{errors.email.message}</p>
                  )}
                </div>

                <div className="space-y-2">
                  <div className="flex justify-between items-center">
                    <Label htmlFor="password" className="text-xs font-bold text-slate-300 uppercase tracking-wider">
                      Password
                    </Label>
                    <button
                      type="button"
                      onClick={handleForgotPassword}
                      className="text-xs font-bold text-emerald-400 hover:text-emerald-300 transition"
                    >
                      Forgot Password?
                    </button>
                  </div>
                  <div className="relative">
                    <KeyRound className="absolute left-3.5 top-3 h-4 w-4 text-slate-500" />
                    <Input
                      id="password"
                      type={showPassword ? 'text' : 'password'}
                      placeholder="••••••••"
                      className="pl-10 pr-10 bg-slate-800/50 border-slate-700 text-white focus:border-emerald-500 focus:ring-2 focus:ring-emerald-500/20 placeholder:text-slate-600 rounded-xl h-12 transition-all duration-200"
                      {...register('password')}
                    />
                    <button
                      type="button"
                      onClick={() => setShowPassword(!showPassword)}
                      className="absolute right-3 top-3.5 text-slate-500 hover:text-slate-300 transition"
                    >
                      {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                    </button>
                  </div>
                  {errors.password && (
                    <p className="text-xs text-red-400 font-semibold mt-1 pl-1">{errors.password.message}</p>
                  )}
                </div>

                <Button
                  type="submit"
                  disabled={isSubmitting}
                  className="w-full bg-gradient-to-r from-emerald-500 to-emerald-600 hover:from-emerald-600 hover:to-emerald-700 text-white font-bold text-sm tracking-wider uppercase h-12 rounded-xl shadow-lg shadow-emerald-500/30 transition-all duration-300 hover:scale-[1.02] hover:shadow-emerald-500/40"
                >
                  {isSubmitting ? (
                    <>
                      <Loader2 className="mr-2 h-4 w-4 animate-spin" /> Authenticating...
                    </>
                  ) : (
                    <>
                      <Dumbbell className="mr-2 h-4 w-4" /> Login to Dashboard
                    </>
                  )}
                </Button>
              </form>
            </CardContent>
            <CardFooter className="flex flex-col space-y-3 border-t border-slate-700/50 pt-5 pb-6 bg-slate-800/30 text-center">
              <div className="flex items-center justify-center gap-2 mb-2">
                <div className="h-px bg-slate-700 flex-1" />
                <span className="text-[10px] font-bold text-slate-500 uppercase tracking-widest">
                  Demo Access
                </span>
                <div className="h-px bg-slate-700 flex-1" />
              </div>
              <div className="bg-slate-800/50 rounded-lg p-3 border border-slate-700/50">
                <span className="text-xs text-slate-400 font-medium tracking-wide">
                  <span className="text-emerald-400 font-bold">Email:</span> admin@gym.com
                </span>
                <span className="text-xs text-slate-400 font-medium tracking-wide block mt-1">
                  <span className="text-emerald-400 font-bold">Password:</span> admin123
                </span>
              </div>
            </CardFooter>
          </div>
        </Card>
        
        {/* Footer branding */}
        <div className="mt-8 text-center">
          <p className="text-[10px] text-slate-600 font-semibold uppercase tracking-widest">
            Powered by <span className="text-emerald-500">GymHub</span> Management System
          </p>
        </div>
      </div>
    </div>
  );
}
