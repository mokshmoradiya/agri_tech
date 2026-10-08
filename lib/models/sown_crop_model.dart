class SownCropModel {
  final String id;
  final String cropName;
  final DateTime sowingDate;
  final double landArea;
  final String areaUnit; // 'Acres', 'Bigha', 'Hectares', 'Guntha'
  final String season; // 'Kharif (Monsoon)', 'Rabi (Winter)', 'Zaid (Summer)'
  final String growthStage; // 'Germination', 'Vegetative', 'Flowering', 'Maturity', 'Harvested'
  final String plotName; // e.g. 'Plot 1', 'Main Farm'
  final String notes;

  const SownCropModel({
    required this.id,
    required this.cropName,
    required this.sowingDate,
    required this.landArea,
    required this.areaUnit,
    this.season = 'Kharif',
    this.growthStage = 'Growing',
    this.plotName = 'Main Plot',
    this.notes = '',
  });

  String get formattedArea {
    final areaStr = landArea.toStringAsFixed(
      landArea.truncateToDouble() == landArea ? 0 : 1,
    );
    return '$areaStr $areaUnit';
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
    final monthName = months[sowingDate.month - 1];
    return '${sowingDate.day.toString().padLeft(2, '0')} $monthName ${sowingDate.year}';
  }

  int get daysSinceSown {
    return DateTime.now().difference(sowingDate).inDays;
  }

  SownCropModel copyWith({
    String? id,
    String? cropName,
    DateTime? sowingDate,
    double? landArea,
    String? areaUnit,
    String? season,
    String? growthStage,
    String? plotName,
    String? notes,
  }) {
    return SownCropModel(
      id: id ?? this.id,
      cropName: cropName ?? this.cropName,
      sowingDate: sowingDate ?? this.sowingDate,
      landArea: landArea ?? this.landArea,
      areaUnit: areaUnit ?? this.areaUnit,
      season: season ?? this.season,
      growthStage: growthStage ?? this.growthStage,
      plotName: plotName ?? this.plotName,
      notes: notes ?? this.notes,
    );
  }

  static List<SownCropModel> get initialSampleCrops => [
        SownCropModel(
          id: 'crop_1',
          cropName: 'Cotton (BT-2)',
          sowingDate: DateTime.now().subtract(const Duration(days: 75)),
          landArea: 4.5,
          areaUnit: 'Acres',
          season: 'Kharif',
          growthStage: 'Flowering',
          plotName: 'Plot A (North Canal)',
          notes: 'Drip irrigation installed. Good vegetative growth.',
        ),
        SownCropModel(
          id: 'crop_2',
          cropName: 'Groundnut (GG-20)',
          sowingDate: DateTime.now().subtract(const Duration(days: 42)),
          landArea: 6.0,
          areaUnit: 'Bigha',
          season: 'Kharif',
          growthStage: 'Vegetative',
          plotName: 'Plot B (Tubewell)',
          notes: 'First weeding completed. Gypsum application planned.',
        ),
        SownCropModel(
          id: 'crop_3',
          cropName: 'Wheat (GW-496)',
          sowingDate: DateTime.now().subtract(const Duration(days: 140)),
          landArea: 3.0,
          areaUnit: 'Acres',
          season: 'Rabi',
          growthStage: 'Harvested',
          plotName: 'East Field',
          notes: 'High yield achieved: 22 quintals/acre.',
        ),
      ];
}
