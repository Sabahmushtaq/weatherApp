// WeatherScreen Widget
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helprushcleancode/const.dart';
import 'package:helprushcleancode/features/data/model/model.dart';
import 'package:helprushcleancode/features/data/repositories/check_permi_usecase_impl.dart';
import 'package:helprushcleancode/features/domain/usecases/permission_usecase.dart';
import 'package:helprushcleancode/features/presentation/riverpod/riverpod.dart';
import 'package:helprushcleancode/features/presentation/widgets/custom_button.dart';
import 'package:helprushcleancode/features/presentation/widgets/custom_text.dart';
import 'package:helprushcleancode/features/presentation/widgets/custom_text_field.dart';
import 'package:helprushcleancode/features/presentation/widgets/snackbarr.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:weather/weather.dart';

class WeatherScreen extends ConsumerStatefulWidget {
  const WeatherScreen({super.key});

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends ConsumerState<WeatherScreen> {
  final TextEditingController cityController = TextEditingController();
   final checkPermiUsecase = CheckPermiUsecaseImpl();
  final weatherProvider =
      StateNotifierProvider<WeatherNotifier, WeatherState>((ref) {
    return WeatherNotifier(
        WeatherFactory(weatherapiKey)); // Replace with your API key
  });
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      if (kIsWeb) {
 await ref.read(weatherProvider.notifier).getCurrentLocationCity();
        // Handle the fetched position (for web)

      } else{
      await checkPermiUsecase.checkPermission(context);//checkPermission(context);
      if (mounted) {
        await ref.read(weatherProvider.notifier).getCurrentLocationCity();
      }}
    });
  }

  

  @override
  Widget build(BuildContext context) {
    WeatherState weatherState = ref.watch(weatherProvider);
    TextEditingController inputCity = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: CustomTextView(
            text: "Weather App",
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomTextView(text: "Current Location is :", color: Colors.blue),
            SizedBox(height: 8),
            weatherState.currentCity != null
                ? CustomTextView(text: weatherState.currentCity ?? "")
                : CircularProgressIndicator(),
            SizedBox(height: 20),
            weatherState.city == null
                ? CustomTextView(
                    text: "Current Weather at Location is :",
                    color: Colors.amber,
                  )
                : CustomTextView(
                    text: "Current Weather at ${weatherState.city} is :",
                    color: Colors.amber,
                  ),
            SizedBox(height: 20),
            weatherState.isLoading
                ? CircularProgressIndicator()
                : weatherState.weather != null
                    ? CustomTextView(
                        text: weatherState.weather?.weatherDescription ?? "",
                      )
                    : CircularProgressIndicator(),
            SizedBox(height: 10),
            CustomTextView(
              text: "Enter city for which you want to know weather",
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: CustomTextField(
                controller: inputCity,
              ),
            ),
            SizedBox(height: 20),
            CustomButton(
                text: "Get Weather",
                onPressed: () {
                  if (inputCity.text.isNotEmpty) {
                    final data = ref
                        .read(weatherProvider.notifier)
                        .fetchWeatherForCity(inputCity.text);

                    data.catchError((e) {
                      // Handle the error here

                      if (e.toString().contains('city not found')) {
                        // If the city is not found, show a SnackBar with a custom message
                        showTopSnackBarr(context, "City not found");
                      } else if (e.toString().contains('Failed host lookup')) {
                        showTopSnackBarr(context, "Network Error");
                      } else {
                        showTopSnackBarr(context, "Failed to fetch weather");
                      }
                    });

                    weatherState.city = inputCity.text;
                  } else {
                    showTopSnackBarr(context, "Enter City");
                  }
                })
          ],
        ),
      ),
    );
  }

 
}
