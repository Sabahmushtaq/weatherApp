import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:helprushcleancode/features/domain/repository/check_permi_usecase.dart';
import 'package:helprushcleancode/features/presentation/widgets/snackbarr.dart';

class CheckPermiUsecaseImpl implements CheckPermiUsecase{
  @override
 Future checkPermission( BuildContext context) async {
   
   
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Show a dialog to guide the user to app settings
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Permission Required'),
            content: Text(
              'Location permission is required to fetch weather data. Please enable it in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Geolocator.openAppSettings();
                },
                child: Text('Open Settings'),
              ),
            ],
          ),
        );
        return;
      } else if (permission == LocationPermission.denied) {
        // Show a message indicating permission is needed
        showTopSnackBarr(
            context, "Location Permission is required to fetch weather");
        return;
      }
      return;
    }
  }



}