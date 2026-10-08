import 'package:flutter/material.dart';
import '../resources/app_assets.dart';

class FertilizerStage {
  final String stage;
  final String nutrient;

  const FertilizerStage({
    required this.stage,
    required this.nutrient,
  });
}

class CropModel {
  final String id;
  final String name;
  final String scientificName;
  final String description;
  final String paakTime; // Harvest & Maturity Duration
  final String shinchiyeTime; // Irrigation Schedule
  final String bestSoil; // Best Soil
  final String temperature; // Ideal Temperature
  final String sowingTime; // Sowing Time
  final String seedRate; // Seed Rate
  final String imageUrl; // High-resolution crop imagery
  final List<FertilizerStage> fertilizerSchedule;
  final Color themeColor;
  final IconData icon;

  const CropModel({
    required this.id,
    required this.name,
    required this.scientificName,
    required this.description,
    required this.paakTime,
    required this.shinchiyeTime,
    required this.bestSoil,
    required this.temperature,
    required this.sowingTime,
    required this.seedRate,
    required this.imageUrl,
    required this.fertilizerSchedule,
    required this.themeColor,
    required this.icon,
  });

  static List<CropModel> get sampleCrops => [
        // 1. Cotton
        const CropModel(
          id: 'cotton',
          name: 'Cotton',
          scientificName: 'Gossypium hirsutum',
          description:
              'Cotton is a major cash crop in India. BT Cotton varieties are specifically engineered to provide resistance against bollworms, leading to higher yields and reduced pesticide usage. It thrives in tropical and subtropical regions.',
          paakTime: '150 - 180 Days (Maturity Duration)',
          sowingTime: 'April - May',
          seedRate: '2 - 3 Kg / Acre',
          shinchiyeTime:
              'Irrigate every 12 to 15 days. Critical stages: Flowering, Square formation, and Boll development. Avoid waterlogging during vegetative stages.',
          bestSoil: 
              'Deep, well-drained black clayey soils (Regur) are best. Ideal pH 6.0 to 8.0.',
          temperature:
              'Ideal 21°C to 30°C. Requires at least 180 frost-free sunny days.',
          imageUrl: AppAssets.cottonCrop,
          fertilizerSchedule: [
            FertilizerStage(
              stage: 'Basal Dose',
              nutrient: '50% N, 100% P & K (DAP + Potash)',
            ),
            FertilizerStage(
              stage: 'Top Dressing (30 Days)',
              nutrient: '25% Nitrogen (Urea application)',
            ),
            FertilizerStage(
              stage: 'Top Dressing (60 Days)',
              nutrient: '25% Nitrogen + Micronutrient Boron/Zinc',
            ),
          ],
          themeColor: Color(0xFF1B6038),
          icon: Icons.cloud_outlined,
        ),

        // 2. Wheat
        const CropModel(
          id: 'wheat',
          name: 'Wheat',
          scientificName: 'Triticum aestivum',
          description:
              'Wheat is the premier cereal crop of the Rabi season. High-yielding certified varieties ensure superior grain quality and high market value. It requires cool winter conditions and dry, sunny harvest weather.',
          paakTime: '110 - 125 Days (Maturity Duration)',
          sowingTime: 'November 1 - November 25',
          seedRate: '40 - 45 Kg / Acre',
          shinchiyeTime:
              'Requires 4 to 6 critical irrigations: Crown Root Initiation (CRI) at 21 days, Tillering, Jointing, Flowering, and Grain Filling stages.',
          bestSoil:
              'Well-drained fertile loam and clay-loam soils with neutral pH 6.5 to 7.5.',
          temperature:
              'Optimum 15°C to 20°C during germination and growth; 25°C at maturity.',
          imageUrl:
              'https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?auto=format&fit=crop&w=800&q=80',
          fertilizerSchedule: [
            FertilizerStage(
              stage: 'Basal Dose',
              nutrient: '50% N, 100% P & K (55 kg DAP + 20 kg Potash)',
            ),
            FertilizerStage(
              stage: '1st Irrigation (21 Days)',
              nutrient: '25% Nitrogen (35 kg Urea at CRI stage)',
            ),
            FertilizerStage(
              stage: '2nd Irrigation (45 Days)',
              nutrient: '25% Nitrogen (Remaining Urea dose)',
            ),
          ],
          themeColor: Color(0xFFB45309),
          icon: Icons.grain_rounded,
        ),

        // 3. Rice
        const CropModel(
          id: 'rice',
          name: 'Rice',
          scientificName: 'Oryza sativa',
          description:
              'Paddy (Rice) is the primary staple food grain in India cultivated in flooded lowland fields during Kharif season. Modern varieties offer high disease tolerance and premium grain aroma.',
          paakTime: '120 - 140 Days (Maturity Duration)',
          sowingTime: 'June - July (Nursery in May)',
          seedRate: '12 - 15 Kg / Acre (Transplanted)',
          shinchiyeTime:
              'Maintain 2 to 5 cm standing water from transplanting until flowering. Drain excess water 10 days before harvest.',
          bestSoil:
              'Heavy clay or clay-loam soils with high water-retention capacity. pH 5.5 to 7.0.',
          temperature:
              'Warm, humid climate; ideal 24°C to 35°C with abundant sunlight.',
          imageUrl: AppAssets.riceCrop,
          fertilizerSchedule: [
            FertilizerStage(
              stage: 'Basal (Puddling)',
              nutrient: '50% N, 100% P, 50% K + 10 kg Zinc Sulphate',
            ),
            FertilizerStage(
              stage: 'Active Tillering (25 Days)',
              nutrient: '25% Nitrogen (Top dress Urea)',
            ),
            FertilizerStage(
              stage: 'Panicle Initiation (50 Days)',
              nutrient: '25% Nitrogen + 50% remaining Potash',
            ),
          ],
          themeColor: Color(0xFF15803D),
          icon: Icons.water_drop_rounded,
        ),

        // 4. Groundnut
        const CropModel(
          id: 'groundnut',
          name: 'Groundnut',
          scientificName: 'Arachis hypogaea',
          description:
              'Groundnut is an important oilseed and cash legume crop. High in plant protein and edible oil. It enriches soil fertility by naturally fixing atmospheric nitrogen in root nodules.',
          paakTime: '105 - 120 Days (Maturity Duration)',
          sowingTime: 'June 15 - July 10 (Monsoon onset)',
          seedRate: '40 - 50 Kg Kernels / Acre',
          shinchiyeTime:
              'Critical pegging and pod development stages (40 to 70 days) require adequate soil moisture. Avoid irrigation immediately before harvest.',
          bestSoil:
              'Well-drained light sandy-loam and loose red soils rich in calcium for easy peg penetration. pH 6.0 to 7.0.',
          temperature:
              'Warm climate with 25°C to 30°C temperature and sunny weather.',
          imageUrl: AppAssets.groundnutCrop,
          fertilizerSchedule: [
            FertilizerStage(
              stage: 'Basal Dose',
              nutrient: '20 kg N, 40 kg P2O5, 20 kg K2O + 200 kg Gypsum',
            ),
            FertilizerStage(
              stage: 'Pegging Stage (40 Days)',
              nutrient: '200 kg Gypsum per acre to boost pod kernel filling',
            ),
          ],
          themeColor: Color(0xFF78350F),
          icon: Icons.spa_rounded,
        ),

        // 5. Maize
        const CropModel(
          id: 'maize',
          name: 'Maize',
          scientificName: 'Zea mays',
          description:
              'Maize (Corn) is known as the Queen of Cereals because of its outstanding yield potential. Widely used for cattle feed, silage, starch production, and fresh sweet corn.',
          paakTime: '90 - 110 Days (Maturity Duration)',
          sowingTime: 'June - July (Kharif) or Oct - Nov (Rabi)',
          seedRate: '7 - 8 Kg / Acre',
          shinchiyeTime:
              'Tasseling and silking are the most sensitive moisture stages. Irrigate at 10 to 12 day intervals during dry spells.',
          bestSoil:
              'Deep, fertile loamy soils with high organic matter and no water stagnation. pH 6.5 to 7.5.',
          temperature:
              'Warm climate; optimum 21°C to 27°C during active vegetative growth.',
          imageUrl: AppAssets.maizeCrop,
          fertilizerSchedule: [
            FertilizerStage(
              stage: 'Basal Dose',
              nutrient: '33% N, 100% P & K (DAP + MOP + Zinc)',
            ),
            FertilizerStage(
              stage: 'Knee-high Stage (30 Days)',
              nutrient: '33% Nitrogen (Side-dress Urea)',
            ),
            FertilizerStage(
              stage: 'Tasseling Stage (50 Days)',
              nutrient: '33% Nitrogen (Final top dressing)',
            ),
          ],
          themeColor: Color(0xFFCA8A04),
          icon: Icons.eco_rounded,
        ),

        // 6. Vegetables
        const CropModel(
          id: 'vegetables',
          name: 'Vegetables',
          scientificName: 'Horticulture Crops',
          description:
              'High-value horticulture and vegetable crops (Tomato, Chilli, Brinjal, Okra) providing continuous harvest cycles. Best grown with drip fertigation and proper trellis support.',
          paakTime: '70 - 150 Days (Continuous Picking)',
          sowingTime: 'August - September or January - February',
          seedRate: '60 - 80 Grams Hybrid Seeds / Acre',
          shinchiyeTime:
              'Drip irrigation recommended every 2 to 3 days for uniform soil moisture and water conservation.',
          bestSoil:
              'Deep, well-aerated sandy loam rich in farmyard manure (FYM). pH 6.0 to 7.0.',
          temperature:
              'Moderate 18°C to 28°C; frost protection needed in winter.',
          imageUrl:
              'https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80',
          fertilizerSchedule: [
            FertilizerStage(
              stage: 'Basal Dose',
              nutrient: '10 tonnes FYM + 50 kg DAP + 50 kg Potash per acre',
            ),
            FertilizerStage(
              stage: 'Vegetative Growth (Weekly)',
              nutrient: 'Water soluble 19:19:19 (NPK) through drip line',
            ),
            FertilizerStage(
              stage: 'Fruiting & Picking (Weekly)',
              nutrient: '0:52:34 and Calcium Nitrate + Micronutrients',
            ),
          ],
          themeColor: Color(0xFFDC2626),
          icon: Icons.local_florist_rounded,
        ),
      ];
}
