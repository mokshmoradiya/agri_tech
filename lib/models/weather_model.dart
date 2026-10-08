import 'package:flutter/material.dart';

class HourlyWeather {
  final String time;
  final int temp;
  final String condition;
  final IconData icon;
  final int rainChance;
  final bool isSpraySuitable;

  const HourlyWeather({
    required this.time,
    required this.temp,
    required this.condition,
    required this.icon,
    required this.rainChance,
    this.isSpraySuitable = true,
  });
}

class DailyWeatherForecast {
  final String day;
  final String date;
  final String condition;
  final IconData icon;
  final int minTemp;
  final int maxTemp;
  final int rainProbability;
  final int humidity;
  final String farmingAdvisory;

  const DailyWeatherForecast({
    required this.day,
    required this.date,
    required this.condition,
    required this.icon,
    required this.minTemp,
    required this.maxTemp,
    required this.rainProbability,
    required this.humidity,
    required this.farmingAdvisory,
  });
}

class AgriWeatherAdvisory {
  final String title;
  final String description;
  final String category; // 'Spray', 'Irrigation', 'Harvest', 'Pest'
  final IconData icon;
  final Color color;
  final bool isAlert;

  const AgriWeatherAdvisory({
    required this.title,
    required this.description,
    required this.category,
    required this.icon,
    required this.color,
    this.isAlert = false,
  });
}

class WeatherModel {
  final String location;
  final String state;
  final int currentTemp;
  final int feelsLike;
  final String condition;
  final int humidity; // %
  final int windSpeed; // km/h
  final String windDirection;
  final int rainProbability; // %
  final double precipitationMm; // mm
  final String uvIndex;
  final String airQuality;
  final List<HourlyWeather> hourlyForecast;
  final List<DailyWeatherForecast> dailyForecast;
  final List<AgriWeatherAdvisory> advisories;

  const WeatherModel({
    required this.location,
    required this.state,
    required this.currentTemp,
    required this.feelsLike,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.windDirection,
    required this.rainProbability,
    required this.precipitationMm,
    required this.uvIndex,
    required this.airQuality,
    required this.hourlyForecast,
    required this.dailyForecast,
    required this.advisories,
  });

