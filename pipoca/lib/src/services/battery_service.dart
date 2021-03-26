import 'dart:async';

import 'package:battery/battery.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';

import 'package:rxdart/rxdart.dart';

@lazySingleton
class BatteryService extends IstoppableService {
  Battery battery = Battery();
  BehaviorSubject<BatteryState> batteryController =
      BehaviorSubject<BatteryState>();


  Future<int> get broadcastBatteryLevel async {
  
    int batteryLevel = await battery.batteryLevel;
    return batteryLevel;
  }

  BatteryState get batteryState => batteryController.value;


  StreamSubscription<BatteryState> _streamSubscription;



  BatteryService() {
    _streamSubscription =
        battery.onBatteryStateChanged.listen((BatteryState state) {
      batteryController.add(state);
  
      batteryController.onCancel = () {
        batteryController.close();
      };
    });
   
  }

  

  @override
  void start() {
    super.start();
  }

  @override
  void stop() {
    super.stop();
  
    _streamSubscription?.cancel();
  }
}