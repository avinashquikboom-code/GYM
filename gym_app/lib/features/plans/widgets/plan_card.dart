import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/custom_button.dart';

class PlanCard extends StatelessWidget {
  final String title;
  final String price;
  final List<String> features;
  final bool isPopular;
  final bool isActive;
  final VoidCallback onSelect;

  const PlanCard({
    super.key,
    required this.title,
    required this.price,
    required this.features,
    this.isPopular = false,
    this.isActive = false,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Glowing border & shadow configuration for premium cards
    final showGlow = isActive || isPopular;
    final cardBorderColor = isActive 
        ? AppColors.primaryGreen 
        : (isPopular 
            ? const Color(0xFFF7BD38) 
            : (isDark ? AppColors.darkDivider : AppColors.lightDivider));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 12),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: cardBorderColor,
          width: isActive ? 2 : (isPopular ? 1.5 : 1),
        ),
        boxShadow: showGlow && isDark
            ? [
                BoxShadow(
                  color: (isActive ? AppColors.primaryGreen : const Color(0xFFF7BD38)).withOpacity(0.08),
                  blurRadius: 20,
                  spreadRadius: 2,
                  offset: const Offset(0, 4),
                ),
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: (isActive ? AppColors.primaryGreen : (isPopular ? const Color(0xFFF7BD38) : Colors.grey)).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        title.contains('Premium')
                            ? Icons.star_rounded
                            : (title.contains('Standard') 
                                ? Icons.military_tech_rounded 
                                : Icons.fitness_center_rounded),
                        color: isActive ? AppColors.primaryGreen : (isPopular ? const Color(0xFFF7BD38) : Colors.grey),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.baseline,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Flexible(
                                child: Text(
                                  price,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.primaryGreen,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                              Text(
                                ' /month',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontSize: 11,
                                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isPopular)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7BD38).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFFF7BD38), width: 1),
                  ),
                  child: const Text(
                    'POPULAR',
                    style: TextStyle(
                      color: Color(0xFFF7BD38),
                      fontWeight: FontWeight.bold,
                      fontSize: 8,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
            ],
          ),
          
          const SizedBox(height: 16),
          const Divider(height: 1, thickness: 0.5),
          const SizedBox(height: 16),

          // Features List
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: features.map((feature) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 2),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: AppColors.primaryGreen,
                        size: 14,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        feature,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 12.5,
                          height: 1.3,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              )).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Action Button
          CustomButton(
            text: isActive ? 'Active Plan' : 'Choose Plan',
            type: isActive ? ButtonType.solid : ButtonType.outline,
            backgroundColor: isActive ? AppColors.primaryGreen : null,
            onPressed: isActive ? null : onSelect,
            height: 48,
            borderRadius: 14,
          ),
        ],
      ),
    );
  }
}
