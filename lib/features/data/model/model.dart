import 'package:weather/weather.dart';

class WeatherState {
  Weather? weather;
  final bool isLoading;
  String? city;
  String? currentCity;

  WeatherState({
    this.weather,
    this.isLoading = false,
    this.city,
    this.currentCity = "",
  });

  WeatherState copyWith({
    Weather? weather,
    bool? isLoading,
    String? city,
    String? currentCity,
  }) {
   // print("$weather");
    return WeatherState(
      weather: weather ?? this.weather,
      isLoading: isLoading ?? this.isLoading,
      city: city ?? this.city,
      currentCity: currentCity ?? this.currentCity,
    );
  }
}
