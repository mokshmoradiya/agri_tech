import 'package:flutter/material.dart';
import '../models/farmer_profile_model.dart';
import '../resources/app_colors.dart';
import '../services/farmer_profile_repository.dart';

class EditProfileModal extends StatefulWidget {
  const EditProfileModal({super.key});

  static const List<Map<String, dynamic>> avatarOptions = [
    {'icon': Icons.agriculture_rounded, 'color': Color(0xFF14532D), 'label': 'General'},
    {'icon': Icons.person_rounded, 'color': Color(0xFFD97706), 'label': 'Farmer'},
    {'icon': Icons.eco_rounded, 'color': Color(0xFF059669), 'label': 'Organic'},
    {'icon': Icons.spa_rounded, 'color': Color(0xFF0284C7), 'label': 'Modern'},
  ];

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const EditProfileModal(),
    );
  }

  @override
  State<EditProfileModal> createState() => _EditProfileModalState();
}

class _EditProfileModalState extends State<EditProfileModal> {
  final _formKey = GlobalKey<FormState>();
  final FarmerProfileRepository _repo = FarmerProfileRepository.instance;

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _villageController;
  late TextEditingController _districtController;
  late TextEditingController _landAreaController;
  late TextEditingController _cropsController;

  late String _selectedLandUnit;
  late String _selectedFarmingType;
  late int _selectedAvatarIndex;

  final List<String> _landUnits = ['Acres', 'Bigha', 'Hectares', 'Guntha'];
  final List<String> _farmingTypes = [
    'Organic & Modern Farming',
    'Conventional Farming',
    'Natural Zero-Budget Farming',
    'Mixed Crop & Dairy',
    'Horticulture & Fruits',
  ];

  @override
  void initState() {
    super.initState();
    final profile = _repo.profile;
    _nameController = TextEditingController(text: profile.fullName);
    _phoneController = TextEditingController(text: profile.phoneNumber);
    _villageController = TextEditingController(text: profile.village);
    _districtController = TextEditingController(text: profile.district);
    _landAreaController =
        TextEditingController(text: profile.totalLandArea.toString());
    _cropsController = TextEditingController(text: profile.primaryCrops);

    _selectedLandUnit = _landUnits.contains(profile.landUnit)
        ? profile.landUnit
        : _landUnits.first;
    _selectedFarmingType = _farmingTypes.contains(profile.farmingType)
        ? profile.farmingType
        : _farmingTypes.first;
    _selectedAvatarIndex =
        profile.avatarIndex.clamp(0, EditProfileModal.avatarOptions.length - 1);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _villageController.dispose();
    _districtController.dispose();
    _landAreaController.dispose();
    _cropsController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (!_formKey.currentState!.validate()) return;

    final parsedArea =
        double.tryParse(_landAreaController.text.trim()) ?? _repo.profile.totalLandArea;

    final updated = _repo.profile.copyWith(
      fullName: _nameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      village: _villageController.text.trim(),
      district: _districtController.text.trim(),
      totalLandArea: parsedArea,
      landUnit: _selectedLandUnit,
      farmingType: _selectedFarmingType,
      primaryCrops: _cropsController.text.trim(),
      avatarIndex: _selectedAvatarIndex,
    );

    _repo.updateProfile(updated);

    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Farmer profile updated successfully!',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: const EdgeInsets.only(top: 12, bottom: 8),
              width: 44,
              height: 4.5,
              decoration: BoxDecoration(
                color: const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.manage_accounts_rounded,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Edit Farmer Profile',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textTitle,
                      ),
                    ),
                    Text(
                      'Update farmer details & preferences',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSubtitle,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: Color(0xFFE2E8F0)),

