import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';

class SplashFooter extends StatelessWidget {
  const SplashFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.eco,
          size: 15,
          color: AppColors.iconFooter,
        ),
        SizedBox(width: 6),
        Text(
          AppStrings.footerMotto,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textFooter,
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}
