import 'package:flutter/material.dart';
import '../models/crop_model.dart';
import '../resources/app_colors.dart';
import '../widgets/app_bottom_nav_bar.dart';

class CropDetailScreen extends StatefulWidget {
  final CropModel crop;

  const CropDetailScreen({
    super.key,
    required this.crop,
  });

  @override
  State<CropDetailScreen> createState() => _CropDetailScreenState();
}

class _CropDetailScreenState extends State<CropDetailScreen> {
  int _currentNavIndex = 1; // Default to 'Crop Guide' tab (Index 1)

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      // Already in Crop Guide flow
      Navigator.of(context).pop();
    } else {
      // Pop back to dashboard and notify tab switch
      Navigator.of(context).pop(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final crop = widget.crop;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FCFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: AppColors.primary,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          crop.name,
          style: const TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w800,
            color: AppColors.textTitle,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined, color: AppColors.textTagline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing ${crop.name} guide...'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.bookmark_border_rounded, color: AppColors.textTagline),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${crop.name} saved to bookmarks!'),
                  backgroundColor: AppColors.primary,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Crop Hero Image Banner
            _buildCropHeroImage(crop),

            const SizedBox(height: 22),

            // 2. Introduction Section
            _buildSectionHeader(
              icon: Icons.description_outlined,
              title: 'Introduction',
            ),
            const SizedBox(height: 8),
            Text(
              crop.description,
              style: const TextStyle(
                fontSize: 14,
                height: 1.5,
                color: Color(0xFF334155),
              ),
            ),

            const SizedBox(height: 22),

            // 3. Climate & Best Soil
            _buildSectionHeader(
              icon: Icons.thermostat_outlined,
              title: 'Climate & Soil',
            ),
            const SizedBox(height: 10),
            _buildCheckItem(
              title: 'Temperature',
              content: crop.temperature,
            ),
            const SizedBox(height: 8),
            _buildCheckItem(
              title: 'Best Soil',
              content: crop.bestSoil,
            ),

            const SizedBox(height: 22),

            // 4. Sowing & Harvest Time (Paak-Time)
            _buildSectionHeader(
              icon: Icons.calendar_month_outlined,
              title: 'Sowing & Harvest Duration',
            ),
            const SizedBox(height: 10),
            _buildSowingAndHarvestCard(crop),

            const SizedBox(height: 22),

            // 5. Irrigation Schedule (Shinchiye Time)
            _buildSectionHeader(
              icon: Icons.water_drop_outlined,
              title: 'Irrigation Schedule',
            ),
            const SizedBox(height: 10),
            _buildIrrigationCard(crop),

            const SizedBox(height: 22),

            // 6. Fertilizer Schedule
            _buildSectionHeader(
              icon: Icons.science_outlined,
              title: 'Fertilizer Schedule',
            ),
            const SizedBox(height: 12),
            _buildFertilizerTable(crop),

            const SizedBox(height: 32),
          ],
        ),
      ),

      // Bottom Navigation Bar added as requested
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
          _onBottomNavTapped(index);
        },
      ),
    );
  }

  Widget _buildCropHeroImage(CropModel crop) {
    return Container(
      width: double.infinity,
      height: 190,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Crop Photographic Image (supports local asset and network)
            crop.imageUrl.startsWith('http')
                ? Image.network(
                    crop.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Container(
                        color: crop.themeColor.withValues(alpha: 0.15),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor: AlwaysStoppedAnimation(crop.themeColor),
                          ),
                        ),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              crop.themeColor,
                              crop.themeColor.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(crop.icon, size: 54, color: Colors.white),
                        ),
                      );
                    },
                  )
                : Image.asset(
                    crop.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              crop.themeColor,
                              crop.themeColor.withValues(alpha: 0.8),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Icon(crop.icon, size: 54, color: Colors.white),
                        ),
                      );
                    },
                  ),

            // Gradient Overlay for Readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.75),
                    Colors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
              ),
            ),

            // Crop Title & Badge
            Positioned(
              left: 18,
              bottom: 16,
              right: 18,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          crop.name,
                          style: const TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: -0.4,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          crop.scientificName,
                          style: TextStyle(
                            fontSize: 13,
                            fontStyle: FontStyle.italic,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.verified_rounded, size: 14, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Verified Guide',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryLight, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }

  Widget _buildCheckItem({
    required String title,
    required String content,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 2),
          child: Icon(
            Icons.check_circle_outline_rounded,
            color: Color(0xFFD97706),
            size: 19,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Color(0xFF1E293B),
              ),
              children: [
                TextSpan(
                  text: '$title: ',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                TextSpan(text: content),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSowingAndHarvestCard(CropModel crop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF5F1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emblemBorder),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetailMetric('SOWING TIME', crop.sowingTime),
              Container(width: 1, height: 36, color: AppColors.inputBorder),
              _buildDetailMetric('SEED RATE', crop.seedRate),
            ],
          ),
          const Divider(height: 20, color: AppColors.inputBorder),
          Row(
            children: [
              const Icon(Icons.timer_outlined, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 13, color: AppColors.textBody),
                    children: [
                      const TextSpan(
                        text: 'Harvest Duration: ',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(
                        text: crop.paakTime,
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color(0xFF64748B),
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildIrrigationCard(CropModel crop) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBBF7D0)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.water_drop_rounded,
              color: Color(0xFF16A34A),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              crop.shinchiyeTime,
              style: const TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: Color(0xFF14532D),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFertilizerTable(CropModel crop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD1D5DB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            // Table Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFE5E7EB),
              child: const Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      'Stage',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 6,
                    child: Text(
                      'Nutrient (N:P:K)',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Table Rows
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: crop.fertilizerSchedule.length,
              separatorBuilder: (context, index) =>
                  const Divider(height: 1, color: Color(0xFFE5E7EB)),
              itemBuilder: (context, index) {
                final item = crop.fertilizerSchedule[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(
                          item.stage,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Text(
                          item.nutrient,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1F2937),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
