import 'package:flutter/material.dart';
import '../models/weather_model.dart';
import '../resources/app_colors.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'dashboard_screen.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final WeatherModel _weather = WeatherModel.sampleData;
  String _selectedDistrict = 'Anand';

  final List<String> _districts = [
    'Anand',
    'Rajkot',
    'Ahmedabad',
    'Surat',
    'Vadodara',
    'Junagadh',
    'Mehsana',
    'Bhavnagar',
    'Kutch',
  ];

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
              'Agri Weather & Forecast',
              style: TextStyle(
                fontSize: 17.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textTitle,
                letterSpacing: -0.3,
              ),
            ),
            Text(
              'Weather & Farm Advisories',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.textSubtitle,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Weather data updated with latest radar telemetry.'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. DISTRICT SELECTOR
            _buildDistrictSelector(),

            const SizedBox(height: 14),

            // 2. HERO WEATHER CARD
            _buildHeroWeatherCard(),

            const SizedBox(height: 16),

            // 3. SPRAY & FIELD CONDITIONS BADGE
            _buildSprayWindowBadge(),

            const SizedBox(height: 20),

            // 4. AGRICULTURAL WEATHER ADVISORIES
            _buildAdvisoriesSection(),

            const SizedBox(height: 20),

            // 5. HOURLY FORECAST
            _buildHourlyForecastSection(),

            const SizedBox(height: 20),

            // 6. 7-DAY FORECAST
            _buildSevenDayForecastSection(),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: 0,
        onTap: _onBottomNavTapped,
      ),
    );
  }

  // ==========================================
  // 1. DISTRICT SELECTOR
  // ==========================================
  Widget _buildDistrictSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.emblemBorder),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded,
              color: AppColors.primary, size: 20),
          const SizedBox(width: 8),
          const Text(
            'District:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textTagline,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedDistrict,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary),
                items: _districts.map((d) {
                  return DropdownMenuItem(
                    value: d,
                    child: Text(
                      '$d, Gujarat',
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textBody,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedDistrict = val);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. HERO WEATHER CARD
  // ==========================================
  Widget _buildHeroWeatherCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF065F46), // Deep Emerald
            Color(0xFF047857),
            Color(0xFF0F766E),
          ],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF047857).withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: Location & Live Tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.circle,
                            color: Color(0xFF86EFAC), size: 8),
                        const SizedBox(width: 6),
                        Text(
                          '$_selectedDistrict Live Weather',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Text(
                'Today, 08 Oct',
                style: TextStyle(
                  color: Color(0xFFD1E7DD),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Main Temperature & Weather Icon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_weather.currentTemp}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 56,
                          fontWeight: FontWeight.w800,
                          height: 1.0,
                          letterSpacing: -2,
                        ),
                      ),
                      const Text(
                        '°C',
                        style: TextStyle(
                          color: Color(0xFF86EFAC),
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _weather.condition,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Feels like ${_weather.feelsLike}°C • Max 34°C / Min 23°C',
                    style: const TextStyle(
                      color: Color(0xFFD1E7DD),
                      fontSize: 11.5,
                    ),
                  ),
                ],
              ),
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.wb_cloudy_rounded,
                  color: Color(0xFFFEF08A),
                  size: 42,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.2),
          ),

          const SizedBox(height: 14),

          // 4 Important Farm Weather Metrics Grid
          Row(
            children: [
              _buildMetricCell(
                icon: Icons.water_drop_outlined,
                label: 'Humidity',
                value: '${_weather.humidity}%',
                caption: 'Optimal',
              ),
              _buildMetricDivider(),
              _buildMetricCell(
                icon: Icons.air_rounded,
                label: 'Wind',
                value: '${_weather.windSpeed} km/h',
                caption: _weather.windDirection,
              ),
              _buildMetricDivider(),
              _buildMetricCell(
                icon: Icons.grain_rounded,
                label: 'Rain Chance',
                value: '${_weather.rainProbability}%',
                caption: '${_weather.precipitationMm} mm',
              ),
              _buildMetricDivider(),
              _buildMetricCell(
                icon: Icons.wb_sunny_outlined,
                label: 'UV Index',
                value: '5',
                caption: 'Moderate',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCell({
    required IconData icon,
    required String label,
    required String value,
    required String caption,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF86EFAC), size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFFD1E7DD),
              fontSize: 9.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricDivider() {
    return Container(
      height: 32,
      width: 1,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  // ==========================================
  // 3. SPRAY & FIELD CONDITIONS BADGE
  // ==========================================
  Widget _buildSprayWindowBadge() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF86EFAC)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFDCFCE7),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_circle_rounded,
                color: Color(0xFF166534), size: 22),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Favorable Spray Weather',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF166534),
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Wind is 12 km/h (safe < 15 km/h). Rain probability is low (20%). Best time: 6 AM–9 AM & after 5 PM.',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF15803D),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 4. AGRICULTURAL WEATHER ADVISORIES
  // ==========================================
  Widget _buildAdvisoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.lightbulb_outline_rounded,
                color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Farm Weather Advisories',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textTagline,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ..._weather.advisories.map((advisory) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: advisory.isAlert
                    ? const Color(0xFFBAE6FD)
                    : AppColors.emblemBorder,
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: advisory.color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(advisory.icon, color: advisory.color, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              advisory.title,
                              style: TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: advisory.color,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: advisory.color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              advisory.category,
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: advisory.color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        advisory.description,
                        style: const TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: AppColors.textBody,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ==========================================
  // 5. HOURLY FORECAST
  // ==========================================
  Widget _buildHourlyForecastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.schedule_rounded, color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              'Hourly Conditions',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textTagline,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 128,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _weather.hourlyForecast.length,
            separatorBuilder: (ctx, i) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final hourly = _weather.hourlyForecast[index];
              return Container(
                width: 90,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: hourly.time == 'Now'
                        ? AppColors.primary
                        : AppColors.emblemBorder,
                    width: hourly.time == 'Now' ? 1.5 : 1.0,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      hourly.time,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: hourly.time == 'Now'
                            ? FontWeight.w800
                            : FontWeight.w600,
                        color: hourly.time == 'Now'
                            ? AppColors.primary
                            : AppColors.textTagline,
                      ),
                    ),
                    Icon(hourly.icon, color: AppColors.primary, size: 24),
                    Text(
                      '${hourly.temp}°C',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textBody,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.water_drop_outlined,
                            size: 11, color: Color(0xFF0284C7)),
                        const SizedBox(width: 2),
                        Text(
                          '${hourly.rainChance}%',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0284C7),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: hourly.isSpraySuitable
                            ? const Color(0xFFDCFCE7)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        hourly.isSpraySuitable ? 'Spray Ok' : 'Wait',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: hourly.isSpraySuitable
                              ? const Color(0xFF166534)
                              : const Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ==========================================
  // 6. 7-DAY AGRICULTURAL FORECAST
  // ==========================================
  Widget _buildSevenDayForecastSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_month_outlined,
                color: AppColors.primary, size: 20),
            SizedBox(width: 8),
            Text(
              '7-Day Agricultural Forecast',
              style: TextStyle(
                fontSize: 16.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textTagline,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.emblemBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: _weather.dailyForecast.asMap().entries.map((entry) {
              final idx = entry.key;
              final day = entry.value;
              final isLast = idx == _weather.dailyForecast.length - 1;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        // Day & Date
                        SizedBox(
                          width: 65,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day.day,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: idx == 0
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                  color: idx == 0
                                      ? AppColors.primary
                                      : AppColors.textBody,
                                ),
                              ),
                              Text(
                                day.date,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: AppColors.textSubtitle,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Icon & Condition
                        Icon(day.icon, size: 20, color: AppColors.primaryLight),
                        const SizedBox(width: 8),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                day.condition,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textBody,
                                ),
                              ),
                              Text(
                                day.farmingAdvisory,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 10.5,
                                  color: Color(0xFF0F766E),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Rain probability
                        Row(
                          children: [
                            const Icon(Icons.water_drop_rounded,
                                size: 12, color: Color(0xFF0284C7)),
                            const SizedBox(width: 2),
                            Text(
                              '${day.rainProbability}%',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0284C7),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // Min / Max Temp
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '${day.maxTemp}°',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textBody,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${day.minTemp}°',
                              style: const TextStyle(
                                fontSize: 12,
                                color: AppColors.textSubtitle,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isLast)
                    const Divider(height: 1, color: Color(0xFFF1F5F9)),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
