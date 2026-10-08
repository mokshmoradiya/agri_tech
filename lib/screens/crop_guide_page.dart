import 'package:flutter/material.dart';
import '../models/crop_model.dart';
import '../resources/app_colors.dart';
import 'crop_detail_screen.dart';

class CropGuidePage extends StatefulWidget {
  final ValueChanged<int>? onSwitchTab;

  const CropGuidePage({
    super.key,
    this.onSwitchTab,
  });

  @override
  State<CropGuidePage> createState() => _CropGuidePageState();
}

class _CropGuidePageState extends State<CropGuidePage> {
  final List<CropModel> _allCrops = CropModel.sampleCrops;
  String _searchQuery = '';

  List<CropModel> get _filteredCrops {
    if (_searchQuery.trim().isEmpty) {
      return _allCrops;
    }
    return _allCrops.where((crop) {
      final query = _searchQuery.toLowerCase();
      return crop.name.toLowerCase().contains(query) ||
          crop.scientificName.toLowerCase().contains(query) ||
          crop.description.toLowerCase().contains(query);
    }).toList();
  }

  void _openCropDetail(BuildContext context, CropModel crop) async {
    final selectedTab = await Navigator.of(context).push<int>(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 350),
        pageBuilder: (context, animation, secondaryAnimation) =>
            CropDetailScreen(crop: crop),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );

    if (selectedTab != null && widget.onSwitchTab != null) {
      widget.onSwitchTab!(selectedTab);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          const Text(
            'Crop Knowledge Base',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: AppColors.textTitle,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),

          // Subtitle
          const Text(
            "Expert AI-driven guidance for your farm's success.",
            style: TextStyle(
              fontSize: 13.5,
              color: AppColors.textSubtitle,
              fontWeight: FontWeight.w400,
            ),
          ),

          const SizedBox(height: 18),

          // Search Bar
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val;
                });
              },
              style: const TextStyle(fontSize: 14),
              decoration: const InputDecoration(
                hintText: 'Search for a crop (e.g. Cotton, Wheat)...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Color(0xFF94A3B8),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Color(0xFF64748B),
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),

          const SizedBox(height: 22),

          // Section Header: Common Crops + View All
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Common Crops',
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textTagline,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _searchQuery = '';
                  });
                },
                child: const Row(
                  children: [
                    Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // 2-Column Crop Grid with Crop Photos
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _filteredCrops.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: 0.95,
            ),
            itemBuilder: (context, index) {
              final crop = _filteredCrops[index];
              return _buildCropCard(context, crop);
            },
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildCropCard(BuildContext context, CropModel crop) {
    return GestureDetector(
      onTap: () => _openCropDetail(context, crop),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Real Photographic Crop Image (supports local asset and network)
              crop.imageUrl.startsWith('http')
                  ? Image.network(
                      crop.imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: crop.themeColor.withValues(alpha: 0.15),
                          child: Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
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
                            child: Icon(crop.icon, size: 40, color: Colors.white),
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
                            child: Icon(crop.icon, size: 40, color: Colors.white),
                          ),
                        );
                      },
                    ),

              // Bottom Dark Gradient Overlay for Typography Contrast
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.8),
                        Colors.black.withValues(alpha: 0.25),
                        Colors.transparent,
                      ],
                      stops: const [0.0, 0.7, 1.0],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        crop.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        crop.sowingTime,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
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
}
