import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:pipoca/src/models/user_location_model.dart';

@lazySingleton
class LocationService {
  Location location = Location();
  Coordinates currentLocation;

  StreamController<Coordinates> locationController =
      StreamController<Coordinates>.broadcast();

  Stream<Coordinates> get getStreamData => locationController.stream;

  LocationService() {
    location.requestPermission().then((locationPermission) {
      if (locationPermission == PermissionStatus.granted) {
        location.onLocationChanged.listen((location) {
          locationController.add(
            Coordinates(
              longitude: location.longitude,
              latitude: location.latitude,
            ),
          );
        });
      }
    });
  }
}
