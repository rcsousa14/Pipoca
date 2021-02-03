import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';

@lazySingleton
class LocationService {
  GeoPoint _currentLocation;

  Location location = Location();

  /* CONTINUOUSLY EMIT LOCATION UPDATES */
  StreamController<GeoPoint> _locationController =
      StreamController<GeoPoint>.broadcast();

  LocationService() {
    location.requestPermission().then((value) {
      if (value == PermissionStatus.granted) {
        location.onLocationChanged.listen((locationData) {
          if (locationData != null) {
            _locationController.add(GeoPoint(
                locationData.latitude,
                locationData.longitude));
          }
        });
      }
      
    });
  }

  Stream<GeoPoint> get locationStream => _locationController.stream;
  Future<GeoPoint> requestLocation() async {
    try {
      var userLocation = await location.getLocation();
      _currentLocation = GeoPoint(
           userLocation.latitude,  userLocation.latitude);
    } catch (e) {
      return e;
    }
    return _currentLocation;
  }
}
