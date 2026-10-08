import 'package:flutter/foundation.dart';
import '../models/sown_crop_model.dart';

class SownCropRepository {
  SownCropRepository._internal() {
    cropsNotifier = ValueNotifier<List<SownCropModel>>(
      List.from(SownCropModel.initialSampleCrops),
    );
  }

  static final SownCropRepository instance = SownCropRepository._internal();

  late final ValueNotifier<List<SownCropModel>> cropsNotifier;

  List<SownCropModel> get crops => cropsNotifier.value;

  void addCrop(SownCropModel crop) {
    final updatedList = [crop, ...cropsNotifier.value];
    cropsNotifier.value = updatedList;
  }

  void removeCrop(String id) {
    final updatedList =
        cropsNotifier.value.where((crop) => crop.id != id).toList();
    cropsNotifier.value = updatedList;
  }

  void updateCrop(SownCropModel updatedCrop) {
    final updatedList = cropsNotifier.value.map((crop) {
      return crop.id == updatedCrop.id ? updatedCrop : crop;
    }).toList();
    cropsNotifier.value = updatedList;
  }

  int get totalActiveCropsCount {
    return cropsNotifier.value
        .where((c) => c.growthStage != 'Harvested')
        .length;
  }

  String get totalAreaSummary {
    double totalAcres = 0;
    double totalBigha = 0;

    for (final crop in cropsNotifier.value) {
      if (crop.areaUnit.toLowerCase().contains('acre')) {
        totalAcres += crop.landArea;
      } else if (crop.areaUnit.toLowerCase().contains('bigha')) {
        totalBigha += crop.landArea;
      } else {
        totalAcres += crop.landArea;
      }
    }

    final parts = <String>[];
    if (totalAcres > 0) {
      parts.add(
          '${totalAcres.toStringAsFixed(totalAcres.truncateToDouble() == totalAcres ? 0 : 1)} Acres');
    }
    if (totalBigha > 0) {
      parts.add(
          '${totalBigha.toStringAsFixed(totalBigha.truncateToDouble() == totalBigha ? 0 : 1)} Bigha');
    }

    return parts.isEmpty ? '0 Acres' : parts.join(' + ');
  }
}
