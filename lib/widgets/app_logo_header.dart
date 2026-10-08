import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';

class AppLogoHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool compact;

  const AppLogoHeader({
    super.key,
    this.title = AppStrings.appName,
    this.subtitle = AppStrings.loginSubtitle,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Brand Leaf Logo Box matching the AnnData AI mockup card
        Container(
          width: compact ? 60 : 70,
          height: compact ? 60 : 70,
          padding: EdgeInsets.symmetric(
            horizontal: 8,
            vertical: compact ? 6 : 8,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.emblemBorder,
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.spa_rounded,
                    color: AppColors.primaryLight,
                    size: compact ? 24 : 28,
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'AnnData AI',
                    style: TextStyle(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),

        SizedBox(height: compact ? 12 : 18),

        // Brand Title
        Text(
          title,
          style: TextStyle(
            fontSize: compact ? 26 : 32,
            fontWeight: FontWeight.w800,
            color: AppColors.textTitle,
            letterSpacing: -0.5,
          ),
        ),

        const SizedBox(height: 8),

        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
              color: AppColors.textTagline,
              height: 1.35,
            ),
          ),
        ),
      ],
    );
  }
}
