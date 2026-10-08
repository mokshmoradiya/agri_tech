import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import '../widgets/app_logo_header.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/primary_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _farmerNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _cPasswordController = TextEditingController();

  @override
  void dispose() {
    _farmerNameController.dispose();
    _emailController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _cPasswordController.dispose();
    super.dispose();
  }

  void _onRegisterPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Registration successful! Welcome to AgriTech.',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Navigate back to login screen
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          AppStrings.registerTitle,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textTitle,
          ),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.backgroundTop,
              AppColors.backgroundCenter,
              AppColors.backgroundBottom,
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // Top Brand Logo (Compact)
                const AppLogoHeader(
                  title: AppStrings.registerTitle,
                  subtitle: AppStrings.registerSubtitle,
                  compact: true,
                ),

                const SizedBox(height: 24),

                // Registration Form Card
                Container(
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: AppColors.emblemBorder,
                      width: 1.2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.05),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Farmer Name
                      CustomTextField(
                        label: AppStrings.farmerNameLabel,
                        hint: AppStrings.farmerNameHint,
                        prefixIcon: Icons.person_outline_rounded,
                        controller: _farmerNameController,
                      ),

                      const SizedBox(height: 16),

                      // 2. Email
                      CustomTextField(
                        label: AppStrings.emailLabel,
                        hint: AppStrings.emailHint,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),

                      const SizedBox(height: 16),

                      // 3. Country & State (Side by Side Grid)
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              label: AppStrings.countryLabel,
                              hint: AppStrings.countryHint,
                              prefixIcon: Icons.public_rounded,
                              controller: _countryController,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: CustomTextField(
                              label: AppStrings.stateLabel,
                              hint: AppStrings.stateHint,
                              prefixIcon: Icons.map_outlined,
                              controller: _stateController,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 4. City
                      CustomTextField(
                        label: AppStrings.cityLabel,
                        hint: AppStrings.cityHint,
                        prefixIcon: Icons.location_city_rounded,
                        controller: _cityController,
                      ),

                      const SizedBox(height: 16),

                      // 5. Address (Multi-line)
                      CustomTextField(
                        label: AppStrings.addressLabel,
                        hint: AppStrings.addressHint,
                        prefixIcon: Icons.home_work_outlined,
                        maxLines: 2,
                        controller: _addressController,
                      ),

                      const SizedBox(height: 16),

                      // 6. Password
                      CustomTextField(
                        label: AppStrings.passwordLabel,
                        hint: AppStrings.passwordHint,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        controller: _passwordController,
                      ),

                      const SizedBox(height: 16),

                      // 7. Confirm Password (C-Password)
                      CustomTextField(
                        label: AppStrings.cPasswordLabel,
                        hint: AppStrings.cPasswordHint,
                        prefixIcon: Icons.lock_clock_outlined,
                        isPassword: true,
                        controller: _cPasswordController,
                      ),

                      const SizedBox(height: 26),

                      // 8. Register Button
                      PrimaryButton(
                        text: AppStrings.registerButton,
                        onPressed: _onRegisterPressed,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Link to Login Screen
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      AppStrings.alreadyAccountPrompt,
                      style: TextStyle(
                        fontSize: 13.5,
                        color: AppColors.textSubtitle,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: const Text(
                        AppStrings.loginLink,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryLight,
                          fontWeight: FontWeight.w700,
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.primaryLight,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
