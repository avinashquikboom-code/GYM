'use client';

import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { 
  CalendarDays, QrCode, LogIn, Users, CheckCircle, 
  Clock, XCircle, Loader2, Sparkles, AlertCircle 
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Label } from '@/components/ui/label';
import { toast } from 'sonner';

const fetchAttendance = async () => {
  const res = await fetch('/api/attendance');
  if (!res.ok) throw new Error('Failed to load attendance logs');
  return res.json();
};

const fetchMembers = async () => {
  const res = await fetch('/api/members');
  if (!res.ok) throw new Error('Failed to load members');
  return res.json();
};

export default function AttendancePage() {
  const queryClient = useQueryClient();
  const [isOpen, setIsOpen] = useState(false);

  const { data: logs = [], isLoading } = useQuery<any[]>({
    queryKey: ['attendance'],
    queryFn: fetchAttendance,
    refetchInterval: 10000 // auto refresh check-in logs every 10 seconds
  });

  const { data: members = [] } = useQuery<any[]>({
    queryKey: ['members'],
    queryFn: fetchMembers
  });

  const checkinMutation = useMutation({
    mutationFn: async (data: { memberId: string; gate: string }) => {
      const res = await fetch('/api/attendance', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(data)
      });
      if (!res.ok) throw new Error('Checkin scanner authentication denied');
      return res.json();
    },
    onSuccess: (data) => {
      queryClient.invalidateQueries({ queryKey: ['attendance'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
      queryClient.invalidateQueries({ queryKey: ['member', data.memberId] });
      
      if (data.status === 'absent') {
        toast.error('Gate Scan Access Denied!', {
          description: `${data.name} is currently suspended due to billing.`,
        });
      } else {
        toast.success('Gate Scan Authenticated Successfully!', {
          description: `${data.name} entered via ${data.gate} as ${data.status.toUpperCase()}.`,
        });
      }
      setIsOpen(false);
    }
  });

  // Calculate stats
  const presentCount = logs.filter(l => l.status === 'present').length;
  const lateCount = logs.filter(l => l.status === 'late').length;
  const deniedCount = logs.filter(l => l.status === 'absent').length;

  return (
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
      {/* Header and trigger */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            LIVE <span className="text-[#7CE047]">ATTENDANCE</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Real-time gate scan checkpoints, validation logs, and simulator scanners.
          </p>
        </div>

        {/* QR Simulator Dialog */}
        <Dialog open={isOpen} onOpenChange={setIsOpen}>
          <DialogTrigger className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold text-xs uppercase tracking-wider rounded-xl gap-2 px-5 h-11 inline-flex shrink-0 items-center justify-center border border-transparent">
            <QrCode className="h-4 w-4" /> Simulate QR Scan
          </DialogTrigger>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-sm">
            <DialogHeader>
              <DialogTitle className="font-heading text-lg font-bold uppercase tracking-wider text-white">QR Gate Simulator</DialogTitle>
              <DialogDescription className="text-xs text-[#8E9297]">Choose a member and gate location to simulate a check-in.</DialogDescription>
            </DialogHeader>
            <div className="py-4 space-y-4">
              <div className="flex justify-center mb-4">
                <div className="w-28 h-28 border border-[#2C3038] rounded-2xl bg-[#252930] flex items-center justify-center relative overflow-hidden">
                  <div className="absolute top-0 left-0 right-0 h-[2px] bg-[#7CE047] shadow-[0_0_8px_#7CE047] animate-bounce" />
                  <QrCode className="h-16 w-16 text-[#8E9297]/60" />
                </div>
              </div>
              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Choose Gym Member</Label>
                <select 
                  id="scan-member-select"
                  className="w-full bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none"
                >
                  {members.map(m => (
                    <option key={m.id} value={m.id}>{m.name} ({m.status.toUpperCase()})</option>
                  ))}
                </select>
              </div>
              <div className="space-y-1.5">
                <Label className="text-xs text-[#8E9297]">Scan Gate Location</Label>
                <select 
                  id="scan-gate-select"
                  className="w-full bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none"
                >
                  <option value="Gate A - Main Entry">Gate A - Main Entry</option>
                  <option value="Gate B - Cardio Area">Gate B - Cardio Area</option>
                  <option value="Gate C - Pool Side">Gate C - Pool Side</option>
                  <option value="Gate D - Heavy Weights Room">Gate D - Heavy Weights Room</option>
                </select>
              </div>
            </div>
            <DialogFooter className="border-t border-[#2C3038] pt-4">
              <Button type="button" variant="ghost" onClick={() => setIsOpen(false)} className="text-[#8E9297] rounded-xl">Cancel</Button>
              <Button 
                type="button" 
                onClick={() => {
                  const memberId = (document.getElementById('scan-member-select') as HTMLSelectElement).value;
                  const gate = (document.getElementById('scan-gate-select') as HTMLSelectElement).value;
                  if (memberId && gate) {
                    checkinMutation.mutate({ memberId, gate });
                  }
                }}
                className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold uppercase text-xs rounded-xl"
              >
                Trigger Scan Pass
              </Button>
            </DialogFooter>
          </DialogContent>
        </Dialog>
      </div>

      {/* Stats summary board */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
          <CardContent className="p-5 flex items-center justify-between">
            <div className="space-y-1">
              <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Checked In On-Time</span>
              <span className="text-3xl font-heading font-extrabold text-[#7CE047] block mt-1">{presentCount}</span>
            </div>
            <div className="w-10 h-10 rounded-lg bg-[#7CE047]/10 flex items-center justify-center text-[#7CE047]">
              <CheckCircle className="h-5 w-5" />
            </div>
          </CardContent>
        </Card>
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
          <CardContent className="p-5 flex items-center justify-between">
            <div className="space-y-1">
              <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Checked In Late</span>
              <span className="text-3xl font-heading font-extrabold text-[#FFC107] block mt-1">{lateCount}</span>
            </div>
            <div className="w-10 h-10 rounded-lg bg-[#FFC107]/10 flex items-center justify-center text-[#FFC107]">
              <Clock className="h-5 w-5" />
            </div>
          </CardContent>
        </Card>
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
          <CardContent className="p-5 flex items-center justify-between">
            <div className="space-y-1">
              <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Scans Denied</span>
              <span className="text-3xl font-heading font-extrabold text-[#FF5252] block mt-1">{deniedCount}</span>
            </div>
            <div className="w-10 h-10 rounded-lg bg-[#FF5252]/10 flex items-center justify-center text-[#FF5252]">
              <XCircle className="h-5 w-5" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Logs Table */}
      <Card className="bg-[#1C1E22] border-[#2C3038] text-white overflow-hidden">
        <CardHeader className="border-b border-[#2C3038] pb-4">
          <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider text-white">Gate Access History Log</CardTitle>
          <CardDescription className="text-xs text-[#8E9297]">Client scans are appended dynamically as they pass physical gates.</CardDescription>
        </CardHeader>
        {isLoading ? (
          <div className="flex items-center justify-center py-20">
            <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
          </div>
        ) : (
          <Table>
            <TableHeader className="bg-[#252930]/20">
              <TableRow className="border-[#2C3038]">
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Client Name</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Scan Time</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Gate Checkpoint</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Status Badge</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {logs.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={4} className="text-center py-8 text-xs text-[#8E9297]">No live scans registered.</TableCell>
                </TableRow>
              ) : (
                logs.map((log) => (
                  <TableRow key={log.id} className="border-[#2C3038] hover:bg-[#252930]/10 transition-colors">
                    <TableCell className="font-bold text-white py-4">{log.name}</TableCell>
                    <TableCell className="text-[#8E9297]">{log.time}</TableCell>
                    <TableCell className="text-[#8E9297]">{log.gate}</TableCell>
                    <TableCell>
                      <Badge className={`rounded-xl px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
                        log.status === 'present' 
                          ? 'bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30' 
                          : log.status === 'late' 
                            ? 'bg-[#FFC107]/10 text-[#FFC107] border border-[#FFC107]/30' 
                            : 'bg-[#FF5252]/10 text-[#FF5252] border border-[#FF5252]/30'
                      }`}>
                        {log.status === 'absent' ? 'ACCESS DENIED' : `AUTHORIZED - ${log.status}`}
                      </Badge>
                    </TableCell>
                  </TableRow>
                ))
              )}
            </TableBody>
          </Table>
        )}
      </Card>
    </div>
  );
}
