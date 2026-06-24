'use client';

import React from 'react';
import { useQuery } from '@tanstack/react-query';
import { 
  BarChart3, FileSpreadsheet, FileText, Download, Loader2, 
  Users, CalendarDays, DollarSign, Award, Activity 
} from 'lucide-react';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { toast } from 'sonner';
import * as XLSX from 'xlsx';
import jsPDF from 'jspdf';
import 'jspdf-autotable';

const fetchMembers = async () => {
  const res = await fetch('/api/members');
  return res.json();
};

const fetchTrainers = async () => {
  const res = await fetch('/api/trainers');
  return res.json();
};

const fetchAttendance = async () => {
  const res = await fetch('/api/attendance');
  return res.json();
};

const fetchPayments = async () => {
  const res = await fetch('/api/payments');
  return res.json();
};

export default function ReportsPage() {
  const { data: members = [], isLoading: loadingMembers } = useQuery<any[]>({ queryKey: ['members'], queryFn: fetchMembers });
  const { data: trainers = [], isLoading: loadingTrainers } = useQuery<any[]>({ queryKey: ['trainers'], queryFn: fetchTrainers });
  const { data: attendance = [], isLoading: loadingAttendance } = useQuery<any[]>({ queryKey: ['attendance'], queryFn: fetchAttendance });
  const { data: payments = [], isLoading: loadingPayments } = useQuery<any[]>({ queryKey: ['payments'], queryFn: fetchPayments });

  const exportExcel = (type: string) => {
    let data: any[] = [];
    let filename = 'gym_report.xlsx';

    switch (type) {
      case 'members':
        data = members.map(m => ({ ID: m.id, Name: m.name, Email: m.email, Mobile: m.mobile, Status: m.status, Weight: m.currentWeight }));
        filename = 'gym_members_report.xlsx';
        break;
      case 'attendance':
        data = attendance.map(a => ({ ID: a.id, Name: a.name, Time: a.time, Date: a.date, Gate: a.gate, Status: a.status }));
        filename = 'gym_attendance_report.xlsx';
        break;
      case 'revenue':
        data = payments.map(p => ({ InvoiceID: p.id, Client: p.memberName, Amount: p.amount, Date: p.date, Type: p.type, Status: p.status }));
        filename = 'gym_revenue_report.xlsx';
        break;
      case 'trainers':
        data = trainers.map(t => ({ ID: t.id, Name: t.name, Experience: t.experience, Rating: t.rating, SuccessRate: `${t.successRate}%` }));
        filename = 'gym_trainers_report.xlsx';
        break;
      default:
        toast.error('Invalid report type selected');
        return;
    }

    const worksheet = XLSX.utils.json_to_sheet(data);
    const workbook = XLSX.utils.book_new();
    XLSX.utils.book_append_sheet(workbook, worksheet, 'Report');
    XLSX.writeFile(workbook, filename);
    toast.success('Spreadsheet compiled and downloaded!');
  };

  const exportPDF = (type: string) => {
    const doc = new jsPDF();
    let title = 'Gym Report';
    let headers: string[][] = [];
    let body: string[][] = [];
    let filename = 'gym_report.pdf';

    switch (type) {
      case 'members':
        title = 'Gym Members Roster Summary';
        headers = [['Member ID', 'Name', 'Email', 'Mobile', 'Status']];
        body = members.map(m => [m.id, m.name, m.email, m.mobile, m.status.toUpperCase()]);
        filename = 'gym_members_roster.pdf';
        break;
      case 'attendance':
        title = 'Gym Check-in Gate Attendance Log';
        headers = [['ID', 'Name', 'Time', 'Date', 'Status']];
        body = attendance.map(a => [a.id, a.name, a.time, a.date, a.status.toUpperCase()]);
        filename = 'gym_attendance_report.pdf';
        break;
      case 'revenue':
        title = 'Gym Revenue and Invoices Log';
        headers = [['Invoice ID', 'Client Name', 'Amount', 'Date', 'Status']];
        body = payments.map(p => [p.id, p.memberName, `$${p.amount}`, p.date, p.status.toUpperCase()]);
        filename = 'gym_revenue_report.pdf';
        break;
      case 'trainers':
        title = 'Gym Personal Trainers Directory';
        headers = [['ID', 'Trainer Name', 'Experience', 'Rating', 'Success Rate']];
        body = trainers.map(t => [t.id, t.name, `${t.experience} Years`, String(t.rating), `${t.successRate}%`]);
        filename = 'gym_trainers_directory.pdf';
        break;
      default:
        toast.error('Invalid report type selected');
        return;
    }

    doc.text(title, 14, 15);
    (doc as any).autoTable({
      head: headers,
      body: body,
      startY: 20
    });
    doc.save(filename);
    toast.success('PDF Document generated and downloaded!');
  };

  const reportsList = [
    { type: 'members', title: 'Member Roster Reports', desc: 'Complete listings of client details, weight, and plans.', icon: Users },
    { type: 'attendance', title: 'Attendance Log Reports', desc: 'Scan gate logins, on-time, and check-in volumes.', icon: CalendarDays },
    { type: 'revenue', title: 'Revenue Billings Reports', desc: 'Summary of paid and pending membership transactions.', icon: DollarSign },
    { type: 'trainers', title: 'Trainer Coaching Reports', desc: 'Coach ratings, rosters, and success percentages.', icon: Award },
  ];

  return (
    <div className="p-6 md:p-8 space-y-6 bg-[#0E0F12] min-h-full">
      {/* Header */}
      <div>
        <h1 className="font-heading text-3xl font-extrabold tracking-wider text-white uppercase">
          REPORTS & <span className="text-[#7CE047]">EXPORTS</span>
        </h1>
        <p className="text-xs text-[#8E9297] font-medium tracking-wide mt-1">
          Compile telemetry database records and export files to Excel or PDF layouts.
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 gap-6">
        {reportsList.map((rep) => {
          const IconComponent = rep.icon;
          return (
            <Card key={rep.type} className="bg-[#1C1E22] border-[#2C3038] hover:border-[#7CE047]/30 transition-all duration-300 relative group overflow-hidden">
              <div className="absolute top-0 left-0 right-0 h-[2px] bg-[#2C3038] group-hover:bg-[#7CE047] transition-all" />
              <CardHeader className="flex flex-row items-center gap-4 pt-6 pb-2">
                <div className="w-10 h-10 rounded-xl bg-[#252930] border border-[#2C3038] flex items-center justify-center text-[#7CE047] shrink-0">
                  <IconComponent className="h-5 w-5" />
                </div>
                <div>
                  <CardTitle className="font-heading text-base font-bold uppercase tracking-wider text-white">{rep.title}</CardTitle>
                  <CardDescription className="text-xs text-[#8E9297] mt-0.5">{rep.desc}</CardDescription>
                </div>
              </CardHeader>
              <CardContent className="pt-4 border-t border-[#2C3038]/50 flex gap-3">
                <Button 
                  onClick={() => exportExcel(rep.type)}
                  className="w-full bg-[#252930] hover:bg-[#2C3038] text-white text-xs font-bold uppercase tracking-wider h-10 rounded-xl border border-[#2C3038]"
                >
                  <FileSpreadsheet className="h-4 w-4 mr-2 text-[#7CE047]" /> Excel Sheet
                </Button>
                <Button 
                  onClick={() => exportPDF(rep.type)}
                  className="w-full bg-[#252930] hover:bg-[#2C3038] text-white text-xs font-bold uppercase tracking-wider h-10 rounded-xl border border-[#2C3038]"
                >
                  <FileText className="h-4 w-4 mr-2 text-red-500" /> PDF Document
                </Button>
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
