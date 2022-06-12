import 'package:location/location.dart';

class LocationHelper {
  late Location location;
  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late LocationData locationData;
  LocationHelper() {
    location = new Location();
  }

  _checkService() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }
  }

  _checkPermission() async {
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
  }

  Future<LocationData> getData() async {
    await _checkPermission();
    await _checkService();

    locationData = await location.getLocation();
    return locationData;
  }
}

LocationHelper locationHelper = LocationHelper();
