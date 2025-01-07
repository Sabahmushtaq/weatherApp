import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helprushcleancode/features/data/model/model.dart';
import 'package:riverpod/riverpod.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:weather/weather.dart';
import 'package:helprushcleancode/const.dart';

// Define the WeatherState class

// Define a StateNotifier for managing the state
class WeatherNotifier extends StateNotifier<WeatherState> {
  final WeatherFactory weatherFactory;

  WeatherNotifier(this.weatherFactory) : super(WeatherState());

  Future<void> fetchWeatherForCity(String city) async {
    try {
      state = state.copyWith(isLoading: true);
      Weather weather = await weatherFactory.currentWeatherByCityName(city);

      state = state.copyWith(weather: weather, isLoading: false, city: city);
    } catch (e) {
      state = state.copyWith(weather: null, isLoading: false, city: null);
      rethrow;
    }
  }

  Future<void> getCurrentLocationCity() async {
    try {
     // print("1");
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
          print(position);
          //placemarks ---> 
      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      if (placemarks.isNotEmpty) {
        String city = placemarks[0].locality ?? "";
        print("Current city: $city");
        state = state.copyWith(currentCity: city);
        fetchWeatherForCity(city);
      }
    } catch (e) {
      state = state.copyWith(currentCity: "");
    }
  }
}
