import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:location/location.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class LocationService extends IstoppableService {
  Location location = Location();

  BehaviorSubject<Coordinates> locationController =
      BehaviorSubject<Coordinates>();
  Coordinates get currentLocation => locationController.value!;
  Location get permission => location;

  Stream<Coordinates> get getStreamData => locationController.stream;
   // ignore: cancel_subscriptions
   StreamSubscription? _subscription;
  LocationService() {
    location.requestPermission().then((locationPermission) {
      if (locationPermission == PermissionStatus.granted) {
   _subscription = location.onLocationChanged.listen((location) {
          locationController.add(
            Coordinates(
              longitude: location.longitude!,
              latitude: location.latitude!,
            ),
          );
          locationController.onCancel = () {
            locationController.close();
          };
        });
      } 
    });
  }

  @override
  void start() {
    super.start();

    _subscription!.resume();
  }

  @override
  void stop() {
    super.stop();
 _subscription!.pause();
   
  }
}
