'use client';

import React, { useState } from 'react';
import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { useRouter } from 'next/navigation';
import { useForm } from 'react-hook-form';
import { zodResolver } from '@hookform/resolvers/zod';
import * as z from 'zod';
import { 
  Users, Search, Plus, Filter, ArrowUpDown, ChevronLeft, ChevronRight, 
  MoreHorizontal, Eye, Edit2, ShieldAlert, Trash2, Download, Loader2, UserMinus
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Label } from '@/components/ui/label';
import { Badge } from '@/components/ui/badge';
import { Card, CardContent } from '@/components/ui/card';
import { Avatar, AvatarFallback, AvatarImage } from '@/components/ui/avatar';
import { Dialog, DialogContent, DialogDescription, DialogFooter, DialogHeader, DialogTitle, DialogTrigger } from '@/components/ui/dialog';
import { Select, SelectContent, SelectItem, SelectTrigger, SelectValue } from '@/components/ui/select';
import { DropdownMenu, DropdownMenuContent, DropdownMenuItem, DropdownMenuLabel, DropdownMenuSeparator, DropdownMenuTrigger } from '@/components/ui/dropdown-menu';
import { toast } from 'sonner';
import * as XLSX from 'xlsx';
import jsPDF from 'jspdf';
import 'jspdf-autotable';

// Zod schemas for validation
const memberFormSchema = z.object({
  name: z.string().min(2, 'Name must be at least 2 characters long'),
  email: z.string().email('Please enter a valid email address'),
  mobile: z.string().min(8, 'Please enter a valid phone number'),
  planId: z.string({ required_error: 'Please select a subscription plan' }),
  trainerId: z.string().optional(),
  currentWeight: z.string().min(1, 'Please enter weight'),
  bodyFat: z.string().min(1, 'Please enter body fat percentage'),
});

type MemberFormInputs = z.infer<typeof memberFormSchema>;

// API fetchers
const fetchMembers = async () => {
  const res = await fetch('/api/members');
  if (!res.ok) throw new Error('Failed to load members');
  return res.json();
};

const fetchTrainers = async () => {
  const res = await fetch('/api/trainers');
  if (!res.ok) throw new Error('Failed to load trainers');
  return res.json();
};

const fetchPlans = async () => {
  const res = await fetch('/api/plans');
  if (!res.ok) throw new Error('Failed to load plans');
  return res.json();
};