  static WeatherModel get sampleData => WeatherModel(
        location: 'Anand',
        state: 'Gujarat',
        currentTemp: 29,
        feelsLike: 31,
        condition: 'Partly Cloudy',
        humidity: 64,
        windSpeed: 12,
        windDirection: 'SW',
        rainProbability: 20,
        precipitationMm: 0.0,
        uvIndex: 'Moderate (5)',
        airQuality: 'Good (48 AQI)',
        hourlyForecast: const [
          HourlyWeather(
            time: 'Now',
            temp: 29,
            condition: 'Partly Cloudy',
            icon: Icons.cloud_outlined,
            rainChance: 15,
            isSpraySuitable: true,
          ),
          HourlyWeather(
            time: '12 PM',
            temp: 32,
            condition: 'Sunny',
            icon: Icons.wb_sunny_outlined,
            rainChance: 10,
            isSpraySuitable: false, // Too hot for foliar spray
          ),
          HourlyWeather(
            time: '3 PM',
            temp: 34,
            condition: 'Sunny',
            icon: Icons.wb_sunny_rounded,
            rainChance: 10,
            isSpraySuitable: false,
          ),
          HourlyWeather(
            time: '6 PM',
            temp: 30,
            condition: 'Pleasant',
            icon: Icons.wb_twilight_rounded,
            rainChance: 20,
            isSpraySuitable: true, // Ideal evening spray window
          ),
          HourlyWeather(
            time: '9 PM',
            temp: 27,
            condition: 'Clear',
            icon: Icons.nightlight_round,
            rainChance: 10,
            isSpraySuitable: false,
          ),
          HourlyWeather(
            time: '6 AM',
            temp: 24,
            condition: 'Cool & Clear',
            icon: Icons.wb_sunny_outlined,
            rainChance: 5,
            isSpraySuitable: true, // Best morning spray window
          ),
        ],
        dailyForecast: const [
          DailyWeatherForecast(
            day: 'Today',
            date: '08 Oct',
            condition: 'Partly Cloudy',
            icon: Icons.cloud_outlined,
            minTemp: 23,
            maxTemp: 34,
            rainProbability: 20,
            humidity: 64,
            farmingAdvisory: 'Best spray window: 6 AM to 9 AM and after 5 PM.',
          ),
          DailyWeatherForecast(
            day: 'Thu',
            date: '09 Oct',
            condition: 'Scattered Showers',
            icon: Icons.grain_rounded,
            minTemp: 22,
            maxTemp: 31,
            rainProbability: 55,
            humidity: 78,
            farmingAdvisory: 'Light showers expected. Postpone deep irrigation.',
          ),
          DailyWeatherForecast(
            day: 'Fri',
            date: '10 Oct',
            condition: 'Rain Showers',
            icon: Icons.water_drop_outlined,
            minTemp: 21,
            maxTemp: 29,
            rainProbability: 70,
            humidity: 85,
            farmingAdvisory: 'Avoid spraying chemical insecticides today.',
          ),
          DailyWeatherForecast(
            day: 'Sat',
            date: '11 Oct',
            condition: 'Clearing Skies',
            icon: Icons.cloud_done_outlined,
            minTemp: 22,
            maxTemp: 32,
            rainProbability: 25,
            humidity: 70,
            farmingAdvisory: 'Inspect field drainage to prevent standing water.',
          ),
          DailyWeatherForecast(
            day: 'Sun',
            date: '12 Oct',
            condition: 'Sunny',
            icon: Icons.wb_sunny_outlined,
            minTemp: 23,
            maxTemp: 33,
            rainProbability: 10,
            humidity: 60,
            farmingAdvisory: 'Good weather for weed removal & inter-cultivation.',
          ),
          DailyWeatherForecast(
            day: 'Mon',
            date: '13 Oct',
            condition: 'Clear Sky',
            icon: Icons.wb_sunny_rounded,
            minTemp: 24,
            maxTemp: 35,
            rainProbability: 5,
            humidity: 55,
            farmingAdvisory: 'Ideal day for harvesting and crop sun-drying.',
          ),
          DailyWeatherForecast(
            day: 'Tue',
            date: '14 Oct',
            condition: 'Warm & Dry',
            icon: Icons.wb_sunny_outlined,
            minTemp: 24,
            maxTemp: 35,
            rainProbability: 10,
            humidity: 52,
            farmingAdvisory: 'Irrigation recommended for cotton vegetative stage.',
          ),
        ],
        advisories: const [
          AgriWeatherAdvisory(
            title: 'Optimal Pesticide Spray Window',
            description:
                'Wind speed is calm (12 km/h) and no heavy rain expected today. Best time to spray: 6:00 AM – 9:30 AM or 5:00 PM – 7:00 PM.',
            category: 'Spray Window',
            icon: Icons.science_outlined,
            color: Color(0xFF16A34A),
            isAlert: false,
          ),
          AgriWeatherAdvisory(
            title: 'Upcoming Rain Advisory',
            description:
                'Light to moderate showers likely on Friday (70% probability). Postpone urea top-dressing until showers subside to prevent nutrient leaching.',
            category: 'Irrigation',
            icon: Icons.water_drop_outlined,
            color: Color(0xFF0284C7),
            isAlert: true,
          ),
          AgriWeatherAdvisory(
            title: 'Fungal Disease Vigilance',
            description:
                'High relative humidity (64%–85%) over the next 48 hours favours Tikka leaf spot in groundnut and sucking pests in cotton. Monitor fields closely.',
            category: 'Pest Advisory',
            icon: Icons.coronavirus_outlined,
            color: Color(0xFFD97706),
            isAlert: false,
          ),
        ],
      );
}
