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
import { Dumbbell, Eye, EyeOff, KeyRound, Loader2, Mail } from 'lucide-react';
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
    <div className="flex min-h-screen items-center justify-center bg-[#0E0F12] px-4 font-sans antialiased text-white relative overflow-hidden">
      {/* Background radial gradients for ambient glow */}
      <div className="absolute top-[-20%] left-[-10%] w-[50vw] h-[50vw] rounded-full bg-[#7CE047]/5 blur-[120px] pointer-events-none" />
      <div className="absolute bottom-[-20%] right-[-10%] w-[50vw] h-[50vw] rounded-full bg-[#7CE047]/5 blur-[120px] pointer-events-none" />

      <div className="w-full max-w-[440px] z-10">
        {/* Brand Logo Header */}
        <div className="flex flex-col items-center mb-8">
          <div className="flex items-center justify-center w-14 h-14 rounded-2xl bg-[#1C1E22] border border-[#2C3038] shadow-lg mb-3 glow-green-sm">
            <Dumbbell className="h-7 w-7 text-[#7CE047]" />
          </div>
          <h1 className="font-heading text-3xl font-bold tracking-wider uppercase">
            GYM <span className="text-[#7CE047]">ADMIN</span>
          </h1>
          <p className="text-sm text-[#8E9297] mt-1 font-medium">Executive Management Center</p>
        </div>

        <Card className="bg-[#1C1E22] border-[#2C3038] shadow-2xl relative overflow-hidden">
          {/* Subtle green indicator line at top of card */}
          <div className="absolute top-0 left-0 right-0 h-[2px] bg-[#7CE047]" />

          <CardHeader className="space-y-1 pb-6 pt-8">
            <CardTitle className="text-xl font-bold text-center text-white tracking-wide">
              Administrator Login
            </CardTitle>
            <CardDescription className="text-center text-[#8E9297] text-xs font-medium">
              Enter your executive credentials to access the console.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <form onSubmit={handleSubmit(onSubmit)} className="space-y-5">
              <div className="space-y-2">
                <Label htmlFor="email" className="text-xs font-semibold text-[#8E9297] uppercase tracking-wider">
                  Email Address
                </Label>
                <div className="relative">
                  <Mail className="absolute left-3.5 top-3 h-4 w-4 text-[#8E9297]" />
                  <Input
                    id="email"
                    type="email"
                    placeholder="admin@gym.com"
                    className="pl-10 bg-[#252930] border-[#2C3038] text-white focus:border-[#7CE047] focus:ring-1 focus:ring-[#7CE047] placeholder:text-[#8E9297]/50 rounded-xl h-11"
                    {...register('email')}
                  />
                </div>
                {errors.email && (
                  <p className="text-xs text-[#FF5252] font-semibold mt-1 pl-1">{errors.email.message}</p>
                )}
              </div>

              <div className="space-y-2">
                <div className="flex justify-between items-center">
                  <Label htmlFor="password" className="text-xs font-semibold text-[#8E9297] uppercase tracking-wider">
                    Password
                  </Label>
                  <button
                    type="button"
                    onClick={handleForgotPassword}
                    className="text-xs font-semibold text-[#7CE047] hover:underline transition"
                  >
                    Forgot Password?
                  </button>
                </div>
                <div className="relative">
                  <KeyRound className="absolute left-3.5 top-3 h-4 w-4 text-[#8E9297]" />
                  <Input
                    id="password"
                    type={showPassword ? 'text' : 'password'}
                    placeholder="••••••••"
                    className="pl-10 pr-10 bg-[#252930] border-[#2C3038] text-white focus:border-[#7CE047] focus:ring-1 focus:ring-[#7CE047] placeholder:text-[#8E9297]/50 rounded-xl h-11"
                    {...register('password')}
                  />
                  <button
                    type="button"
                    onClick={() => setShowPassword(!showPassword)}
                    className="absolute right-3 top-3.5 text-[#8E9297] hover:text-white transition"
                  >
                    {showPassword ? <EyeOff className="h-4 w-4" /> : <Eye className="h-4 w-4" />}
                  </button>
                </div>
                {errors.password && (
                  <p className="text-xs text-[#FF5252] font-semibold mt-1 pl-1">{errors.password.message}</p>
                )}
              </div>

              <Button
                type="submit"
                disabled={isSubmitting}
                className="w-full bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold text-sm tracking-wider uppercase h-11 rounded-xl shadow-lg shadow-[#7CE047]/10 transition-all duration-300 hover:scale-[1.01]"
              >
                {isSubmitting ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" /> Authenticating...
                  </>
                ) : (
                  'Login'
                )}
              </Button>
            </form>
          </CardContent>
          <CardFooter className="flex flex-col space-y-2 border-t border-[#2C3038]/50 pt-4 pb-6 bg-[#17191d]/30 text-center">
            <span className="text-[10px] font-semibold text-[#8E9297] uppercase tracking-widest">
              Demo Credentials
            </span>
            <span className="text-xs text-white/80 font-medium tracking-wide">
              admin@gym.com &bull; admin123
            </span>
          </CardFooter>
        </Card>
      </div>
    </div>
  );
}