export default function MembersPage() {
  const queryClient = useQueryClient();
  const router = useRouter();

  // Dialog States
  const [isAddOpen, setIsAddOpen] = useState(false);
  const [isEditOpen, setIsEditOpen] = useState(false);
  const [selectedMember, setSelectedMember] = useState<any | null>(null);

  // Filters State
  const [search, setSearch] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [planFilter, setPlanFilter] = useState('all');
  const [sortBy, setSortBy] = useState('name');
  const [sortOrder, setSortOrder] = useState<'asc' | 'desc'>('asc');
  
  // Pagination
  const [page, setPage] = useState(1);
  const itemsPerPage = 8;

  // React Queries
  const { data: members = [], isLoading: loadingMembers } = useQuery<any[]>({ queryKey: ['members'], queryFn: fetchMembers });
  const { data: trainers = [] } = useQuery<any[]>({ queryKey: ['trainers'], queryFn: fetchTrainers });
  const { data: plans = [] } = useQuery<any[]>({ queryKey: ['plans'], queryFn: fetchPlans });

  // Add Member Form
  const { register: regAdd, handleSubmit: handleAddSubmit, reset: resetAdd, formState: { errors: errorsAdd } } = useForm<MemberFormInputs>({
    resolver: zodResolver(memberFormSchema)
  });

  // Edit Member Form
  const { register: regEdit, handleSubmit: handleEditSubmit, reset: resetEdit, setValue: setEditValue, formState: { errors: errorsEdit } } = useForm<MemberFormInputs>({
    resolver: zodResolver(memberFormSchema)
  });

  // Mutations
  const addMutation = useMutation({
    mutationFn: async (newMember: MemberFormInputs) => {
      const res = await fetch('/api/members', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(newMember)
      });
      if (!res.ok) throw new Error('Registration failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['members'] });
      queryClient.invalidateQueries({ queryKey: ['dashboard'] });
      toast.success('New Member Registered Successfully!');
      resetAdd();
      setIsAddOpen(false);
    },
    onError: (err: any) => {
      toast.error(err.message || 'Error occurred');
    }
  });

  const updateMutation = useMutation({
    mutationFn: async (updatedData: { id: string; data: MemberFormInputs }) => {
      const res = await fetch(`/api/members/${updatedData.id}`, {
        method: 'PUT',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(updatedData.data)
      });
      if (!res.ok) throw new Error('Update failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['members'] });
      toast.success('Member details updated!');
      setIsEditOpen(false);
    }
  });

  const toggleStatusMutation = useMutation({
    mutationFn: async ({ id, status }: { id: string; status: 'active' | 'suspended' }) => {
      const res = await fetch(`/api/members/${id}/status`, {
        method: 'PATCH',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ status })
      });
      if (!res.ok) throw new Error('Status change failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['members'] });
      toast.success('Member status changed successfully');
    }
  });

  const deleteMutation = useMutation({
    mutationFn: async (id: string) => {
      const res = await fetch(`/api/members/${id}`, { method: 'DELETE' });
      if (!res.ok) throw new Error('Deletion failed');
      return res.json();
    },
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['members'] });
      toast.success('Member removed from database');
    }
  });

  // Open Edit Dialog Helper
  const openEditDialog = (member: any) => {
    setSelectedMember(member);
    setEditValue('name', member.name);
    setEditValue('email', member.email);
    setEditValue('mobile', member.mobile);
    setEditValue('planId', member.planId);
    setEditValue('trainerId', member.trainerId);
    setEditValue('currentWeight', String(member.currentWeight));
    setEditValue('bodyFat', String(member.bodyFat));
    setIsEditOpen(true);
  };

  // Sort & Filter logic
  const handleSort = (field: string) => {
    if (sortBy === field) {
      setSortOrder(sortOrder === 'asc' ? 'desc' : 'asc');
    } else {
      setSortBy(field);
      setSortOrder('asc');
    }
  };

  const filteredMembers = members.filter(m => {
    const query = search.toLowerCase();
    const trainer = trainers.find(t => t.id === m.trainerId);
    const plan = plans.find(p => p.id === m.planId);
    
    const matchesSearch = 
      m.name.toLowerCase().includes(query) ||
      m.id.toLowerCase().includes(query) ||
      m.mobile.includes(query) ||
      (trainer && trainer.name.toLowerCase().includes(query)) ||
      (plan && plan.name.toLowerCase().includes(query));

    const matchesStatus = statusFilter === 'all' || m.status === statusFilter;
    const matchesPlan = planFilter === 'all' || m.planId === planFilter;

    return matchesSearch && matchesStatus && matchesPlan;
  }).sort((a, b) => {
    let fieldA = a[sortBy];
    let fieldB = b[sortBy];

    if (typeof fieldA === 'string') {
      fieldA = fieldA.toLowerCase();
      fieldB = fieldB.toLowerCase();
    }

    if (fieldA < fieldB) return sortOrder === 'asc' ? -1 : 1;
    if (fieldA > fieldB) return sortOrder === 'asc' ? 1 : -1;
    return 0;
  });

  // Pagination bounds
  const totalPages = Math.ceil(filteredMembers.length / itemsPerPage) || 1;
  const paginatedMembers = filteredMembers.slice((page - 1) * itemsPerPage, page * itemsPerPage);

  // Exports handlers
  const exportCSV = () => {
    const csvContent = "data:text/csv;charset=utf-8," 
      + ["Member ID,Name,Email,Mobile,Status,Plan,Weight(kg),Body Fat(%)"].join(",") + "\n"
      + filteredMembers.map(m => [m.id, m.name, m.email, m.mobile, m.status, m.planId, m.currentWeight, m.bodyFat].join(",")).join("\n");
    const encodedUri = encodeURI(csvContent);
    const link = document.createElement("a");
    link.setAttribute("href", encodedUri);
    link.setAttribute("download", "gym_members_report.csv");
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    toast.success('CSV Report Downloaded!');
  };

  const exportExcel = () => {
    const data = filteredMembers.map(m => ({
      'Member ID': m.id,
      'Name': m.name,
      'Email': m.email,
      'Mobile': m.mobile,
      'Status': m.status.toUpperCase(),
      'Join Date': m.joinDate,
      'Weight (kg)': m.currentWeight,
      'Body Fat (%)': m.bodyFat,
      'BMI': m.bmi,
      'Muscle Mass (kg)': m.muscleMass
    }));
    const worksheet = XLSX.utils.json_to_sheet(data);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Gym Members');
    XLSX.writeFile(workbook, 'gym_members_roster.xlsx');
    toast.success('Excel Spreadsheet Exported!');
  };

  const exportPDF = () => {
    const doc = new jsPDF();
    doc.text('GYM - Members Roster Report', 14, 15);
    (doc as any).autoTable({
      head: [['ID', 'Name', 'Mobile', 'Plan', 'Weight', 'Fat %', 'Status']],
      body: filteredMembers.map(m => [
        m.id, m.name, m.mobile, 
        plans.find(p => p.id === m.planId)?.name || m.planId,
        m.currentWeight + ' kg', m.bodyFat + ' %', m.status.toUpperCase()
      ]),
      startY: 20
    });
    doc.save('gym_members_report.pdf');
    toast.success('PDF Document Saved!');
  };

  return (
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
      {/* Header and Add Trigger */}
      <div className="flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
        <div>
          <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
            MEMBERS <span className="text-[#7CE047]">DIRECTORY</span>
          </h1>
          <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
            Browse profile measurements, statuses, billing plans, and coach assignments.
          </p>
        </div>

        <Dialog open={isAddOpen} onOpenChange={setIsAddOpen}>
          <DialogTrigger asChild>
            <Button className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] font-bold text-xs uppercase tracking-wider rounded-xl gap-2 px-5 h-11">
              <Plus className="h-4 w-4" /> Add Member
            </Button>
          </DialogTrigger>
          <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-lg">
            <DialogHeader>
              <DialogTitle className="font-heading text-xl font-bold tracking-wide uppercase text-white">
                Register New Member
              </DialogTitle>
              <DialogDescription className="text-xs text-[#8E9297]">
                Enter basic parameters. An initial invoice will be generated automatically.
              </DialogDescription>
            </DialogHeader>
            <form onSubmit={handleAddSubmit((data) => addMutation.mutate(data))} className="space-y-4 pt-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Full Name</Label>
                  <Input {...regAdd('name')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. John Doe" />
                  {errorsAdd.name && <p className="text-[10px] text-red-500">{errorsAdd.name.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Email Address</Label>
                  <Input {...regAdd('email')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. john@doe.com" />
                  {errorsAdd.email && <p className="text-[10px] text-red-500">{errorsAdd.email.message}</p>}
                </div>
              </div>
              
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Mobile Number</Label>
                  <Input {...regAdd('mobile')} className="bg-[#252930] border-[#2C3038]" placeholder="e.g. +1 555-1234" />
                  {errorsAdd.mobile && <p className="text-[10px] text-red-500">{errorsAdd.mobile.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Subscription Plan</Label>
                  <select {...regAdd('planId')} className="w-full bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none">
                    <option value="">Select Plan</option>
                    {plans.map(p => <option key={p.id} value={p.id}>{p.name} (${p.price})</option>)}
                  </select>
                  {errorsAdd.planId && <p className="text-[10px] text-red-500">{errorsAdd.planId.message}</p>}
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Assign Trainer (Optional)</Label>
                  <select {...regAdd('trainerId')} className="w-full bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none">
                    <option value="">None (Self-Training)</option>
                    {trainers.map(t => <option key={t.id} value={t.id}>{t.name}</option>)}
                  </select>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div className="space-y-1.5">
                    <Label className="text-xs text-[#8E9297]">Weight (kg)</Label>
                    <Input {...regAdd('currentWeight')} type="number" step="0.1" className="bg-[#252930] border-[#2C3038]" placeholder="75" />
                  </div>
                  <div className="space-y-1.5">
                    <Label className="text-xs text-[#8E9297]">Body Fat %</Label>
                    <Input {...regAdd('bodyFat')} type="number" step="0.1" className="bg-[#252930] border-[#2C3038]" placeholder="18" />
                  </div>
                </div>
              </div>

              <DialogFooter className="pt-4 border-t border-[#2C3038]">
                <Button type="button" variant="ghost" onClick={() => setIsAddOpen(false)} className="text-[#8E9297] rounded-xl">Cancel</Button>
                <Button type="submit" disabled={addMutation.isPending} className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] rounded-xl font-bold uppercase text-xs">
                  {addMutation.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />} Save Member
                </Button>
              </DialogFooter>
            </form>
          </DialogContent>
        </Dialog>
      </div>

      {/* Filter and Action Bar */}
      <Card className="bg-[#1C1E22] border-[#2C3038] text-white">
        <CardContent className="p-4 flex flex-col md:flex-row gap-4 items-center justify-between">
          <div className="flex flex-wrap items-center gap-3 w-full md:w-auto">
            {/* Search Input */}
            <div className="relative flex-1 md:w-72 shrink-0">
              <Search className="absolute left-3 top-3 h-4 w-4 text-[#8E9297]" />
              <Input 
                value={search}
                onChange={(e) => { setSearch(e.target.value); setPage(1); }}
                placeholder="Search by name, ID, trainer, plan..." 
                className="pl-9 bg-[#252930] border-[#2C3038] placeholder:text-[#8E9297]/50 rounded-xl"
              />
            </div>

            {/* Status Filter */}
            <Select value={statusFilter} onValueChange={(val) => { setStatusFilter(val); setPage(1); }}>
              <SelectTrigger className="bg-[#252930] border-[#2C3038] w-36 rounded-xl">
                <SelectValue placeholder="Status" />
              </SelectTrigger>
              <SelectContent className="bg-[#1C1E22] border-[#2C3038] text-white">
                <SelectItem value="all">All Statuses</SelectItem>
                <SelectItem value="active">Active</SelectItem>
                <SelectItem value="suspended">Suspended</SelectItem>
              </SelectContent>
            </Select>

            {/* Plan Filter */}
            <Select value={planFilter} onValueChange={(val) => { setPlanFilter(val); setPage(1); }}>
              <SelectTrigger className="bg-[#252930] border-[#2C3038] w-40 rounded-xl">
                <SelectValue placeholder="Membership Plan" />
              </SelectTrigger>
              <SelectContent className="bg-[#1C1E22] border-[#2C3038] text-white">
                <SelectItem value="all">All Plans</SelectItem>
                {plans.map(p => <SelectItem key={p.id} value={p.id}>{p.name}</SelectItem>)}
              </SelectContent>
            </Select>
          </div>

          {/* Export Buttons */}
          <div className="flex items-center gap-2 w-full md:w-auto justify-end">
            <DropdownMenu>
              <DropdownMenuTrigger asChild>
                <Button variant="outline" className="bg-[#252930] border-[#2C3038] hover:bg-[#2C3038] rounded-xl text-xs gap-2">
                  <Download className="h-4 w-4" /> Export Report
                </Button>
              </DropdownMenuTrigger>
              <DropdownMenuContent className="bg-[#1C1E22] border-[#2C3038] text-white">
                <DropdownMenuLabel>Choose Format</DropdownMenuLabel>
                <DropdownMenuSeparator className="bg-[#2C3038]" />
                <DropdownMenuItem className="hover:bg-[#252930]" onClick={exportCSV}>CSV File</DropdownMenuItem>
                <DropdownMenuItem className="hover:bg-[#252930]" onClick={exportExcel}>Excel Sheet</DropdownMenuItem>
                <DropdownMenuItem className="hover:bg-[#252930]" onClick={exportPDF}>PDF Document</DropdownMenuItem>
              </DropdownMenuContent>
            </DropdownMenu>
          </div>
        </CardContent>
      </Card>

      {/* Main Members Data Table */}
      <Card className="bg-[#1C1E22] border-[#2C3038] text-white overflow-hidden">
        {loadingMembers ? (
          <div className="flex items-center justify-center py-20">
            <Loader2 className="h-8 w-8 text-[#7CE047] animate-spin" />
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="w-full border-collapse">
              <thead>
                <tr className="border-b border-[#2C3038] bg-[#252930]/20">
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">
                    <button className="flex items-center gap-1.5" onClick={() => handleSort('id')}>
                      Member ID {sortBy === 'id' && <ArrowUpDown className="h-3 w-3" />}
                    </button>
                  </th>
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">Info</th>
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">Mobile</th>
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">Trainer</th>
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">Plan</th>
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">Weight</th>
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">Body Fat</th>
                  <th className="p-4 text-left text-xs font-bold text-[#8E9297] uppercase tracking-wider">Status</th>
                  <th className="p-4 text-right text-xs font-bold text-[#8E9297] uppercase tracking-wider">Actions</th>
                </tr>
              </thead>
              <tbody>
                {paginatedMembers.length === 0 ? (
                  <tr>
                    <td colSpan={9} className="p-12 text-center text-xs text-[#8E9297]">
                      No gym members found matching the active search parameters.
                    </td>
                  </tr>
                ) : (
                  paginatedMembers.map((member) => {
                    const trainer = trainers.find(t => t.id === member.trainerId);
                    const plan = plans.find(p => p.id === member.planId);
                    
                    return (
                      <tr key={member.id} className="border-b border-[#2C3038] hover:bg-[#252930]/10 transition-colors">
                        <td className="p-4 font-mono text-xs text-white">{member.id}</td>
                        <td className="p-4">
                          <div className="flex items-center gap-3">
                            <Avatar className="h-10 w-10 border border-[#2C3038]">
                              <AvatarImage src={member.avatarUrl} alt={member.name} />
                              <AvatarFallback>{member.name[0]}</AvatarFallback>
                            </Avatar>
                            <div className="flex flex-col">
                              <span className="text-sm font-bold text-white leading-snug">{member.name}</span>
                              <span className="text-[10px] text-[#8E9297] font-medium leading-none mt-0.5">{member.email}</span>
                            </div>
                          </div>
                        </td>
                        <td className="p-4 text-xs font-medium text-white">{member.mobile}</td>
                        <td className="p-4 text-xs font-semibold text-[#8E9297]">
                          {trainer ? trainer.name : 'Self Training'}
                        </td>
                        <td className="p-4 text-xs font-semibold text-white">
                          {plan ? plan.name : member.planId}
                        </td>
                        <td className="p-4 text-xs font-bold text-white">{member.currentWeight} kg</td>
                        <td className="p-4 text-xs font-bold text-[#FF5252]">{member.bodyFat}%</td>
                        <td className="p-4">
                          <Badge className={`rounded-xl px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider ${
                            member.status === 'active' ? 'bg-[#7CE047]/10 text-[#7CE047] border border-[#7CE047]/30' : 'bg-[#FF5252]/10 text-[#FF5252] border border-[#FF5252]/30'
                          }`}>
                            {member.status}
                          </Badge>
                        </td>
                        <td className="p-4 text-right">
                          <DropdownMenu>
                            <DropdownMenuTrigger asChild>
                              <Button variant="ghost" size="icon" className="h-8 w-8 text-[#8E9297] hover:text-white rounded-xl">
                                <MoreHorizontal className="h-4.5 w-4.5" />
                              </Button>
                            </DropdownMenuTrigger>
                            <DropdownMenuContent className="bg-[#1C1E22] border-[#2C3038] text-white align-end">
                              <DropdownMenuItem className="hover:bg-[#252930] gap-2" onClick={() => router.push(`/dashboard/members/${member.id}`)}>
                                <Eye className="h-4 w-4" /> View Profile
                              </DropdownMenuItem>
                              <DropdownMenuItem className="hover:bg-[#252930] gap-2" onClick={() => openEditDialog(member)}>
                                <Edit2 className="h-4 w-4" /> Edit Profile
                              </DropdownMenuItem>
                              <DropdownMenuItem 
                                className="hover:bg-[#252930] gap-2" 
                                onClick={() => toggleStatusMutation.mutate({
                                  id: member.id,
                                  status: member.status === 'active' ? 'suspended' : 'active'
                                })}
                              >
                                <UserMinus className="h-4 w-4" /> {member.status === 'active' ? 'Suspend' : 'Activate'}
                              </DropdownMenuItem>
                              <DropdownMenuSeparator className="bg-[#2C3038]" />
                              <DropdownMenuItem className="text-[#FF5252] hover:bg-[#FF5252]/10 gap-2" onClick={() => {
                                if (confirm(`Are you sure you want to delete ${member.name}?`)) {
                                  deleteMutation.mutate(member.id);
                                }
                              }}>
                                <Trash2 className="h-4 w-4" /> Delete Roster
                              </DropdownMenuItem>
                            </DropdownMenuContent>
                          </DropdownMenu>
                        </td>
                      </tr>
                    );
                  })
                )}
              </tbody>
            </table>
          </div>
        )}

        {/* Pagination Toolbar */}
        <div className="p-4 border-t border-[#2C3038] flex items-center justify-between bg-[#1C1E22]/50">
          <span className="text-xs text-[#8E9297] font-semibold">
            Showing Page {page} of {totalPages} &bull; Total Roster: {filteredMembers.length}
          </span>
          <div className="flex items-center gap-2">
            <Button 
              variant="outline" 
              size="sm" 
              disabled={page === 1}
              onClick={() => setPage(page - 1)}
              className="bg-[#252930] border-[#2C3038] hover:bg-[#2C3038] rounded-xl"
            >
              <ChevronLeft className="h-4 w-4" /> Previous
            </Button>
            <Button 
              variant="outline" 
              size="sm" 
              disabled={page === totalPages}
              onClick={() => setPage(page + 1)}
              className="bg-[#252930] border-[#2C3038] hover:bg-[#2C3038] rounded-xl"
            >
              Next <ChevronRight className="h-4 w-4" />
            </Button>
          </div>
        </div>
      </Card>

      {/* Edit Member Modal */}
      <Dialog open={isEditOpen} onOpenChange={setIsEditOpen}>
        <DialogContent className="bg-[#1C1E22] border-[#2C3038] text-white rounded-2xl max-w-lg">
          <DialogHeader>
            <DialogTitle className="font-heading text-xl font-bold tracking-wide uppercase text-white">
              Edit Member Profile
            </DialogTitle>
            <DialogDescription className="text-xs text-[#8E9297]">
              Adjust personal credentials or physical measurements.
            </DialogDescription>
          </DialogHeader>
          {selectedMember && (
            <form onSubmit={handleEditSubmit((data) => updateMutation.mutate({ id: selectedMember.id, data }))} className="space-y-4 pt-4">
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Full Name</Label>
                  <Input {...regEdit('name')} className="bg-[#252930] border-[#2C3038]" />
                  {errorsEdit.name && <p className="text-[10px] text-red-500">{errorsEdit.name.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Email Address</Label>
                  <Input {...regEdit('email')} className="bg-[#252930] border-[#2C3038]" />
                  {errorsEdit.email && <p className="text-[10px] text-red-500">{errorsEdit.email.message}</p>}
                </div>
              </div>
              
              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Mobile Number</Label>
                  <Input {...regEdit('mobile')} className="bg-[#252930] border-[#2C3038]" />
                  {errorsEdit.mobile && <p className="text-[10px] text-red-500">{errorsEdit.mobile.message}</p>}
                </div>
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Subscription Plan</Label>
                  <select {...regEdit('planId')} className="w-full bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none">
                    {plans.map(p => <option key={p.id} value={p.id}>{p.name}</option>)}
                  </select>
                </div>
              </div>

              <div className="grid grid-cols-2 gap-4">
                <div className="space-y-1.5">
                  <Label className="text-xs text-[#8E9297]">Assign Trainer</Label>
                  <select {...regEdit('trainerId')} className="w-full bg-[#252930] border border-[#2C3038] text-sm text-white rounded-md p-2 outline-none">
                    <option value="">None (Self-Training)</option>
                    {trainers.map(t => <option key={t.id} value={t.id}>{t.name}</option>)}
                  </select>
                </div>
                <div className="grid grid-cols-2 gap-2">
                  <div className="space-y-1.5">
                    <Label className="text-xs text-[#8E9297]">Weight (kg)</Label>
                    <Input {...regEdit('currentWeight')} type="number" step="0.1" className="bg-[#252930] border-[#2C3038]" />
                  </div>
                  <div className="space-y-1.5">
                    <Label className="text-xs text-[#8E9297]">Body Fat %</Label>
                    <Input {...regEdit('bodyFat')} type="number" step="0.1" className="bg-[#252930] border-[#2C3038]" />
                  </div>
                </div>
              </div>

              <DialogFooter className="pt-4 border-t border-[#2C3038]">
                <Button type="button" variant="ghost" onClick={() => setIsEditOpen(false)} className="text-[#8E9297] rounded-xl">Cancel</Button>
                <Button type="submit" disabled={updateMutation.isPending} className="bg-[#7CE047] hover:bg-[#6bd039] text-[#0E0F12] rounded-xl font-bold uppercase text-xs">
                  {updateMutation.isPending && <Loader2 className="mr-2 h-4 w-4 animate-spin" />} Save Changes
                </Button>
              </DialogFooter>
            </form>
          )}
        </DialogContent>
      </Dialog>

    </div>
  );
}
