'use client';

import React, { useState } from 'react';
import { useQuery } from '@tanstack/react-query';
import { 
  IndianRupee, Landmark, HelpCircle, Receipt, ArrowUpRight, 
  ArrowDownRight, Loader2, Sparkles, AlertCircle, FileText
} from 'lucide-react';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Table, TableBody, TableCell, TableHead, TableHeader, TableRow } from '@/components/ui/table';
import { Badge } from '@/components/ui/badge';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { toast } from 'sonner';

const fetchPayments = async () => {
  const res = await fetch('/api/payments');
  if (!res.ok) throw new Error('Failed to load transaction logs');
  const data = await res.json();
  // Return dummy data if API is empty
  if (data.length === 0) {
    return [
      {
        id: 'INV-2026-001',
        memberId: 'MEM-001',
        memberName: 'Rahul Sharma',
        amount: 1999,
        date: new Date().toISOString().split('T')[0],
        type: 'Subscription Renewal',
        status: 'paid'
      },
      {
        id: 'INV-2026-002',
        memberId: 'MEM-002',
        memberName: 'Priya Patel',
        amount: 3499,
        date: new Date().toISOString().split('T')[0],
        type: 'Subscription Renewal',
        status: 'pending'
      },
      {
        id: 'INV-2026-003',
        memberId: 'MEM-003',
        memberName: 'Amit Kumar',
        amount: 999,
        date: new Date().toISOString().split('T')[0],
        type: 'Subscription Renewal',
        status: 'paid'
      }
    ];
  }
  return data;
};

