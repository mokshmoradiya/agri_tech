import 'package:flutter/foundation.dart';
import '../models/farmer_profile_model.dart';

class FarmerProfileRepository {
  FarmerProfileRepository._internal() {
    profileNotifier = ValueNotifier<FarmerProfileModel>(
      FarmerProfileModel.defaultProfile,
    );
  }

  static final FarmerProfileRepository instance =
      FarmerProfileRepository._internal();

  late final ValueNotifier<FarmerProfileModel> profileNotifier;

  FarmerProfileModel get profile => profileNotifier.value;

  void updateProfile(FarmerProfileModel updated) {
    profileNotifier.value = updated;
  }

  bool verifyPassword(String currentPassword) {
    return profileNotifier.value.password == currentPassword;
  }

  bool changePassword(String currentPassword, String newPassword) {
    if (verifyPassword(currentPassword)) {
      profileNotifier.value = profileNotifier.value.copyWith(
        password: newPassword,
      );
      return true;
    }
    return false;
  }

  void resetToDefault() {
    profileNotifier.value = FarmerProfileModel.defaultProfile;
  }
}
