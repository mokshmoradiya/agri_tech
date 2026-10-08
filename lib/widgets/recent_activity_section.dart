import 'package:flutter/material.dart';
import '../models/crop_expense_model.dart';
import '../resources/app_colors.dart';
import '../resources/app_strings.dart';
import '../screens/crop_expense_calculator_screen.dart';
import '../screens/my_crops_screen.dart';
import '../screens/weather_screen.dart';
import '../services/crop_expense_repository.dart';
import '../services/sown_crop_repository.dart';

class RecentActivitySection extends StatelessWidget {
  final VoidCallback? onViewAllTap;

  const RecentActivitySection({
    super.key,
    this.onViewAllTap,
  });

  @override
  Widget build(BuildContext context) {
    final cropRepo = SownCropRepository.instance;
    final expenseRepo = CropExpenseRepository.instance;

    return AnimatedBuilder(
      animation: Listenable.merge([
        cropRepo.cropsNotifier,
        expenseRepo.expensesNotifier,
        expenseRepo.laborNotifier,
      ]),
      builder: (context, _) {
        final activities = _compileActivities(context, cropRepo, expenseRepo);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Header with View All
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.history_rounded,
                        color: AppColors.primary, size: 20),
                    SizedBox(width: 8),
                    Text(
                      AppStrings.recentActivity,
                      style: TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textTagline,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onViewAllTap ?? () => _showAllActivitiesSheet(context, activities),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      AppStrings.viewAll,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (activities.isEmpty)
              _buildEmptyActivityCard(context)
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: activities.length.clamp(0, 4),
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = activities[index];
                  return _buildActivityCard(context, item);
                },
              ),
          ],
        );
      },
    );
  }

  List<_AppActivityItem> _compileActivities(
    BuildContext context,
    SownCropRepository cropRepo,
    CropExpenseRepository expenseRepo,
  ) {
    final List<_AppActivityItem> list = [];

    // 1. Latest Sown Crop Activities from My Crops
    for (final crop in cropRepo.crops) {
      list.add(
        _AppActivityItem(
          icon: Icons.grass_rounded,
          iconBg: const Color(0xFFDCFCE7),
          iconColor: const Color(0xFF166534),
          tag: 'Sown Crop',
          tagBg: const Color(0xFFE8F5E9),
          tagColor: const Color(0xFF2E7D32),
          title: 'Sown Crop: ${crop.cropName}',
          subtitle: '${crop.formattedArea} • ${crop.season} Season • ${crop.growthStage}',
          time: crop.formattedDate,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MyCropsScreen()),
            );
          },
        ),
      );
    }

    // 2. Latest Pesticide Spray & Farm Expenses
    for (final exp in expenseRepo.expenses) {
      final isSpray = exp.category == ExpenseCategory.pesticide;
      final isFert = exp.category == ExpenseCategory.fertilizer;

      list.add(
        _AppActivityItem(
          icon: exp.category.icon,
          iconBg: isSpray
              ? const Color(0xFFFEF3C7)
              : isFert
                  ? const Color(0xFFE0F2FE)
                  : const Color(0xFFF3E8FF),
          iconColor: isSpray
              ? const Color(0xFFD97706)
              : isFert
                  ? const Color(0xFF0284C7)
                  : const Color(0xFF7E22CE),
          tag: exp.category.shortLabel,
          tagBg: isSpray
              ? const Color(0xFFFFFBEB)
              : const Color(0xFFF0F9FF),
          tagColor: isSpray
              ? const Color(0xFFB45309)
              : const Color(0xFF0369A1),
          title: '${exp.title} (${exp.formattedAmount})',
          subtitle: 'Crop: ${exp.cropName} • ${exp.category.displayName}',
          time: exp.formattedDate,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CropExpenseCalculatorScreen(
                  initialCropId: exp.cropId,
                ),
              ),
            );
          },
        ),
      );
    }

    // 3. Latest Labor Ledger Wage Records
    for (final labor in expenseRepo.laborRecords) {
      list.add(
        _AppActivityItem(
          icon: Icons.groups_rounded,
          iconBg: const Color(0xFFEFF6FF),
          iconColor: const Color(0xFF2563EB),
          tag: labor.isPaid ? 'Labor Paid' : 'Labor Due',
          tagBg: labor.isPaid ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
          tagColor: labor.isPaid ? const Color(0xFF166534) : const Color(0xFF991B1B),
          title: 'Labor: ${labor.workerName} (${labor.formattedTotal})',
          subtitle: '${labor.workType} • ${labor.formattedCalculation}',
          time: labor.formattedDate,
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CropExpenseCalculatorScreen(
                  initialCropId: labor.cropId,
                ),
              ),
            );
          },
        ),
      );
    }

    // 4. Agri Weather Advisory Activity
    list.add(
      _AppActivityItem(
        icon: Icons.wb_sunny_rounded,
        iconBg: const Color(0xFFFEF9C3),
        iconColor: const Color(0xFFCA8A04),
        tag: 'Weather Alert',
        tagBg: const Color(0xFFFEF3C7),
        tagColor: const Color(0xFFB45309),
        title: 'Favorable Spray Weather Window',
        subtitle: 'Anand, Gujarat • Low wind (11 km/h) • Next 24 hrs ideal',
        time: 'Today',
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const WeatherScreen()),
          );
        },
      ),
    );

    return list;
  }

  Widget _buildActivityCard(BuildContext context, _AppActivityItem item) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: item.onTap,
      child: Container(
        padding: const EdgeInsets.all(13),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.emblemBorder,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon Container
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: item.iconBg,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(item.icon, color: item.iconColor, size: 20),
            ),

            const SizedBox(width: 12),

            // Title, Subtitle and Tag
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textBody,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: item.tagBg,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.tag,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: item.tagColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSubtitle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        item.time,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.chevron_right_rounded,
                size: 18, color: Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyActivityCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emblemBorder),
      ),
      child: const Center(
        child: Text(
          'No recent activities recorded yet.\nAdd a crop or log expenses to see your timeline.',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5,
            color: AppColors.textSubtitle,
          ),
        ),
      ),
    );
  }

  void _showAllActivitiesSheet(BuildContext context, List<_AppActivityItem> activities) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(ctx).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'All Farm Activities',
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTitle,
                        ),
                      ),
                      Text(
                        'Chronological log of crops, sprays & wages',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(ctx).pop(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: activities.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = activities[index];
                    return _buildActivityCard(context, item);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AppActivityItem {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String tag;
  final Color tagBg;
  final Color tagColor;
  final String title;
  final String subtitle;
  final String time;
  final VoidCallback onTap;

  const _AppActivityItem({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.tag,
    required this.tagBg,
    required this.tagColor,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.onTap,
  });
}
