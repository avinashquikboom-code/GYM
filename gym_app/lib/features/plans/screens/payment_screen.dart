import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../providers/plans_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  final String planName;
  final String price;

  const PaymentScreen({
    super.key,
    required this.planName,
    required this.price,
  });

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  bool _saveCard = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  void _processPayment() {
    final plansNotifier = ref.read(plansProvider.notifier);
    plansNotifier.selectPlan(widget.planName);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Payment successful! Subscribed to ${widget.planName}'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: isDark ? Colors.white : Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Payment',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ).animate().fade(duration: 300.ms),

              const SizedBox(height: 24),

              // Plan Summary Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.colorScheme.primary.withOpacity(0.2),
                      theme.colorScheme.primary.withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.workspace_premium,
                        color: theme.colorScheme.primary,
                        size: 32,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.planName,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.price,
                            style: theme.textTheme.bodyLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 32),

              // Payment Methods
              Text(
                'Payment Method',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ).animate().fade(duration: 500.ms),

              const SizedBox(height: 16),

              // Payment Method Options
              Row(
                children: [
                  _buildPaymentMethod(
                    context,
                    icon: Icons.credit_card,
                    label: 'Card',
                    isSelected: true,
                  ),
                  const SizedBox(width: 12),
                  _buildPaymentMethod(
                    context,
                    icon: Icons.account_balance_wallet,
                    label: 'UPI',
                    isSelected: false,
                  ),
                  const SizedBox(width: 12),
                  _buildPaymentMethod(
                    context,
                    icon: Icons.payment,
                    label: 'Net Banking',
                    isSelected: false,
                  ),
                ],
              ).animate().fade(duration: 600.ms),

              const SizedBox(height: 24),

              // Card Details Form
              Text(
                'Card Details',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ).animate().fade(duration: 700.ms),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Card Number',
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                prefixIcon: Icon(Icons.credit_card),
              ).animate().fade(duration: 800.ms),

              const SizedBox(height: 12),

              CustomTextField(
                hintText: 'Card Holder Name',
                controller: _cardHolderController,
                prefixIcon: Icon(Icons.person),
              ).animate().fade(duration: 900.ms),

              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'MM/YY',
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      hintText: 'CVV',
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(Icons.lock),
                      isPassword: true,
                    ),
                  ),
                ],
              ).animate().fade(duration: 1000.ms),

              const SizedBox(height: 16),

              // Save Card Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _saveCard,
                    onChanged: (value) {
                      setState(() => _saveCard = value ?? false);
                    },
                    fillColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return theme.colorScheme.primary;
                      }
                      return Colors.grey;
                    }),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Save card for future payments',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ).animate().fade(duration: 1100.ms),

              const SizedBox(height: 24),

              // Pay Button
              CustomButton(
                text: 'Pay ${widget.price}',
                onPressed: _processPayment,
              ).animate().fade(duration: 1200.ms),

              const SizedBox(height: 16),

              // Secure Payment Note
              Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.lock,
                      size: 16,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Secure Payment',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 1300.ms),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withOpacity(0.15)
              : (isDark ? AppColors.darkSurface : AppColors.lightSurface),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? theme.colorScheme.primary
                : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? theme.colorScheme.primary : Colors.grey,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: isSelected ? theme.colorScheme.primary : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
