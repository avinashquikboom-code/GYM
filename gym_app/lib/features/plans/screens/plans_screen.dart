import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/plan_toggle_button.dart';
import '../providers/plans_provider.dart';
import '../widgets/plan_card.dart';
import 'payment_screen.dart';

class PlansScreen extends ConsumerStatefulWidget {
  const PlansScreen({super.key});

  @override
  ConsumerState<PlansScreen> createState() => _PlansScreenState();
}

class _PlansScreenState extends ConsumerState<PlansScreen> {
  late PageController _pageController;
  int _currentPageIndex = 1; // Standard Plan pre-selected/centered

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentPageIndex,
      viewportFraction: 0.85,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final plansState = ref.watch(plansProvider);
    final plansNotifier = ref.read(plansProvider.notifier);

    // List of plans with pricing and features
    final planItems = [
      {
        'title': 'Basic Plan',
        'price': plansState.selectedPeriodIndex == 0 ? '₹999' : '₹2,699',
        'isPopular': false,
        'features': [
          'Gym Access (Standard Hours)',
          'Basic Workout Plan',
          'Diet Plan (Basic)',
          '1 Personal Training Session/month',
          'Locker Room Access'
        ],
      },
      {
        'title': 'Standard Plan',
        'price': plansState.selectedPeriodIndex == 0 ? '₹1,499' : '₹3,999',
        'isPopular': false,
        'features': [
          'Gym Access (Anytime)',
          'Advanced Workout Plan',
          'Diet Plan (Advanced)',
          '2 Personal Training Sessions/month',
          'Locker Room & Steam Bath Access',
          'Free WiFi & Beverage'
        ],
      },
      {
        'title': 'Premium Plan',
        'price': plansState.selectedPeriodIndex == 0 ? '₹2,499' : '₹6,799',
        'isPopular': true,
        'features': [
          'Gym Access (Anytime & Priority)',
          'Custom Workout Plan',
          'Diet Plan (Premium Custom)',
          '5 Personal Training Sessions/month',
          'Spa, Sauna & Steam Room Access',
          '1-on-1 Nutrition Counseling Session',
          'Complimentary Workout Kit'
        ],
      },
    ];

    final hasActivePlan = plansState.activePlan.isNotEmpty;
    final activePlanCost = plansState.activePlan == 'Premium Plan'
        ? (plansState.selectedPeriodIndex == 0 ? '₹2,499' : '₹6,799')
        : (plansState.activePlan == 'Standard Plan'
            ? (plansState.selectedPeriodIndex == 0 ? '₹1,499' : '₹3,999')
            : (plansState.selectedPeriodIndex == 0 ? '₹999' : '₹2,699'));

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Membership',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ).animate().fade(duration: 300.ms),
              
              const SizedBox(height: 16),

              // Active Subscription Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: hasActivePlan
                          ? [AppColors.primaryGreen.withOpacity(0.18), Colors.transparent]
                          : [Colors.grey.withOpacity(0.1), Colors.transparent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: hasActivePlan 
                          ? AppColors.primaryGreen.withOpacity(0.3) 
                          : (isDark ? AppColors.darkDivider : AppColors.lightDivider),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Active Plan Status',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: hasActivePlan 
                                  ? AppColors.primaryGreen.withOpacity(0.15) 
                                  : Colors.grey.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: hasActivePlan ? AppColors.primaryGreen : Colors.grey,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  hasActivePlan ? 'ACTIVE' : 'NO PLAN',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: hasActivePlan ? AppColors.primaryGreen : Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        hasActivePlan ? plansState.activePlan : 'No Active Membership',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasActivePlan) ...[
                        const SizedBox(height: 4),
                        Text(
                          '$activePlanCost / ${plansState.selectedPeriodIndex == 0 ? 'Month' : 'Quarter'}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: AppColors.primaryGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Divider(height: 1, thickness: 0.5),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(Icons.autorenew, size: 16, color: Colors.grey),
                            const SizedBox(width: 6),
                            Text(
                              'Renews on 15 July 2026',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),

              const SizedBox(height: 28),

              // Switcher title & Toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'Choose Your Plan',
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width: 160,
                      child: SegmentedToggle(
                        options: const ['Monthly', 'Quarterly'],
                        selectedIndex: plansState.selectedPeriodIndex,
                        onSelected: (index) {
                          plansNotifier.setPeriodIndex(index);
                        },
                      ),
                    ),
                  ],
                ),
              ).animate().fade(duration: 500.ms),

              const SizedBox(height: 20),

              // Swiper Carousel
              SizedBox(
                height: 400,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: planItems.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final item = planItems[index];
                    final title = item['title'] as String;
                    final price = item['price'] as String;
                    final isPopular = item['isPopular'] as bool;
                    final features = item['features'] as List<String>;
                    final isActive = plansState.activePlan == title;

                    // Compute scale factor for visual depth
                    final isCentered = index == _currentPageIndex;
                    final double scale = isCentered ? 1.0 : 0.92;

                    return AnimatedScale(
                      scale: scale,
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      child: PlanCard(
                        title: title,
                        price: price,
                        features: features,
                        isPopular: isPopular,
                        isActive: isActive,
                        onSelect: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentScreen(
                                planName: title,
                                price: price,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ).animate().fade(duration: 600.ms),

              const SizedBox(height: 16),

              // Page Indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(planItems.length, (index) {
                  final isActive = _currentPageIndex == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    width: isActive ? 20 : 8,
                    height: 8,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: isActive ? AppColors.primaryGreen : Colors.grey.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
