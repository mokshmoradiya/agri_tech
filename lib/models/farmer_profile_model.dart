class FarmerProfileModel {
  final String fullName;
  final String phoneNumber;
  final String village;
  final String district;
  final double totalLandArea;
  final String landUnit; // 'Acres', 'Bigha', 'Hectares'
  final String farmingType; // 'Organic Farming', 'Conventional', 'Mixed Farming'
  final String primaryCrops;
  final String kisanId;
  final int avatarIndex;
  final String password;

  const FarmerProfileModel({
    required this.fullName,
    required this.phoneNumber,
    required this.village,
    required this.district,
    required this.totalLandArea,
    required this.landUnit,
    required this.farmingType,
    required this.primaryCrops,
    required this.kisanId,
    required this.avatarIndex,
    this.password = 'farmer123',
  });

  String get formattedLocation => '$village, $district';
  String get formattedLandArea =>
      '${totalLandArea.toStringAsFixed(totalLandArea.truncateToDouble() == totalLandArea ? 0 : 1)} $landUnit';

  FarmerProfileModel copyWith({
    String? fullName,
    String? phoneNumber,
    String? village,
    String? district,
    double? totalLandArea,
    String? landUnit,
    String? farmingType,
    String? primaryCrops,
    String? kisanId,
    int? avatarIndex,
    String? password,
  }) {
    return FarmerProfileModel(
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      village: village ?? this.village,
      district: district ?? this.district,
      totalLandArea: totalLandArea ?? this.totalLandArea,
      landUnit: landUnit ?? this.landUnit,
      farmingType: farmingType ?? this.farmingType,
      primaryCrops: primaryCrops ?? this.primaryCrops,
      kisanId: kisanId ?? this.kisanId,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      password: password ?? this.password,
    );
  }

  static const FarmerProfileModel defaultProfile = FarmerProfileModel(
    fullName: 'Ramesh Patel',
    phoneNumber: '+91 98765 43210',
    village: 'Boriavi',
    district: 'Anand, Gujarat',
    totalLandArea: 8.5,
    landUnit: 'Acres',
    farmingType: 'Organic & Modern Farming',
    primaryCrops: 'Cotton, Wheat, Tobacco',
    kisanId: 'GJ-AND-2024-8849',
    avatarIndex: 0,
    password: 'farmer123',
  );
}
