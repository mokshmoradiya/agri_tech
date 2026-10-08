import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';

class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // App Title
        const Text(
          AppStrings.appName,
          style: TextStyle(
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: AppColors.textTitle,
            letterSpacing: -0.6,
          ),
        ),

        const SizedBox(height: 10),

        // Green Pill Tag / Chip
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.badgeBackground,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Text(
            AppStrings.appBadge,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.8,
              color: AppColors.badgeText,
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Tagline Text
        const Text(
          AppStrings.appTagline,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textTagline,
            letterSpacing: 0.1,
          ),
        ),
      ],
    );
  }
}