          // Form Body
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 20 + bottomInset),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Avatar Picker
                    const Text(
                      'Choose Profile Avatar:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textTagline,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                          EditProfileModal.avatarOptions.length, (idx) {
                        final option = EditProfileModal.avatarOptions[idx];
                        final isSelected = _selectedAvatarIndex == idx;
                        return InkWell(
                          onTap: () => setState(() => _selectedAvatarIndex = idx),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (option['color'] as Color).withValues(alpha: 0.15)
                                  : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected
                                    ? (option['color'] as Color)
                                    : const Color(0xFFE2E8F0),
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                CircleAvatar(
                                  radius: 24,
                                  backgroundColor: (option['color'] as Color)
                                      .withValues(alpha: 0.2),
                                  child: Icon(
                                    option['icon'] as IconData,
                                    color: option['color'] as Color,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  option['label'] as String,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSelected
                                        ? FontWeight.w700
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? (option['color'] as Color)
                                        : const Color(0xFF64748B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(height: 20),

                    // Full Name
                    _buildFieldLabel('Farmer Full Name *'),
                    TextFormField(
                      controller: _nameController,
                      decoration: _inputDecoration(
                        hint: 'e.g. Ramesh Patel',
                        icon: Icons.person_outline_rounded,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Phone Number
                    _buildFieldLabel('Mobile Number *'),
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: _inputDecoration(
                        hint: 'e.g. +91 98765 43210',
                        icon: Icons.phone_outlined,
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'Please enter mobile number';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Village & District Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Village *'),
                              TextFormField(
                                controller: _villageController,
                                decoration: _inputDecoration(
                                  hint: 'e.g. Boriavi',
                                  icon: Icons.home_work_outlined,
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('District *'),
                              TextFormField(
                                controller: _districtController,
                                decoration: _inputDecoration(
                                  hint: 'e.g. Anand, Gujarat',
                                  icon: Icons.location_on_outlined,
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Required';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Land Area & Unit Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Total Land Area *'),
                              TextFormField(
                                controller: _landAreaController,
                                keyboardType:
                                    const TextInputType.numberWithOptions(decimal: true),
                                decoration: _inputDecoration(
                                  hint: 'e.g. 8.5',
                                  icon: Icons.landscape_outlined,
                                ),
                                validator: (val) {
                                  if (val == null || val.trim().isEmpty) {
                                    return 'Enter land size';
                                  }
                                  final num = double.tryParse(val.trim());
                                  if (num == null || num <= 0) {
                                    return 'Enter valid number';
                                  }
                                  return null;
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFieldLabel('Land Unit'),
                              DropdownButtonFormField<String>(
                                value: _selectedLandUnit,
                                decoration: _inputDecoration(
                                  hint: 'Unit',
                                  icon: Icons.square_foot_rounded,
                                ),
                                items: _landUnits
                                    .map((u) => DropdownMenuItem(value: u, child: Text(u)))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    setState(() => _selectedLandUnit = val);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // Farming Type Dropdown
                    _buildFieldLabel('Farming Practice Type'),
                    DropdownButtonFormField<String>(
                      value: _selectedFarmingType,
                      isExpanded: true,
                      decoration: _inputDecoration(
                        hint: 'Select Farming Type',
                        icon: Icons.psychology_alt_rounded,
                      ),
                      items: _farmingTypes
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t, style: const TextStyle(fontSize: 13)),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() => _selectedFarmingType = val);
                        }
                      },
                    ),

                    const SizedBox(height: 16),

                    // Primary Crops
                    _buildFieldLabel('Primary Crops Grown'),
                    TextFormField(
                      controller: _cropsController,
                      decoration: _inputDecoration(
                        hint: 'e.g. Cotton, Wheat, Groundnut',
                        icon: Icons.grass_rounded,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _saveProfile,
                        icon: const Icon(Icons.check_rounded, color: Colors.white),
                        label: const Text(
                          'Save Changes',
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
          ),
        ],
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: AppColors.textTagline,
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 13, color: AppColors.textHint),
      prefixIcon: Icon(icon, color: AppColors.primary, size: 20),
      filled: true,
      fillColor: const Color(0xFFF8FAFC),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primary, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
    );
  }
}
