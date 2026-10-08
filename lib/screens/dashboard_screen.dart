import 'package:flutter/material.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_search_bar.dart';
import '../widgets/farmer_toolkit.dart';
import '../widgets/recent_activity_section.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../models/sown_crop_model.dart';
import '../services/sown_crop_repository.dart';
import 'crop_guide_page.dart';
import 'my_crops_screen.dart';
import 'crop_expense_calculator_screen.dart';
import 'weather_screen.dart';
import 'login_screen.dart';
import '../models/farmer_profile_model.dart';
import '../services/farmer_profile_repository.dart';
import '../widgets/edit_profile_modal.dart';
import '../widgets/change_password_modal.dart';

class DashboardScreen extends StatefulWidget {
  final int initialTabIndex;

  const DashboardScreen({super.key, this.initialTabIndex = 0});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentTabIndex;

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      // Common TopBar for all tabs as requested:
      // "topbar(application name ,notifiction icon and profile icon)-aa batha page ma same rhase"
      appBar: AppTopBar(
        onNotificationTap: () {
          _showNotificationSheet(context);
        },
        onProfileTap: () {
          setState(() {
            _currentTabIndex = 3; // Switch to Profile tab
          });
        },
      ),
      body: IndexedStack(
        index: _currentTabIndex,
        children: [
          _buildHomeTab(),
          CropGuidePage(
            onSwitchTab: (tab) {
              setState(() {
                _currentTabIndex = tab;
              });
            },
          ),
          _buildAiAssistantTab(),
          _buildProfileTab(),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentTabIndex,
        onTap: (index) {
          setState(() {
            _currentTabIndex = index;
          });
        },
      ),
    );
  }

  // ==========================================
  // TAB 1: HOME DASHBOARD
  // ==========================================
  Widget _buildHomeTab() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Search Bar
          CustomSearchBar(
            onChanged: (val) {},
          ),

          const SizedBox(height: 16),

          // 1.1 Weather Glance Banner
          _buildWeatherGlanceCard(),

          const SizedBox(height: 20),

          // 2. Farmer's Toolkit (Weather, Calculator, Crop Knowledge, My Crops)
          FarmerToolkit(
            onToolTap: (toolName) {
              _handleToolNavigation(toolName);
            },
          ),

          const SizedBox(height: 22),

          // 3. My Sown Crops Section (User's sown crops: crop name, time, cultivated area)
          _buildMySownCropsSection(),

          const SizedBox(height: 22),

          // 4. Recent Activity Section
          const RecentActivitySection(),

          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildWeatherGlanceCard() {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () async {
        final tab = await Navigator.of(context).push<int>(
          MaterialPageRoute(builder: (context) => const WeatherScreen()),
        );
        if (tab != null && mounted) {
          setState(() => _currentTabIndex = tab);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.emblemBorder, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFFFEF3C7),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.wb_sunny_rounded,
                  color: Color(0xFFD97706), size: 22),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Anand, Gujarat • 29°C',
                        style: TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTagline,
                        ),
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Partly Cloudy',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    '🌾 Low wind (12 km/h) • Safe for pesticide spraying today',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: Color(0xFF94A3B8), size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMySownCropsSection() {
    return ValueListenableBuilder<List<SownCropModel>>(
      valueListenable: SownCropRepository.instance.cropsNotifier,
      builder: (context, crops, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.grass_rounded,
                        color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      AppStrings.myCropsTitle,
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textTagline,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () async {
                    final tab = await Navigator.of(context).push<int>(
                      MaterialPageRoute(
                        builder: (context) => const MyCropsScreen(),
                      ),
                    );
                    if (tab != null && mounted) {
                      setState(() => _currentTabIndex = tab);
                    }
                  },
                  child: const Text(
                    'View & Add >',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 144,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                itemCount: crops.length + 1,
                separatorBuilder: (ctx, i) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  if (index == crops.length) {
                    // Add Crop Quick Action Card
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => MyCropsScreen.showAddCropModal(context),
                      child: Container(
                        width: 130,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F8F3),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFC7E2CE),
                            width: 1.2,
                          ),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 17,
                              backgroundColor: AppColors.primary,
                              child: Icon(Icons.add_rounded,
                                  color: Colors.white, size: 20),
                            ),
                            SizedBox(height: 6),
                            Text(
                              '+ Add Crop',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Sown Crop',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.textSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  final crop = crops[index];
                  return InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () async {
                      final tab = await Navigator.of(context).push<int>(
                        MaterialPageRoute(
                          builder: (context) => const MyCropsScreen(),
                        ),
                      );
                      if (tab != null && mounted) {
                        setState(() => _currentTabIndex = tab);
                      }
                    },
                    child: Container(
                      width: 165,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.emblemBorder,
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBF4EE),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.eco_rounded,
                                    size: 16, color: AppColors.primary),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  crop.growthStage,
                                  style: const TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF166534),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                crop.cropName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textBody,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '🌾 ${crop.formattedArea}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '🗓️ ${crop.formattedDate}',
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.textSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }


  // TAB 2 is CropGuidePage()


  // ==========================================
  // TAB 3: AI ASSISTANT (CHATBOT)
  // ==========================================
  Widget _buildAiAssistantTab() {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(18),
            children: [
              // Bot Greeting Bubble
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.smart_toy_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.emblemBorder),
                      ),
                      child: const Text(
                        'Hello Farmer! 🌾\nI am your AgriTech AI Assistant. Ask me anything about crop diseases, pest remedies, weather forecasts, or fertilizer dosage.',
                        style: TextStyle(
                          fontSize: 13.5,
                          height: 1.4,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Suggestion Pills
              const Text(
                'Frequently Asked by Farmers:',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSubtitle,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildChip('Why are wheat leaves turning yellow?'),
                  _buildChip('Best urea schedule for Cotton'),
                  _buildChip('Tomorrow rainfall prediction'),
                  _buildChip('Government subsidy schemes 2026'),
                ],
              ),
            ],
          ),
        ),

        // Chat Input Box
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: AppColors.emblemBorder)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.inputBackground,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: AppColors.inputBorder),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      hintText: 'Type your farming question...',
                      hintStyle: TextStyle(fontSize: 13.5, color: AppColors.textHint),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.badgeBackground.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emblemBorder),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.primary,
        ),
      ),
    );
  }

  // ==========================================
  // TAB 4: PROFILE
  // ==========================================
  Widget _buildProfileTab() {
    return AnimatedBuilder(
      animation: FarmerProfileRepository.instance.profileNotifier,
      builder: (context, _) {
        final profile = FarmerProfileRepository.instance.profile;
        final avatar = EditProfileModal.avatarOptions[profile.avatarIndex
            .clamp(0, EditProfileModal.avatarOptions.length - 1)];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // 1. Farmer Profile Card
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.emblemBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 34,
                          backgroundColor: (avatar['color'] as Color)
                              .withValues(alpha: 0.18),
                          child: Icon(
                            avatar['icon'] as IconData,
                            size: 36,
                            color: avatar['color'] as Color,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      profile.fullName,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textTitle,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Edit Profile',
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 20, color: AppColors.primary),
                                    onPressed: () =>
                                        EditProfileModal.show(context),
                                  ),
                                ],
                              ),
                              Text(
                                '${profile.formattedLocation} • ${profile.formattedLandArea}',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSubtitle,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  'KCC ID: ${profile.kisanId}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF166534),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                    const SizedBox(height: 12),
                    // Quick Profile Stats Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildProfileMiniStat(
                          'Land Area',
                          profile.formattedLandArea,
                          Icons.landscape_rounded,
                        ),
                        Container(
                            height: 24,
                            width: 1,
                            color: const Color(0xFFE2E8F0)),
                        _buildProfileMiniStat(
                          'Mobile',
                          profile.phoneNumber,
                          Icons.phone_rounded,
                        ),
                        Container(
                            height: 24,
                            width: 1,
                            color: const Color(0xFFE2E8F0)),
                        _buildProfileMiniStat(
                          'Practice',
                          profile.farmingType.split(' ').first,
                          Icons.spa_rounded,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 2. Action: Edit Profile
              _buildProfileOption(
                Icons.person_outline_rounded,
                'Edit Farmer Profile',
                'Change name, phone, village & farmland size',
                onTap: () => EditProfileModal.show(context),
              ),

              // 3. Action: Change Password
              _buildProfileOption(
                Icons.lock_reset_rounded,
                'Change Password',
                'Update your login security and credentials',
                onTap: () => ChangePasswordModal.show(context),
              ),

              const SizedBox(height: 6),

              // 4. Action: Logout
              _buildProfileOption(
                Icons.logout_rounded,
                'Logout',
                'Sign out of your AgriTech farmer account',
                isDestructive: true,
                onTap: () => _confirmLogout(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProfileMiniStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.textBody,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10.5,
            color: AppColors.textSubtitle,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
    bool isDestructive = false,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDestructive ? const Color(0xFFFEF2F2) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color:
                isDestructive ? const Color(0xFFFCA5A5) : AppColors.emblemBorder,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? const Color(0xFFFEE2E2)
                    : const Color(0xFFEBF5EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color:
                    isDestructive ? const Color(0xFFDC2626) : AppColors.primary,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                      color: isDestructive
                          ? const Color(0xFFDC2626)
                          : AppColors.textBody,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDestructive
                          ? const Color(0xFFEF4444)
                          : AppColors.textSubtitle,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDestructive
                  ? const Color(0xFFFCA5A5)
                  : const Color(0xFF94A3B8),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFEE2E2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.logout_rounded,
                color: Color(0xFFDC2626),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Logout',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 18,
              ),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your AgriTech account?',
          style: TextStyle(
            fontSize: 14,
            height: 1.4,
            color: AppColors.textBody,
          ),
        ),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(
                color: Color(0xFF64748B),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 400),
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionsBuilder: (_, anim, __, child) =>
                      FadeTransition(opacity: anim, child: child),
                ),
                (route) => false,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Row(
                    children: [
                      Icon(Icons.check_circle_outline_rounded,
                          color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Logged out successfully',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: const Text(
              'Logout',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleToolNavigation(String toolName) async {
    if (toolName == AppStrings.toolCropKnowledge) {
      setState(() {
        _currentTabIndex = 1; // Seamlessly jump to Crop Guide
      });
      return;
    }
    if (toolName == AppStrings.toolMyCrops) {
      final tab = await Navigator.of(context).push<int>(
        MaterialPageRoute(
          builder: (context) => const MyCropsScreen(),
        ),
      );
      if (tab != null && mounted) {
        setState(() => _currentTabIndex = tab);
      }
      return;
    }
    if (toolName == AppStrings.toolWeather) {
      final tab = await Navigator.of(context).push<int>(
        MaterialPageRoute(
          builder: (context) => const WeatherScreen(),
        ),
      );
      if (tab != null && mounted) {
        setState(() => _currentTabIndex = tab);
      }
      return;
    }
    if (toolName == AppStrings.toolCalculator) {
      final tab = await Navigator.of(context).push<int>(
        MaterialPageRoute(
          builder: (context) => const CropExpenseCalculatorScreen(),
        ),
      );
      if (tab != null && mounted) {
        setState(() => _currentTabIndex = tab);
      }
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $toolName module...'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _showNotificationSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Farm Notifications',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTitle,
                ),
              ),
              const SizedBox(height: 14),
              const ListTile(
                leading: Icon(Icons.cloud_sync_rounded, color: AppColors.primary),
                title: Text('Weather Advisory'),
                subtitle: Text('Light showers expected in Anand tomorrow afternoon.'),
              ),
              const ListTile(
                leading: Icon(Icons.water_drop_rounded, color: Color(0xFF0284C7)),
                title: Text('Irrigation Reminder'),
                subtitle: Text('Plot B moisture is low (42%). Irrigation recommended.'),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
