import 'package:flutter/foundation.dart';
import '../models/crop_expense_model.dart';

class CropExpenseRepository {
  CropExpenseRepository._internal() {
    expensesNotifier = ValueNotifier<List<CropExpenseItem>>(_initialExpenses);
    laborNotifier = ValueNotifier<List<LaborRecord>>(_initialLaborRecords);
  }

  static final CropExpenseRepository instance =
      CropExpenseRepository._internal();

  late final ValueNotifier<List<CropExpenseItem>> expensesNotifier;
  late final ValueNotifier<List<LaborRecord>> laborNotifier;

  List<CropExpenseItem> get expenses => expensesNotifier.value;
  List<LaborRecord> get laborRecords => laborNotifier.value;

  void addExpense(CropExpenseItem item) {
    expensesNotifier.value = [item, ...expensesNotifier.value];
  }

  void removeExpense(String id) {
    expensesNotifier.value =
        expensesNotifier.value.where((e) => e.id != id).toList();
  }

  void addLaborRecord(LaborRecord record) {
    laborNotifier.value = [record, ...laborNotifier.value];
  }

  void removeLaborRecord(String id) {
    laborNotifier.value =
        laborNotifier.value.where((l) => l.id != id).toList();
  }

  void toggleLaborPaid(String id) {
    laborNotifier.value = laborNotifier.value.map((l) {
      return l.id == id ? l.copyWith(isPaid: !l.isPaid) : l;
    }).toList();
  }

  // =====================
  // CALCULATIONS
  // =====================
  double getTotalGeneralExpenses([String? cropId]) {
    final list = (cropId == null || cropId == 'all')
        ? expensesNotifier.value
        : expensesNotifier.value.where((e) => e.cropId == cropId).toList();
    return list.fold(0.0, (sum, item) => sum + item.amount);
  }

  double getTotalLaborExpense([String? cropId]) {
    final list = (cropId == null || cropId == 'all')
        ? laborNotifier.value
        : laborNotifier.value.where((l) => l.cropId == cropId).toList();
    return list.fold(0.0, (sum, item) => sum + item.totalWage);
  }

  double getTotalOverallExpense([String? cropId]) {
    return getTotalGeneralExpenses(cropId) + getTotalLaborExpense(cropId);
  }

  double getCategoryTotal(ExpenseCategory category, [String? cropId]) {
    if (category == ExpenseCategory.labor) {
      return getTotalLaborExpense(cropId);
    }
    final list = (cropId == null || cropId == 'all')
        ? expensesNotifier.value.where((e) => e.category == category)
        : expensesNotifier.value
            .where((e) => e.cropId == cropId && e.category == category);
    return list.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Pre-populated initial real farming data
  static final List<CropExpenseItem> _initialExpenses = [
    CropExpenseItem(
      id: 'exp_1',
      cropId: 'crop_1',
      cropName: 'Cotton (BT-2)',
      category: ExpenseCategory.pesticide,
      title: 'Monocrotophos & Acetamiprid Spray',
      amount: 3200,
      date: DateTime.now().subtract(const Duration(days: 12)),
      notes: '12 pump spray against whitefly and thrips infestation.',
    ),
    CropExpenseItem(
      id: 'exp_2',
      cropId: 'crop_1',
      cropName: 'Cotton (BT-2)',
      category: ExpenseCategory.fertilizer,
      title: '2 Bags DAP + 3 Bags Urea',
      amount: 4150,
      date: DateTime.now().subtract(const Duration(days: 28)),
      notes: 'Basal dose applied during inter-cultivation.',
    ),
    CropExpenseItem(
      id: 'exp_3',
      cropId: 'crop_1',
      cropName: 'Cotton (BT-2)',
      category: ExpenseCategory.pesticide,
      title: 'Second Neem Oil + Chlorpyrifos Spray',
      amount: 2400,
      date: DateTime.now().subtract(const Duration(days: 4)),
      notes: 'Preventive bollworm protection spray.',
    ),
    CropExpenseItem(
      id: 'exp_4',
      cropId: 'crop_1',
      cropName: 'Cotton (BT-2)',
      category: ExpenseCategory.machinery,
      title: 'Tractor Rotavator & Deep Plowing',
      amount: 4500,
      date: DateTime.now().subtract(const Duration(days: 74)),
      notes: 'Field preparation before sowing 4.5 acres.',
    ),
    CropExpenseItem(
      id: 'exp_5',
      cropId: 'crop_2',
      cropName: 'Groundnut (GG-20)',
      category: ExpenseCategory.fertilizer,
      title: 'Single Super Phosphate (SSP) + Gypsum',
      amount: 2800,
      date: DateTime.now().subtract(const Duration(days: 20)),
      notes: 'Essential for pod filling and sulfur nutrition.',
    ),
    CropExpenseItem(
      id: 'exp_6',
      cropId: 'crop_2',
      cropName: 'Groundnut (GG-20)',
      category: ExpenseCategory.pesticide,
      title: 'Tebuconazole Spray for Tikka Disease',
      amount: 1750,
      date: DateTime.now().subtract(const Duration(days: 9)),
      notes: 'Foliar spray across 6 bigha plot.',
    ),
  ];

  static final List<LaborRecord> _initialLaborRecords = [
    LaborRecord(
      id: 'lab_1',
      cropId: 'crop_1',
      cropName: 'Cotton (BT-2)',
      workerName: 'Village Labor Group (Ramesh & Team)',
      workersCount: 4,
      workType: 'Weeding',
      wagePerPerson: 350,
      daysWorked: 2.0,
      date: DateTime.now().subtract(const Duration(days: 15)),
      isPaid: true,
      notes: 'Manual weeding in rows 1 to 24.',
    ),
    LaborRecord(
      id: 'lab_2',
      cropId: 'crop_1',
      cropName: 'Cotton (BT-2)',
      workerName: 'Specialist Spray Workers',
      workersCount: 2,
      workType: 'Pesticide Spray',
      wagePerPerson: 450,
      daysWorked: 1.0,
      date: DateTime.now().subtract(const Duration(days: 12)),
      isPaid: true,
      notes: 'Knapsack battery pump spraying.',
    ),
    LaborRecord(
      id: 'lab_3',
      cropId: 'crop_2',
      cropName: 'Groundnut (GG-20)',
      workerName: 'Manual Weeding Group',
      workersCount: 5,
      workType: 'Weeding',
      wagePerPerson: 320,
      daysWorked: 2.0,
      date: DateTime.now().subtract(const Duration(days: 18)),
      isPaid: false,
      notes: 'Second weeding payment pending after Saturday market.',
    ),
  ];
}
