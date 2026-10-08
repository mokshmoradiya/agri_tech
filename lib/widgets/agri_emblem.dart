import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import 'robotic_arm_icon.dart';
import 'agricultural_plane_icon.dart';

class AgriEmblem extends StatelessWidget {
  final double size;

  const AgriEmblem({
    super.key,
    this.size = 270,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.emblemBackground,
          border: Border.all(
            color: AppColors.emblemBorder,
            width: 1.2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 28,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipOval(
          child: Stack(
            children: [
              // 1. Glowing Sun (Top-Right)
              Positioned(
                top: 36,
                right: 56,
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const RadialGradient(
                      colors: [
                        AppColors.sunAmberStart,
                        AppColors.sunAmberEnd,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sunAmberStart.withValues(alpha: 0.5),
                        blurRadius: 18,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ),

              // 2. Smart Robotic Arm (Top-Left)
              const Positioned(
                top: 48,
                left: 36,
                child: RoboticArmIcon(
                  size: 40,
                  color: AppColors.primary,
                ),
              ),

              // 3. Drone / Agricultural Plane (Middle-Right)
              const Positioned(
                top: 86,
                right: 44,
                child: AgriculturalPlaneIcon(
                  size: 26,
                  color: AppColors.primary,
                ),
              ),

              // 4. Crop Growth / Telemetry Bars (Bottom-Center)
              Positioned(
                bottom: 26,
                left: 0,
                right: 0,
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildCropBar(height: 38, width: 11),
                      const SizedBox(width: 5),
                      _buildCropBar(height: 60, width: 11),
                      const SizedBox(width: 5),
                      _buildCropBar(height: 48, width: 11),
                      const SizedBox(width: 5),
                      _buildCropBar(height: 74, width: 11),
                      const SizedBox(width: 5),
                      _buildCropBar(height: 42, width: 11),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCropBar({required double height, required double width}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.cropBarColor,
        borderRadius: BorderRadius.circular(width / 2),
      ),
    );
  }
}
