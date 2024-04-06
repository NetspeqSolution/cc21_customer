import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

Future<bool> checkIfAllowedN() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    Fluttertoast.showToast(msg: 'Location services are disabled.',toastLength: Toast.LENGTH_LONG);
    await Geolocator.openLocationSettings();
    return false;
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      Fluttertoast.showToast(
          msg:
          'Location permissions are denied, try again after giving permission');
      return false;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    Fluttertoast.showToast(
        msg:
        'Location permissions are permanently denied, we cannot request permissions.');
    return false;
  }

  return true;
}

Future<Position> getCurrentPosN() async {
  return await Geolocator.getCurrentPosition();
}