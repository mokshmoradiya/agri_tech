import 'package:flutter/material.dart';
import '../models/crop_expense_model.dart';
import '../models/sown_crop_model.dart';
import '../resources/app_colors.dart';
import '../services/crop_expense_repository.dart';
import '../services/sown_crop_repository.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'dashboard_screen.dart';

class CropExpenseCalculatorScreen extends StatefulWidget {
  final String? initialCropId;

  const CropExpenseCalculatorScreen({
    super.key,
    this.initialCropId,
  });

  static Future<void> showAddExpenseModal(BuildContext context,
      {String? preselectedCropId}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          _AddExpenseModalSheet(preselectedCropId: preselectedCropId),
    );
  }

  static Future<void> showAddLaborModal(BuildContext context,
      {String? preselectedCropId}) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) =>
          _AddLaborModalSheet(preselectedCropId: preselectedCropId),
    );
  }

  @override
  State<CropExpenseCalculatorScreen> createState() =>
      _CropExpenseCalculatorScreenState();
}

class _CropExpenseCalculatorScreenState
    extends State<CropExpenseCalculatorScreen>
    with SingleTickerProviderStateMixin {
  final CropExpenseRepository _expenseRepo = CropExpenseRepository.instance;
  final SownCropRepository _cropRepo = SownCropRepository.instance;

  late TabController _tabController;
  String _selectedCropId = 'all'; // 'all' or specific crop id
  ExpenseCategory? _filterCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    if (widget.initialCropId != null) {
      _selectedCropId = widget.initialCropId!;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(index);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => DashboardScreen(initialTabIndex: index),
        ),
      );
    }
  }

  SownCropModel? get _currentCrop {
    if (_selectedCropId == 'all') return null;
    try {
      return _cropRepo.crops.firstWhere((c) => c.id == _selectedCropId);
    } catch (_) {
      return null;
    }
  }

  void _confirmDeleteExpense(CropExpenseItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Expense Entry',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Text(
          'Are you sure you want to remove "${item.title}" (${item.formattedAmount})?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              _expenseRepo.removeExpense(item.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Expense entry deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteLabor(LaborRecord record) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Labor Record',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
        content: Text(
          'Are you sure you want to remove "${record.workerName}" wage record (${record.formattedTotal})?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade700,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              _expenseRepo.removeLaborRecord(record.id);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Labor record deleted'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundTop,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.textTitle, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Farm Cost & Calculator',
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textTitle,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Pesticide Spray, Fertilizer & Labor Ledger',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSubtitle,
              ),
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.primary,
          unselectedLabelColor: const Color(0xFF64748B),
          indicatorColor: AppColors.primary,
          indicatorWeight: 3,
          labelStyle:
              const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
          tabs: const [
            Tab(text: 'Expenses'),
            Tab(text: 'Labor Ledger'),
            Tab(text: 'Cost Estimator'),
          ],
        ),
      ),
      body: AnimatedBuilder(
        animation: Listenable.merge(
            [_expenseRepo.expensesNotifier, _expenseRepo.laborNotifier]),
        builder: (context, _) {
          return Column(
            children: [
              // 1. SOWN CROP SELECTOR
              _buildCropSelectorBar(),

              // 2. MAIN GRAND SUMMARY CARD
              _buildSummaryHeader(),

              // 3. TAB CONTENT
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildExpensesTab(),
                    _buildLaborTab(),
                    _buildEstimatorTab(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildBottomActionBar(),
          AppBottomNavBar(
            currentIndex: 0,
            onTap: _onBottomNavTapped,
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 1. SOWN CROP SELECTOR BAR
  // ==========================================
  Widget _buildCropSelectorBar() {
    final sownCrops = _cropRepo.crops;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.grass_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 6),
              const Text(
                'Select Sown Crop:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textTagline,
                ),
              ),
              const Spacer(),
              if (_currentCrop != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    _currentCrop!.formattedArea,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF166534),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              children: [
                _buildCropFilterChip(
                  label: 'All Crops',
                  isSelected: _selectedCropId == 'all',
                  onTap: () => setState(() => _selectedCropId = 'all'),
                ),
                ...sownCrops.map((crop) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: _buildCropFilterChip(
                      label: '${crop.cropName} (${crop.formattedArea})',
                      isSelected: _selectedCropId == crop.id,
                      onTap: () => setState(() => _selectedCropId = crop.id),
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCropFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : const Color(0xFFF1F5F2),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFD6E8DB),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? Colors.white : AppColors.textTagline,
            ),
          ),
        ),
      ),
    );
  }

  // ==========================================
  // 2. GRAND SUMMARY HEADER
  // ==========================================
  Widget _buildSummaryHeader() {
    final overallTotal = _expenseRepo.getTotalOverallExpense(_selectedCropId);
    final sprayTotal =
        _expenseRepo.getCategoryTotal(ExpenseCategory.pesticide, _selectedCropId);
    final fertTotal =
        _expenseRepo.getCategoryTotal(ExpenseCategory.fertilizer, _selectedCropId);
    final laborTotal = _expenseRepo.getTotalLaborExpense(_selectedCropId);

    String? costPerArea;
    if (_currentCrop != null && _currentCrop!.landArea > 0) {
      final perUnit = overallTotal / _currentCrop!.landArea;
      costPerArea =
          '₹${perUnit.toStringAsFixed(0)} / ${_currentCrop!.areaUnit.contains('Bigha') ? 'Bigha' : 'Acre'}';
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14532D),
            Color(0xFF1B6038),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Cultivation Expense',
                style: TextStyle(
                  color: Color(0xFFD1E7DD),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (costPerArea != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF08A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    costPerArea,
                    style: const TextStyle(
                      color: Color(0xFF854D0E),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '₹${overallTotal.toStringAsFixed(overallTotal.truncateToDouble() == overallTotal ? 0 : 2)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.8,
            ),
          ),
          const SizedBox(height: 14),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.15),
          ),

          const SizedBox(height: 12),

          // Category Quick Columns
          Row(
            children: [
              _buildMiniStat('Spray', '₹${sprayTotal.toStringAsFixed(0)}',
                  Icons.science_outlined),
              _buildMiniDivider(),
              _buildMiniStat('Fertilizer', '₹${fertTotal.toStringAsFixed(0)}',
                  Icons.inventory_2_outlined),
              _buildMiniDivider(),
              _buildMiniStat('Labor', '₹${laborTotal.toStringAsFixed(0)}',
                  Icons.groups_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF86EFAC), size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFFD1E7DD),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDivider() {
    return Container(
      height: 30,
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  // ==========================================
  // TAB 1: ALL EXPENSES LIST
  // ==========================================
  Widget _buildExpensesTab() {
    final allExpenses = (_selectedCropId == 'all')
        ? _expenseRepo.expenses
        : _expenseRepo.expenses
            .where((e) => e.cropId == _selectedCropId)
            .toList();

    final filtered = _filterCategory == null
        ? allExpenses
        : allExpenses.where((e) => e.category == _filterCategory).toList();

    return Column(
      children: [
        // Category Filter Chips
        Container(
          height: 38,
          margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: [
              _buildFilterCategoryPill(null, 'All Expenses'),
              _buildFilterCategoryPill(
                  ExpenseCategory.pesticide, 'Pesticide & Spray'),
              _buildFilterCategoryPill(
                  ExpenseCategory.fertilizer, 'Fertilizer'),
              _buildFilterCategoryPill(
                  ExpenseCategory.machinery, 'Machinery'),
              _buildFilterCategoryPill(
                  ExpenseCategory.seeds, 'Seeds'),
              _buildFilterCategoryPill(
                  ExpenseCategory.irrigation, 'Irrigation'),
            ],
          ),
        ),

        // List of Expenses
        Expanded(
          child: filtered.isEmpty
              ? _buildEmptyTab('No expenses found for this category')
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: filtered.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = filtered[index];
                    return _buildExpenseCard(item);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildFilterCategoryPill(ExpenseCategory? category, String label) {
    final isSelected = _filterCategory == category;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          setState(() {
            _filterCategory = isSelected ? null : category;
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFF14532D) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF14532D)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textTagline,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExpenseCard(CropExpenseItem item) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emblemBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Icon
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: item.category.color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(item.category.icon,
                color: item.category.color, size: 22),
          ),
          const SizedBox(width: 12),

          // Title & Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                    Text(
                      item.formattedAmount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.category.color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item.category.shortLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: item.category.color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '• ${item.cropName} • ${item.formattedDate}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    item.notes,
                    style: const TextStyle(
                      fontSize: 11.5,
                      color: Color(0xFF475569),
                    ),
                  ),
                ],
              ],
            ),
          ),

          IconButton(
            icon: const Icon(Icons.delete_outline_rounded,
                color: Color(0xFF94A3B8), size: 18),
            onPressed: () => _confirmDeleteExpense(item),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // TAB 2: LABOR WAGE LEDGER
  // ==========================================
  Widget _buildLaborTab() {
    final allLabor = (_selectedCropId == 'all')
        ? _expenseRepo.laborRecords
        : _expenseRepo.laborRecords
            .where((l) => l.cropId == _selectedCropId)
            .toList();

    final paidCount = allLabor.where((l) => l.isPaid).length;
    final pendingCount = allLabor.where((l) => !l.isPaid).length;

    return Column(
      children: [
        // Labor Quick Stats Strip
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.emblemBorder),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.people_outline_rounded,
                      color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    '${allLabor.length} Labor Entries',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTagline,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Paid: $paidCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF166534),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Pending: $pendingCount',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF991B1B),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Labor Cards
        Expanded(
          child: allLabor.isEmpty
              ? _buildEmptyTab('No labor wage records logged yet')
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: allLabor.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final labor = allLabor[index];
                    return _buildLaborCard(labor);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildLaborCard(LaborRecord labor) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: labor.isPaid
              ? AppColors.emblemBorder
              : const Color(0xFFFCA5A5),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Worker Group Name + Wage Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.groups_rounded,
                          color: Color(0xFF2563EB), size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        labor.workerName,
                        style: const TextStyle(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textBody,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                labor.formattedTotal,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Row 2: Calculation Breakdown Tag
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              children: [
                const Icon(Icons.calculate_outlined,
                    size: 15, color: AppColors.primary),
                const SizedBox(width: 6),
                Text(
                  labor.formattedCalculation,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF334155),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Row 3: Task + Status + Delete
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF4EE),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  labor.workType,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${labor.cropName} • ${labor.formattedDate}',
                style: const TextStyle(
                    fontSize: 11, color: AppColors.textSubtitle),
              ),
              const Spacer(),

              // Paid / Pending Toggle Button
              InkWell(
                onTap: () => _expenseRepo.toggleLaborPaid(labor.id),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: labor.isPaid
                        ? const Color(0xFFDCFCE7)
                        : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: labor.isPaid
                          ? const Color(0xFF86EFAC)
                          : const Color(0xFFFCA5A5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        labor.isPaid
                            ? Icons.check_circle_rounded
                            : Icons.pending_rounded,
                        size: 13,
                        color: labor.isPaid
                            ? const Color(0xFF166534)
                            : const Color(0xFF991B1B),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        labor.isPaid ? 'Paid' : 'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: labor.isPaid
                              ? const Color(0xFF166534)
                              : const Color(0xFF991B1B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              IconButton(
                icon: const Icon(Icons.delete_outline_rounded,
                    color: Color(0xFF94A3B8), size: 18),
                onPressed: () => _confirmDeleteLabor(labor),
              ),
            ],
          ),

          if (labor.notes.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              '📝 ${labor.notes}',
              style: const TextStyle(
                  fontSize: 11.5, color: AppColors.textSubtitle),
            ),
          ],
        ],
      ),
    );
  }

  // ==========================================
  // TAB 3: QUICK COST ESTIMATOR
  // ==========================================
  Widget _buildEstimatorTab() {
    return const _QuickCostEstimatorWidget();
  }

  Widget _buildEmptyTab(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined,
                size: 48, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSubtitle,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================
  // BOTTOM ACTION BAR
  // ==========================================
  Widget _buildBottomActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.emblemBorder)),
      ),
      child: Row(
        children: [
          // Add General Expense Button (Spray / Fertilizer)
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                CropExpenseCalculatorScreen.showAddExpenseModal(
                  context,
                  preselectedCropId:
                      _selectedCropId == 'all' ? null : _selectedCropId,
                );
              },
              icon: const Icon(Icons.add_shopping_cart_rounded,
                  size: 18, color: Colors.white),
              label: const Text(
                '+ Add Expense',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Add Labor Record Button
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                CropExpenseCalculatorScreen.showAddLaborModal(
                  context,
                  preselectedCropId:
                      _selectedCropId == 'all' ? null : _selectedCropId,
                );
              },
              icon: const Icon(Icons.person_add_rounded,
                  size: 18, color: AppColors.primary),
              label: const Text(
                '+ Add Labor',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primary, width: 1.5),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ========================================================
// MODAL SHEET 1: ADD GENERAL EXPENSE
// ========================================================
class _AddExpenseModalSheet extends StatefulWidget {
  final String? preselectedCropId;

  const _AddExpenseModalSheet({this.preselectedCropId});

  @override
  State<_AddExpenseModalSheet> createState() => _AddExpenseModalSheetState();
}

class _AddExpenseModalSheetState extends State<_AddExpenseModalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();

  late String _selectedCropId;
  ExpenseCategory _selectedCategory = ExpenseCategory.pesticide;
  DateTime _selectedDate = DateTime.now();

  final List<String> _quickSprayPresets = [
    'Chlorpyrifos Spray',
    'Monocrotophos Spray',
    'Acetamiprid 20% SP',
    'Coragen Bollworm Spray',
    'Neem Oil Spray',
    'Fungicide / Tebuconazole',
  ];

  final List<String> _quickFertilizerPresets = [
    'Urea (45 kg Bag)',
    'DAP (50 kg Bag)',
    'Potash (MOP)',
    'NPK 12:32:16',
    'Single Super Phosphate (SSP)',
    'Organic Compost / Manure',
  ];

  @override
  void initState() {
    super.initState();
    final crops = SownCropRepository.instance.crops;
    if (widget.preselectedCropId != null &&
        crops.any((c) => c.id == widget.preselectedCropId)) {
      _selectedCropId = widget.preselectedCropId!;
    } else if (crops.isNotEmpty) {
      _selectedCropId = crops.first.id;
    } else {
      _selectedCropId = 'general';
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _saveExpense() {
    if (!_formKey.currentState!.validate()) return;

    final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
    final crops = SownCropRepository.instance.crops;
    final crop = crops.firstWhere(
      (c) => c.id == _selectedCropId,
      orElse: () => SownCropModel(
        id: 'general',
        cropName: 'Farm General',
        sowingDate: DateTime.now(),
        landArea: 0,
        areaUnit: 'Acres',
      ),
    );

    final newExpense = CropExpenseItem(
      id: 'exp_${DateTime.now().millisecondsSinceEpoch}',
      cropId: _selectedCropId,
      cropName: crop.cropName,
      category: _selectedCategory,
      title: _titleController.text.trim(),
      amount: amount,
      date: _selectedDate,
      notes: _notesController.text.trim(),
    );

    CropExpenseRepository.instance.addExpense(newExpense);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '✅ ${newExpense.title} (${newExpense.formattedAmount}) logged!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crops = SownCropRepository.instance.crops;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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

              // Title
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Farm Expense',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTitle,
                        ),
                      ),
                      Text(
                        'Add sprays, fertilizers and farm costs',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        color: Color(0xFF64748B)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 1. SELECT SOWN CROP
              const Text(
                'Sown Crop *',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTagline),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FCF9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCropId,
                    isExpanded: true,
                    items: crops.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(
                          '${c.cropName} (${c.formattedArea})',
                          style: const TextStyle(fontSize: 13.5),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCropId = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // 2. EXPENSE CATEGORY
              const Text(
                'Expense Category *',
                style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textTagline),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildCatChip(ExpenseCategory.pesticide),
                  _buildCatChip(ExpenseCategory.fertilizer),
                  _buildCatChip(ExpenseCategory.machinery),
                  _buildCatChip(ExpenseCategory.seeds),
                  _buildCatChip(ExpenseCategory.irrigation),
                  _buildCatChip(ExpenseCategory.other),
                ],
              ),

              const SizedBox(height: 14),

              // Quick Presets
              if (_selectedCategory == ExpenseCategory.pesticide) ...[
                const Text('Popular Sprays:',
                    style:
                        TextStyle(fontSize: 11.5, color: AppColors.textSubtitle)),
                const SizedBox(height: 6),
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickSprayPresets.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, idx) {
                      return InkWell(
                        onTap: () => setState(() =>
                            _titleController.text = _quickSprayPresets[idx]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFFDE68A)),
                          ),
                          child: Text(
                            _quickSprayPresets[idx],
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF92400E)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
              ] else if (_selectedCategory == ExpenseCategory.fertilizer) ...[
                const Text('Popular Fertilizers:',
                    style:
                        TextStyle(fontSize: 11.5, color: AppColors.textSubtitle)),
                const SizedBox(height: 6),
                SizedBox(
                  height: 30,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _quickFertilizerPresets.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 6),
                    itemBuilder: (context, idx) {
                      return InkWell(
                        onTap: () => setState(() =>
                            _titleController.text = _quickFertilizerPresets[idx]),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFDCFCE7),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF86EFAC)),
                          ),
                          child: Text(
                            _quickFertilizerPresets[idx],
                            style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF166534)),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // 3. TITLE INPUT
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Expense Description *',
                  hintText: 'e.g. 2 bags Urea / Coragen Spray',
                  filled: true,
                  fillColor: const Color(0xFFF9FCF9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.inputBorder),
                  ),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Enter description' : null,
              ),

              const SizedBox(height: 14),

              // 4. AMOUNT INPUT
              TextFormField(
                controller: _amountController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Amount (₹) *',
                  hintText: 'e.g. 2500',
                  prefixText: '₹ ',
                  filled: true,
                  fillColor: const Color(0xFFF9FCF9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.inputBorder),
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) return 'Enter amount';
                  final num = double.tryParse(val.trim());
                  if (num == null || num <= 0) return 'Enter valid amount';
                  return null;
                },
              ),

              const SizedBox(height: 14),

              // 5. NOTES
              TextFormField(
                controller: _notesController,
                decoration: InputDecoration(
                  labelText: 'Notes / Dealer Name',
                  hintText: 'e.g. Purchased from Agro Center, Anand',
                  filled: true,
                  fillColor: const Color(0xFFF9FCF9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.inputBorder),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // Save Button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveExpense,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Save Expense',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCatChip(ExpenseCategory category) {
    final isSelected = _selectedCategory == category;
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => setState(() => _selectedCategory = category),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? category.color
              : category.color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? category.color
                : category.color.withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon,
                size: 14, color: isSelected ? Colors.white : category.color),
            const SizedBox(width: 4),
            Text(
              category.shortLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : category.color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ========================================================
// MODAL SHEET 2: ADD LABOR RECORD
// ========================================================
class _AddLaborModalSheet extends StatefulWidget {
  final String? preselectedCropId;

  const _AddLaborModalSheet({this.preselectedCropId});

  @override
  State<_AddLaborModalSheet> createState() => _AddLaborModalSheetState();
}

class _AddLaborModalSheetState extends State<_AddLaborModalSheet> {
  final _formKey = GlobalKey<FormState>();
  final _workerNameController = TextEditingController();
  final _workersCountController = TextEditingController(text: '4');
  final _wageController = TextEditingController(text: '350');
  final _daysController = TextEditingController(text: '1.0');
  final _notesController = TextEditingController();

  late String _selectedCropId;
  String _selectedWorkType = 'Weeding';
  bool _isPaid = true;

  final List<String> _workTypes = [
    'Weeding',
    'Pesticide Spray',
    'Harvesting / Picking',
    'Sowing / Transplanting',
    'Inter-cultivation',
    'Irrigation / Water',
    'Loading & Transport',
    'General Labor',
  ];

  @override
  void initState() {
    super.initState();
    final crops = SownCropRepository.instance.crops;
    if (widget.preselectedCropId != null &&
        crops.any((c) => c.id == widget.preselectedCropId)) {
      _selectedCropId = widget.preselectedCropId!;
    } else if (crops.isNotEmpty) {
      _selectedCropId = crops.first.id;
    } else {
      _selectedCropId = 'general';
    }
  }

  @override
  void dispose() {
    _workerNameController.dispose();
    _workersCountController.dispose();
    _wageController.dispose();
    _daysController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _calculatedWage {
    final workers = int.tryParse(_workersCountController.text.trim()) ?? 0;
    final wage = double.tryParse(_wageController.text.trim()) ?? 0.0;
    final days = double.tryParse(_daysController.text.trim()) ?? 0.0;
    return workers * wage * days;
  }

  void _saveLaborRecord() {
    if (!_formKey.currentState!.validate()) return;

    final workers = int.tryParse(_workersCountController.text.trim()) ?? 1;
    final wage = double.tryParse(_wageController.text.trim()) ?? 350.0;
    final days = double.tryParse(_daysController.text.trim()) ?? 1.0;

    final crops = SownCropRepository.instance.crops;
    final crop = crops.firstWhere(
      (c) => c.id == _selectedCropId,
      orElse: () => SownCropModel(
        id: 'general',
        cropName: 'General Farm',
        sowingDate: DateTime.now(),
        landArea: 0,
        areaUnit: 'Acres',
      ),
    );

    final newLabor = LaborRecord(
      id: 'lab_${DateTime.now().millisecondsSinceEpoch}',
      cropId: _selectedCropId,
      cropName: crop.cropName,
      workerName: _workerNameController.text.trim(),
      workersCount: workers,
      workType: _selectedWorkType,
      wagePerPerson: wage,
      daysWorked: days,
      date: DateTime.now(),
      isPaid: _isPaid,
      notes: _notesController.text.trim(),
    );

    CropExpenseRepository.instance.addLaborRecord(newLabor);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            '👥 ${newLabor.workerName} wage (${newLabor.formattedTotal}) saved!'),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crops = SownCropRepository.instance.crops;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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

              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add Labor Wage',
                        style: TextStyle(
                          fontSize: 18.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textTitle,
                        ),
                      ),
                      Text(
                        'Calculate laborers, daily wage and working days',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: AppColors.textSubtitle,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded,
                        color: Color(0xFF64748B)),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // 1. SOWN CROP DROPDOWN
              const Text('Crop *',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTagline)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FCF9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedCropId,
                    isExpanded: true,
                    items: crops.map((c) {
                      return DropdownMenuItem(
                        value: c.id,
                        child: Text(
                          '${c.cropName} (${c.formattedArea})',
                          style: const TextStyle(fontSize: 13.5),
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedCropId = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 2. WORKER / GROUP NAME
              TextFormField(
                controller: _workerNameController,
                decoration: InputDecoration(
                  labelText: 'Worker or Group Name *',
                  hintText: 'e.g. Ramesh Bhai / Village Women Group',
                  prefixIcon: const Icon(Icons.person_rounded,
                      color: AppColors.primary, size: 20),
                  filled: true,
                  fillColor: const Color(0xFFF9FCF9),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12)),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.inputBorder),
                  ),
                ),
                validator: (val) =>
                    val == null || val.trim().isEmpty ? 'Enter worker name' : null,
              ),

              const SizedBox(height: 14),

              // 3. WORK TYPE
              const Text('Work Type *',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textTagline)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF9FCF9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.inputBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedWorkType,
                    isExpanded: true,
                    items: _workTypes.map((t) {
                      return DropdownMenuItem(
                          value: t,
                          child: Text(t, style: const TextStyle(fontSize: 13)));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedWorkType = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 14),

              // 4. THREE CALCULATION FIELDS (Workers × Daily Wage × Days)
              Row(
                children: [
                  // Workers Count
                  Expanded(
                    child: TextFormField(
                      controller: _workersCountController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'No. of Laborers',
                        hintText: 'e.g. 4',
                        filled: true,
                        fillColor: const Color(0xFFF9FCF9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        final n = int.tryParse(val ?? '');
                        return (n == null || n <= 0) ? 'Required' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Daily Wage
                  Expanded(
                    child: TextFormField(
                      controller: _wageController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Daily Wage',
                        hintText: 'e.g. 350',
                        prefixText: '₹',
                        filled: true,
                        fillColor: const Color(0xFFF9FCF9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        final n = double.tryParse(val ?? '');
                        return (n == null || n <= 0) ? 'Required' : null;
                      },
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Days Worked
                  Expanded(
                    child: TextFormField(
                      controller: _daysController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      onChanged: (_) => setState(() {}),
                      decoration: InputDecoration(
                        labelText: 'Days',
                        hintText: 'e.g. 2',
                        filled: true,
                        fillColor: const Color(0xFFF9FCF9),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      validator: (val) {
                        final n = double.tryParse(val ?? '');
                        return (n == null || n <= 0) ? 'Required' : null;
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // LIVE TOTAL WAGE BANNER
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFBFDBFE)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.monetization_on_outlined,
                            color: Color(0xFF2563EB), size: 18),
                        SizedBox(width: 6),
                        Text(
                          'Calculated Total Wage:',
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      '₹${_calculatedWage.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E3A8A),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // PAYMENT STATUS
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Payment Status:',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textTagline)),
                  Row(
                    children: [
                      Text(
                        _isPaid ? 'Paid' : 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _isPaid
                              ? const Color(0xFF166534)
                              : const Color(0xFF991B1B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Switch(
                        value: _isPaid,
                        activeColor: AppColors.primary,
                        onChanged: (val) => setState(() => _isPaid = val),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // SUBMIT
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _saveLaborRecord,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text(
                    'Save Labor Record',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
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

// ========================================================
// COST ESTIMATOR WIDGET
// ========================================================
class _QuickCostEstimatorWidget extends StatefulWidget {
  const _QuickCostEstimatorWidget();

  @override
  State<_QuickCostEstimatorWidget> createState() =>
      _QuickCostEstimatorWidgetState();
}

class _QuickCostEstimatorWidgetState extends State<_QuickCostEstimatorWidget> {
  final _areaController = TextEditingController(text: '5.0');
  final _seedCostController = TextEditingController(text: '800');
  final _fertCostController = TextEditingController(text: '1200');
  final _sprayCostController = TextEditingController(text: '650');
  final _numSpraysController = TextEditingController(text: '3');
  final _laborDailyController = TextEditingController(text: '350');
  final _laborDaysController = TextEditingController(text: '8');
  final _tractorController = TextEditingController(text: '1000');

  String _unit = 'Acres';

  double get _totalEstimatedCost {
    final area = double.tryParse(_areaController.text.trim()) ?? 1.0;
    final seedPerArea =
        double.tryParse(_seedCostController.text.trim()) ?? 0.0;
    final fertPerArea =
        double.tryParse(_fertCostController.text.trim()) ?? 0.0;
    final sprayCost =
        double.tryParse(_sprayCostController.text.trim()) ?? 0.0;
    final numSprays =
        double.tryParse(_numSpraysController.text.trim()) ?? 0.0;
    final dailyLabor =
        double.tryParse(_laborDailyController.text.trim()) ?? 0.0;
    final laborDays =
        double.tryParse(_laborDaysController.text.trim()) ?? 0.0;
    final tractorPerArea =
        double.tryParse(_tractorController.text.trim()) ?? 0.0;

    final seeds = seedPerArea * area;
    final fert = fertPerArea * area;
    final sprays = sprayCost * numSprays * area;
    final labor = dailyLabor * laborDays;
    final tractor = tractorPerArea * area;

    return seeds + fert + sprays + labor + tractor;
  }

  @override
  Widget build(BuildContext context) {
    final total = _totalEstimatedCost;
    final area = double.tryParse(_areaController.text.trim()) ?? 1.0;
    final perUnit = area > 0 ? (total / area) : total;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Result Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF115E59)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Estimated Total Budget',
                      style: TextStyle(
                          color: Color(0xFF99F6E4),
                          fontSize: 12,
                          fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '₹${total.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Per $_unit',
                        style: const TextStyle(
                            color: Color(0xFFCCFBF1), fontSize: 10.5),
                      ),
                      Text(
                        '₹${perUnit.toStringAsFixed(0)}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          const Text(
            'Estimation Parameters:',
            style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textTagline),
          ),
          const SizedBox(height: 12),

          // Area & Unit
          Row(
            children: [
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: _areaController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Cultivated Land Area',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: DropdownButtonFormField<String>(
                  value: _unit,
                  decoration: const InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                  items: ['Acres', 'Bigha']
                      .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setState(() => _unit = val);
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Seeds & Fertilizer
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _seedCostController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Seeds (₹/$_unit)',
                    prefixText: '₹',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _fertCostController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Fertilizer (₹/$_unit)',
                    prefixText: '₹',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Spray Cost & Number of Sprays
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _sprayCostController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    labelText: 'Spray Cost (₹/$_unit)',
                    prefixText: '₹',
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _numSpraysController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'No. of Sprays',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Labor Daily Rate & Total Labor Days
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _laborDailyController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Daily Wage (₹)',
                    prefixText: '₹',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _laborDaysController,
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                  decoration: const InputDecoration(
                    labelText: 'Total Labor Days',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Tractor Tillage Charge
          TextFormField(
            controller: _tractorController,
            keyboardType: TextInputType.number,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              labelText: 'Tractor / Land Prep (₹/$_unit)',
              prefixText: '₹',
              border: const OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );
  }
}
