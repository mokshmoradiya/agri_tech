import 'package:flutter/material.dart';

enum ExpenseCategory {
  pesticide, // Pesticides, Insecticides, Weedicide Spray
  fertilizer, // Fertilizer & Nutrients (Urea, DAP, Potash, Manure)
  labor, // Labor Wages (Weeding, Sowing, Harvesting wages)
  seeds, // Seeds & Seedlings (Certified seeds, hybrid seedlings)
  machinery, // Tractor & Machinery (Tractor plowing, rotavator, thresher)
  irrigation, // Irrigation & Power (Diesel, tubewell electricity, canal water)
  other, // Miscellaneous (Bags, transport, packaging)
}

extension ExpenseCategoryExtension on ExpenseCategory {
  String get displayName {
    switch (this) {
      case ExpenseCategory.pesticide:
        return 'Pesticide & Spray';
      case ExpenseCategory.fertilizer:
        return 'Fertilizer & Nutrients';
      case ExpenseCategory.labor:
        return 'Labor Wages';
      case ExpenseCategory.seeds:
        return 'Seeds & Seedlings';
      case ExpenseCategory.machinery:
        return 'Tractor & Machinery';
      case ExpenseCategory.irrigation:
        return 'Irrigation & Power';
      case ExpenseCategory.other:
        return 'Miscellaneous';
    }
  }

  String get shortLabel {
    switch (this) {
      case ExpenseCategory.pesticide:
        return 'Pesticide';
      case ExpenseCategory.fertilizer:
        return 'Fertilizer';
      case ExpenseCategory.labor:
        return 'Labor';
      case ExpenseCategory.seeds:
        return 'Seeds';
      case ExpenseCategory.machinery:
        return 'Machinery';
      case ExpenseCategory.irrigation:
        return 'Irrigation';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  String get gujaratiLabel => shortLabel;

  IconData get icon {
    switch (this) {
      case ExpenseCategory.pesticide:
        return Icons.science_outlined;
      case ExpenseCategory.fertilizer:
        return Icons.inventory_2_outlined;
      case ExpenseCategory.labor:
        return Icons.groups_outlined;
      case ExpenseCategory.seeds:
        return Icons.eco_outlined;
      case ExpenseCategory.machinery:
        return Icons.agriculture_outlined;
      case ExpenseCategory.irrigation:
        return Icons.water_drop_outlined;
      case ExpenseCategory.other:
        return Icons.receipt_long_outlined;
    }
  }

  Color get color {
    switch (this) {
      case ExpenseCategory.pesticide:
        return const Color(0xFFD97706); // Amber
      case ExpenseCategory.fertilizer:
        return const Color(0xFF059669); // Emerald
      case ExpenseCategory.labor:
        return const Color(0xFF2563EB); // Royal Blue
      case ExpenseCategory.seeds:
        return const Color(0xFF16A34A); // Green
      case ExpenseCategory.machinery:
        return const Color(0xFFDC2626); // Crimson
      case ExpenseCategory.irrigation:
        return const Color(0xFF0284C7); // Sky Blue
      case ExpenseCategory.other:
        return const Color(0xFF64748B); // Slate
    }
  }
}

class CropExpenseItem {
  final String id;
  final String cropId;
  final String cropName;
  final ExpenseCategory category;
  final String title;
  final double amount;
  final DateTime date;
  final String notes;

  const CropExpenseItem({
    required this.id,
    required this.cropId,
    required this.cropName,
    required this.category,
    required this.title,
    required this.amount,
    required this.date,
    this.notes = '',
  });

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final monthName = months[date.month - 1];
    return '${date.day.toString().padLeft(2, '0')} $monthName ${date.year}';
  }

  String get formattedAmount {
    return '₹${amount.toStringAsFixed(amount.truncateToDouble() == amount ? 0 : 2)}';
  }

  CropExpenseItem copyWith({
    String? id,
    String? cropId,
    String? cropName,
    ExpenseCategory? category,
    String? title,
    double? amount,
    DateTime? date,
    String? notes,
  }) {
    return CropExpenseItem(
      id: id ?? this.id,
      cropId: cropId ?? this.cropId,
      cropName: cropName ?? this.cropName,
      category: category ?? this.category,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      date: date ?? this.date,
      notes: notes ?? this.notes,
    );
  }
}

class LaborRecord {
  final String id;
  final String cropId;
  final String cropName;
  final String workerName;
  final int workersCount;
  final String workType; // 'Weeding', 'Pesticide Spray', 'Harvesting', 'Sowing', 'Tractor Operation'
  final double wagePerPerson;
  final double daysWorked;
  final DateTime date;
  final bool isPaid;
  final String notes;

  const LaborRecord({
    required this.id,
    required this.cropId,
    required this.cropName,
    required this.workerName,
    required this.workersCount,
    required this.workType,
    required this.wagePerPerson,
    required this.daysWorked,
    required this.date,
    this.isPaid = true,
    this.notes = '',
  });

  double get totalWage => workersCount * wagePerPerson * daysWorked;

  String get formattedTotal {
    return '₹${totalWage.toStringAsFixed(totalWage.truncateToDouble() == totalWage ? 0 : 2)}';
  }

  String get formattedCalculation {
    return '$workersCount workers × ₹${wagePerPerson.toStringAsFixed(0)} × ${daysWorked.toStringAsFixed(daysWorked.truncateToDouble() == daysWorked ? 0 : 1)} days';
  }

  String get formattedDate {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    final monthName = months[date.month - 1];
    return '${date.day.toString().padLeft(2, '0')} $monthName ${date.year}';
  }

  LaborRecord copyWith({
    String? id,
    String? cropId,
    String? cropName,
    String? workerName,
    int? workersCount,
    String? workType,
    double? wagePerPerson,
    double? daysWorked,
    DateTime? date,
    bool? isPaid,
    String? notes,
  }) {
    return LaborRecord(
      id: id ?? this.id,
      cropId: cropId ?? this.cropId,
      cropName: cropName ?? this.cropName,
      workerName: workerName ?? this.workerName,
      workersCount: workersCount ?? this.workersCount,
      workType: workType ?? this.workType,
      wagePerPerson: wagePerPerson ?? this.wagePerPerson,
      daysWorked: daysWorked ?? this.daysWorked,
      date: date ?? this.date,
      isPaid: isPaid ?? this.isPaid,
      notes: notes ?? this.notes,
    );
  }
}
