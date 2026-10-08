class FieldMetric {
  final String title;
  final String value;
  final String unit;
  final double progress;

  const FieldMetric({
    required this.title,
    required this.value,
    required this.unit,
    required this.progress,
  });

  static List<FieldMetric> get sampleMetrics => const [
        FieldMetric(
          title: 'Soil Moisture',
          value: '78',
          unit: '%',
          progress: 0.78,
        ),
        FieldMetric(
          title: 'Field Temperature',
          value: '26.4',
          unit: '°C',
          progress: 0.65,
        ),
        FieldMetric(
          title: 'Crop Health Index',
          value: '94',
          unit: '/100',
          progress: 0.94,
        ),
      ];
}
