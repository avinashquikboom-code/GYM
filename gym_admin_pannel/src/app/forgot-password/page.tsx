'use client';

import { useState } from 'react';
import { useRouter } from 'next/navigation';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Card, CardContent, CardDescription, CardFooter, CardHeader, CardTitle } from '@/components/ui/card';
import { Dumbbell, Loader2, ArrowLeft, Trophy, Flame } from 'lucide-react';
import { motion } from 'framer-motion';
import { toast } from 'sonner';
import Link from 'next/link';

export default function ForgotPasswordPage() {
  const router = useRouter();
  const [email, setEmail] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsLoading(true);

    try {
      // Simulate API call
      await new Promise(resolve => setTimeout(resolve, 2000));
      toast.success('Password reset link sent to your email');
      router.push('/login');
    } catch (error) {
      toast.error('Failed to send reset link. Please try again.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-background p-4 relative overflow-hidden">
      {/* Decorative floating icons */}
      <motion.div
        animate={{ y: [0, -10, 0], rotate: [0, 5, 0] }}
        transition={{ duration: 3, repeat: Infinity, ease: "easeInOut" }}
        className="absolute top-10 right-10 text-primary/20 pointer-events-none"
      >
        <Dumbbell className="h-20 w-20" />
      </motion.div>
      <motion.div
        animate={{ y: [0, 10, 0], rotate: [0, -5, 0] }}
        transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
        className="absolute top-32 right-32 text-primary/15 pointer-events-none"
      >
        <Dumbbell className="h-16 w-16" />
      </motion.div>
      <motion.div
        animate={{ y: [0, -8, 0], scale: [1, 1.1, 1] }}
        transition={{ duration: 2.5, repeat: Infinity, ease: "easeInOut" }}
        className="absolute top-20 left-20 text-[#FFD700]/20 pointer-events-none"
      >
        <Trophy className="h-16 w-16" />
      </motion.div>
      <motion.div
        animate={{ y: [0, 15, 0], rotate: [0, 10, -10, 0] }}
        transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
        className="absolute bottom-20 right-20 text-[#FF6B35]/20 pointer-events-none"
      >
        <Flame className="h-24 w-24" />
      </motion.div>
      <motion.div
        animate={{ y: [0, -12, 0], rotate: [0, -10, 0] }}
        transition={{ duration: 3.5, repeat: Infinity, ease: "easeInOut" }}
        className="absolute bottom-32 left-32 text-primary/20 pointer-events-none"
      >
        <Dumbbell className="h-14 w-14" />
      </motion.div>
      <motion.div
        animate={{ y: [0, 8, 0], scale: [1, 1.15, 1] }}
        transition={{ duration: 2, repeat: Infinity, ease: "easeInOut" }}
        className="absolute top-48 left-10 text-[#FFD700]/15 pointer-events-none"
      >
        <Trophy className="h-12 w-12" />
      </motion.div>
      <motion.div
        animate={{ y: [0, -15, 0], rotate: [0, -15, 15, 0] }}
        transition={{ duration: 2.8, repeat: Infinity, ease: "easeInOut" }}
        className="absolute bottom-10 left-20 text-[#FF6B35]/15 pointer-events-none"
      >
        <Flame className="h-20 w-20" />
      </motion.div>
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.5 }}
        className="w-full max-w-md relative z-10"
      >
        <Card className="border-border/50 glass-panel">
          <CardHeader className="space-y-4 text-center">
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.2, type: 'spring' }}
              className="mx-auto w-16 h-16 bg-primary rounded-full flex items-center justify-center glow-green"
            >
              <Dumbbell className="w-8 h-8 text-background" />
            </motion.div>
            <div>
              <CardTitle className="text-2xl font-bold text-foreground">Forgot Password</CardTitle>
              <CardDescription className="text-muted-foreground mt-2">
                Enter your email to receive a password reset link
              </CardDescription>
            </div>
          </CardHeader>
          <form onSubmit={handleSubmit}>
            <CardContent className="space-y-4">
              <div className="space-y-2">
                <Label htmlFor="email" className="text-foreground">Email</Label>
                <Input
                  id="email"
                  type="email"
                  placeholder="admin@gym.com"
                  value={email}
                  onChange={(e) => setEmail(e.target.value)}
                  required
                  className="bg-background border-border focus:border-primary"
                />
              </div>
            </CardContent>
            <CardFooter className="flex flex-col space-y-4">
              <Button
                type="submit"
                className="w-full bg-primary text-background hover:bg-primary/90 glow-green-sm"
                disabled={isLoading}
              >
                {isLoading ? (
                  <>
                    <Loader2 className="mr-2 h-4 w-4 animate-spin" />
                    Sending...
                  </>
                ) : (
                  'Send Reset Link'
                )}
              </Button>
              <Link href="/login" className="w-full">
                <Button
                  type="button"
                  variant="ghost"
                  className="w-full text-muted-foreground hover:text-foreground"
                >
                  <ArrowLeft className="mr-2 h-4 w-4" />
                  Back to Login
                </Button>
              </Link>
            </CardFooter>
          </form>
        </Card>
      </motion.div>
    </div>
  );
}
