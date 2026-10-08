import 'package:flutter/material.dart';
import '../resources/app_colors.dart';

class AccentProgressBar extends StatelessWidget {
  final Animation<double> animation;
  final double width;
  final double height;

  const AccentProgressBar({
    super.key,
    required this.animation,
    this.width = 170,
    this.height = 3.5,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.progressTrack,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: animation.value.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.progressIndicator,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
