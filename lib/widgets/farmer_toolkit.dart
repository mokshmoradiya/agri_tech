import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';

class FarmerToolkit extends StatelessWidget {
  final Function(String toolName)? onToolTap;

  const FarmerToolkit({
    super.key,
    this.onToolTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        const Text(
          AppStrings.farmersToolkit,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textTagline,
            letterSpacing: -0.3,
          ),
        ),

        const SizedBox(height: 14),

        // Grid / Row of Tools (Weather, Calculator, Crop Knowledge, My Crops)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Weather Tool
            Expanded(
              child: _buildToolCard(
                context: context,
                icon: Icons.wb_sunny_outlined,
                label: AppStrings.toolWeather,
                isHighlighted: false,
                onTap: () => onToolTap?.call(AppStrings.toolWeather),
              ),
            ),

            // 2. Calculator Tool
            Expanded(
              child: _buildToolCard(
                context: context,
                icon: Icons.calculate_outlined,
                label: AppStrings.toolCalculator,
                isHighlighted: true,
                onTap: () => onToolTap?.call(AppStrings.toolCalculator),
              ),
            ),

            // 3. Crop Knowledge Tool
            Expanded(
              child: _buildToolCard(
                context: context,
                icon: Icons.menu_book_rounded,
                label: AppStrings.toolCropKnowledge,
                isHighlighted: false,
                onTap: () => onToolTap?.call(AppStrings.toolCropKnowledge),
              ),
            ),

            // 4. My Sown Crops Tool
            Expanded(
              child: _buildToolCard(
                context: context,
                icon: Icons.grass_rounded,
                label: AppStrings.toolMyCrops,
                isHighlighted: false,
                onTap: () => onToolTap?.call(AppStrings.toolMyCrops),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildToolCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required bool isHighlighted,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          // Rounded Squircle Container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: isHighlighted
                  ? AppColors.primary
                  : const Color(0xFFEBF4EE),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isHighlighted
                    ? AppColors.primary
                    : const Color(0xFFD6E8DB),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: isHighlighted
                      ? AppColors.primary.withValues(alpha: 0.22)
                      : Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                color: isHighlighted ? Colors.white : AppColors.primary,
                size: 28,
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Label
          SizedBox(
            width: 74,
            child: Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textTagline,
                height: 1.15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
