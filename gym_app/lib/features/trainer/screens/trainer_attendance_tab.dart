import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../providers/trainer_providers.dart';

class TrainerAttendanceTab extends ConsumerStatefulWidget {
  const TrainerAttendanceTab({super.key});

  @override
  ConsumerState<TrainerAttendanceTab> createState() => _TrainerAttendanceTabState();
}

class _TrainerAttendanceTabState extends ConsumerState<TrainerAttendanceTab> with SingleTickerProviderStateMixin {
  AnimationController? _scanAnimController;

  @override
  void initState() {
    super.initState();
    _scanAnimController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanAnimController?.dispose();
    super.dispose();
  }

  void _showQRScannerSimulator(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final members = ref.read(trainerMembersProvider);
    final attendance = ref.read(trainerAttendanceProvider);

    // Filter members who are not Present/Late yet (Pending check-in)
    final pendingMembers = attendance
        .where((r) => r.status == 'Pending')
        .map((r) => members.firstWhere((m) => m.id == r.memberId))
        .toList();

    showDialog(
      context: context,
      builder: (context) {
        GymMember? selectedMember = pendingMembers.isNotEmpty ? pendingMembers.first : null;

        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'QR Check-In Scanner',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Simulate scanning member QR Pass',
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 24),

                    // Camera Scanner Frame simulation
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primaryGreen, width: 2),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Animated scan bar
                          AnimatedBuilder(
                            animation: _scanAnimController!,
                            builder: (context, child) {
                              return Positioned(
                                top: 20 + (_scanAnimController!.value * 160),
                                left: 10,
                                right: 10,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryGreen,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryGreen.withOpacity(0.8),
                                        blurRadius: 8,
                                        spreadRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          // QR Code icon representing active scan
                          Icon(
                            Icons.qr_code_2_rounded,
                            size: 100,
                            color: Colors.white.withOpacity(0.15),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    if (pendingMembers.isEmpty)
                      const Text(
                        'All members checked in for today!',
                        style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                      )
                    else ...[
                      // Dropdown to select member to simulate
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkInput : AppColors.lightInput,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<GymMember>(
                            dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            value: selectedMember,
                            items: pendingMembers.map((m) {
                              return DropdownMenuItem<GymMember>(
                                value: m,
                                child: Text(m.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setStateDialog(() {
                                selectedMember = value;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              text: 'Present',
                              onPressed: () {
                                if (selectedMember != null) {
                                  ref.read(trainerAttendanceProvider.notifier).validateCheckIn(
                                        selectedMember!.id,
                                        'Present',
                                      );
                                  Navigator.pop(context);
                                  _showCheckinSuccessNotification(context, selectedMember!.name, 'Present');
                                }
                              },
                              height: 44,
                              borderRadius: 12,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CustomButton(
                              text: 'Late',
                              backgroundColor: AppColors.warning,
                              textColor: Colors.black,
                              onPressed: () {
                                if (selectedMember != null) {
                                  ref.read(trainerAttendanceProvider.notifier).validateCheckIn(
                                        selectedMember!.id,
                                        'Late',
                                      );
                                  Navigator.pop(context);
                                  _showCheckinSuccessNotification(context, selectedMember!.name, 'Late');
                                }
                              },
                              height: 44,
                              borderRadius: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showCheckinSuccessNotification(BuildContext context, String name, String status) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.black),
            const SizedBox(width: 8),
            Text(
              "Pass Scanned: $name marked $status!",
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: status == 'Late' ? AppColors.warning : AppColors.primaryGreen,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final records = ref.watch(trainerAttendanceProvider);

    final presentCount = records.where((r) => r.status == 'Present').length;
    final lateCount = records.where((r) => r.status == 'Late').length;
    final absentCount = records.where((r) => r.status == 'Absent').length;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Attendance Validator',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Statistics Row
              Row(
                children: [
                  Expanded(
                    child: _buildStatItem(context, 'Present', '$presentCount', AppColors.success),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(context, 'Late', '$lateCount', AppColors.warning),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildStatItem(context, 'Absent', '$absentCount', AppColors.error),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Scanner Trigger Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isDark ? AppColors.darkDivider : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.qr_code_scanner_rounded,
                      size: 48,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'QR Scanner Validation',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Scan active member passes instantly to validate entry check-in status.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: 'Launch Scanner',
                      onPressed: () => _showQRScannerSimulator(context),
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms),
              const SizedBox(height: 28),

              // Today's Checkin log list
              Text(
                "Today's Check-In Log",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: records.length,
                separatorBuilder: (context, index) => Divider(
                  color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                  height: 20,
                ),
                itemBuilder: (context, index) {
                  final record = records[index];

                  Color statusColor;
                  if (record.status == 'Present') {
                    statusColor = AppColors.success;
                  } else if (record.status == 'Late') {
                    statusColor = AppColors.warning;
                  } else if (record.status == 'Absent') {
                    statusColor = AppColors.error;
                  } else {
                    statusColor = Colors.grey;
                  }

                  return Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(record.avatarUrl),
                        radius: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              record.memberName,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              record.time ?? 'Not checked in',
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          record.status,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ).animate().fade(duration: 500.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String count, Color color) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.darkDivider : Colors.transparent,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            count,
            style: theme.textTheme.titleLarge?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