export default function PaymentsPage() {
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  const { data: payments = [], isLoading } = useQuery<any[]>({
    queryKey: ['payments'],
    queryFn: fetchPayments
  });

  // Calculate billing summary stats
  const totalRevenue = payments.filter(p => p.status === 'paid').reduce((sum, p) => sum + p.amount, 0);
  const pendingRevenue = payments.filter(p => p.status === 'pending').reduce((sum, p) => sum + p.amount, 0);
  const failedRevenue = payments.filter(p => p.status === 'failed').reduce((sum, p) => sum + p.amount, 0);

  const filteredPayments = payments.filter(p => {
    const matchesSearch = 
      p.memberName.toLowerCase().includes(search.toLowerCase()) || 
      p.id.toLowerCase().includes(search.toLowerCase()) ||
      p.type.toLowerCase().includes(search.toLowerCase());
      
    const matchesStatus = statusFilter === 'all' || p.status === statusFilter;
    
    return matchesSearch && matchesStatus;
  });

  const printInvoice = (p: any) => {
    toast.success(`Opening print layout for invoice ${p.id}...`, {
      description: `Client: ${p.memberName} &bull; Amount: ₹${p.amount}`,
    });
  };

  return (
    <div className="p-6 md:p-8 space-y-6 bg-background min-h-full">
      {/* Header */}
      <div>
        <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
          REVENUE & <span className="text-[#7CE047]">PAYMENTS</span>
        </h1>
        <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
          Monitor subscription renewals, pending balances, transaction logs, and invoices.
        </p>
      </div>

      {/* Stats row */}
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
          <CardContent className="p-5 flex items-center justify-between">
            <div className="space-y-1">
              <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Gross Collections</span>
              <span className="text-3xl font-heading font-extrabold text-[#7CE047] block mt-1">₹{totalRevenue.toLocaleString()}</span>
            </div>
            <div className="w-10 h-10 rounded-lg bg-[#7CE047]/10 flex items-center justify-center text-[#7CE047]">
              <ArrowUpRight className="h-5 w-5" />
            </div>
          </CardContent>
        </Card>
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
          <CardContent className="p-5 flex items-center justify-between">
            <div className="space-y-1">
              <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Pending Balances</span>
              <span className="text-3xl font-heading font-extrabold text-[#FFC107] block mt-1">₹{pendingRevenue.toLocaleString()}</span>
            </div>
            <div className="w-10 h-10 rounded-lg bg-[#FFC107]/10 flex items-center justify-center text-[#FFC107]">
              <HelpCircle className="h-5 w-5" />
            </div>
          </CardContent>
        </Card>
        <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
          <CardContent className="p-5 flex items-center justify-between">
            <div className="space-y-1">
              <span className="text-[10px] font-bold text-[#8E9297] uppercase tracking-wider">Failed Transactions</span>
              <span className="text-3xl font-heading font-extrabold text-[#FF5252] block mt-1">₹{failedRevenue.toLocaleString()}</span>
            </div>
            <div className="w-10 h-10 rounded-lg bg-[#FF5252]/10 flex items-center justify-center text-[#FF5252]">
              <ArrowDownRight className="h-5 w-5" />
            </div>
          </CardContent>
        </Card>
      </div>

      {/* Search and filter toolbar */}
      <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
        <CardContent className="p-4 flex flex-col md:flex-row gap-4 items-center justify-between">
          <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
            <Input 
              value={search}
              onChange={(e) => setSearch(e.target.value)}
              placeholder="Search by invoice ID, client, type..." 
              className="bg-[#252930] border-[#2C3038] placeholder:text-[#8E9297]/50 rounded-xl w-72 shrink-0 text-xs"
            />

            <Select value={statusFilter} onValueChange={(val) => { if (val) setStatusFilter(val); }}>
              <SelectTrigger className="bg-[#252930] border-[#2C3038] w-36 rounded-xl text-xs">
                <SelectValue placeholder="Status" />
              </SelectTrigger>
              <SelectContent className="bg-[#1C1E22] border-[#2C3038] text-white">
                <SelectItem value="all">All statuses</SelectItem>
                <SelectItem value="paid">Paid</SelectItem>
                <SelectItem value="pending">Pending</SelectItem>
                <SelectItem value="failed">Failed</SelectItem>
              </SelectContent>
            </Select>
          </div>
        </CardContent>
      </Card>

      {/* Roster logs */}
      <Card className="bg-[#1C1E22] border-[#2C3038] text-white overflow-hidden">
        <CardHeader className="border-b border-[#2C3038] pb-4">
          <CardTitle className="font-heading text-lg font-bold uppercase tracking-wider text-white">Invoices Registry</CardTitle>
          <CardDescription className="text-xs text-[#8E9297]">Billing records of active memberships, plans, and coach assignments.</CardDescription>
        </CardHeader>
        {isLoading ? (
          <div className="flex items-center justify-center py-20">
            <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
          </div>
        ) : (
          <Table>
            <TableHeader className="bg-[#252930]/20">
              <TableRow className="border-[#2C3038]">
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Invoice ID</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Member Client</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Amount</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Description</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Billing Date</TableHead>
                <TableHead className="text-xs font-bold text-[#8E9297] uppercase tracking-wider">Status</TableHead>
                <TableHead className="text-right text-xs font-bold text-[#8E9297] uppercase tracking-wider">Receipt</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {filteredPayments.length === 0 ? (
                <TableRow>
                  <TableCell colSpan={7} className="text-center py-8 text-xs text-[#8E9297]">No payments history records found.</TableCell>
                </TableRow>
              ) : (
                filteredPayments.map((p) => (
                  <TableRow key={p.id} className="border-[#2C3038] hover:bg-[#252930]/10 transition-colors">
                    <TableCell className="font-mono text-xs text-white py-4">{p.id}</TableCell>
                    <TableCell className="font-bold text-white">{p.memberName}</TableCell>
                    <TableCell className="font-bold text-white">₹{p.amount}</TableCell>
                    <TableCell className="text-[#8E9297] text-xs font-medium">{p.type}</TableCell>
                    <TableCell className="text-[#8E9297] text-xs">{p.date}</TableCell>
                    <TableCell>
                      <Badge className={`rounded-xl px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
                        p.status === 'paid' 
                          ? 'bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30' 
                          : p.status === 'pending'
                            ? 'bg-[#FFC107]/10 text-[#FFC107] border border-[#FFC107]/30'
                            : 'bg-[#FF5252]/10 text-[#FF5252] border border-[#FF5252]/30'
                      }`}>
                        {p.status}
                      </Badge>
                    </TableCell>
                    <TableCell className="text-right">
                      <Button 
                        variant="ghost" 
                        size="icon" 
                        onClick={() => printInvoice(p)}
                        className="h-8 w-8 text-[#8E9297] hover:text-white rounded-xl"
                        title="Print Invoice"
                      >
                        <FileText className="h-4.5 w-4.5" />
                      </Button>
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
