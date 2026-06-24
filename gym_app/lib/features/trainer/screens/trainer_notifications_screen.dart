import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/trainer_providers.dart';

class TrainerNotificationsScreen extends ConsumerStatefulWidget {
  const TrainerNotificationsScreen({super.key});

  @override
  ConsumerState<TrainerNotificationsScreen> createState() => _TrainerNotificationsScreenState();
}

class _TrainerNotificationsScreenState extends ConsumerState<TrainerNotificationsScreen> {
  final _messageController = TextEditingController();
  String _selectedType = 'Workout'; // 'Workout', 'Diet', 'Session'
  GymMember? _selectedMember;

  final Map<String, String> _templates = {
    'Workout': "Hey! Don't forget to complete your scheduled workout plan today! 💪",
    'Diet': "Time to log your meals. Keep those protein and calorie targets in check! 🥗",
    'Session': "Reminder: We have our personal training session scheduled in 15 minutes! 🏋️‍♂️",
  };

  @override
  void initState() {
    super.initState();
    _messageController.text = _templates[_selectedType]!;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  void _onTypeChanged(String? type) {
    if (type != null) {
      setState(() {
        _selectedType = type;
        _messageController.text = _templates[type]!;
      });
    }
  }

  void _dispatchNotification() {
    final members = ref.read(trainerMembersProvider);
    final member = _selectedMember ?? (members.isNotEmpty ? members.first : null);

    if (member == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No client selected to notify!'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    final message = _messageController.text.trim();
    if (message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification message cannot be empty.'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    ref.read(trainerNotificationsProvider.notifier).sendNotification(
          memberId: member.id,
          memberName: member.name,
          type: _selectedType,
          message: message,
        );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Reminder sent to ${member.name}!"),
        backgroundColor: AppColors.primaryGreen,
      ),
    );

    setState(() {
      _messageController.text = _templates[_selectedType]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final members = ref.watch(trainerMembersProvider);
    final notificationHistory = ref.watch(trainerNotificationsProvider);

    if (_selectedMember == null && members.isNotEmpty) {
      _selectedMember = members.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Client Reminders'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Notification Sender Card Form
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Dispatch New Reminder',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),

                    // Dropdown for selecting member
                    Text(
                      'Select Client',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (members.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkInput : AppColors.lightInput,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<GymMember>(
                            dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                            value: _selectedMember,
                            isExpanded: true,
                            items: members.map((m) {
                              return DropdownMenuItem<GymMember>(
                                value: m,
                                child: Text(m.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedMember = value;
                              });
                            },
                          ),
                        ),
                      ),

                    const SizedBox(height: 16),

                    // Dropdown for selecting type
                    Text(
                      'Reminder Type',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkInput : AppColors.lightInput,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                          value: _selectedType,
                          isExpanded: true,
                          items: ['Workout', 'Diet', 'Session'].map((type) {
                            return DropdownMenuItem<String>(
                              value: type,
                              child: Text('$type Reminder'),
                            );
                          }).toList(),
                          onChanged: _onTypeChanged,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // Message input field
                    Text(
                      'Notification Message',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 6),
                    CustomTextField(
                      hintText: 'Enter reminder text...',
                      controller: _messageController,
                    ),

                    const SizedBox(height: 24),

                    // Dispatch Button
                    CustomButton(
                      text: 'Send Reminder',
                      onPressed: _dispatchNotification,
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms),
              const SizedBox(height: 32),

              // Sent History
              Text(
                'Reminder Dispatch History',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              notificationHistory.isEmpty
                  ? Container(
                      padding: const EdgeInsets.all(24),
                      alignment: Alignment.center,
                      child: Text(
                        'No reminders sent today.',
                        style: theme.textTheme.bodyMedium,
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: notificationHistory.length,
                      separatorBuilder: (context, index) => Divider(
                        color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                        height: 24,
                      ),
                      itemBuilder: (context, index) {
                        final item = notificationHistory[index];
                        final timeStr = '${item.timestamp.hour.toString().padLeft(2, '0')}:${item.timestamp.minute.toString().padLeft(2, '0')}';
                        
                        Color tagColor;
                        IconData icon;
                        if (item.type == 'Workout') {
                          tagColor = AppColors.primaryGreen;
                          icon = Icons.fitness_center_rounded;
                        } else if (item.type == 'Diet') {
                          tagColor = AppColors.secondaryGreen;
                          icon = Icons.restaurant_rounded;
                        } else {
                          tagColor = AppColors.info;
                          icon = Icons.calendar_today_rounded;
                        }

                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: tagColor.withOpacity(0.1),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(icon, size: 16, color: tagColor),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'To: ${item.memberName}',
                                        style: theme.textTheme.bodyLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        timeStr,
                                        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    item.title,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontSize: 12,
                                      color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                                    ),
                                  ),
                                ],
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
}
