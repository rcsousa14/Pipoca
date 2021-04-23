import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/constants/widgets/helpers/connectivity_status.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class ConnectivityService extends IstoppableService {
  BehaviorSubject<ConnectivityStatus> connectionStatusController =
      BehaviorSubject<ConnectivityStatus>();
  ConnectivityStatus get status => connectionStatusController.value!;

  Stream<ConnectivityStatus> get getStreamData =>
      connectionStatusController.stream;

    

  ConnectivityService() {
     Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) {
      
      var connectionStatus = _getStatusFromResult(result);

      connectionStatusController.add(connectionStatus);

      connectionStatusController.onCancel = () {
        connectionStatusController.close();
      };
    });
  }
  ConnectivityStatus _getStatusFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.mobile:
        return ConnectivityStatus.Cellular;
      case ConnectivityResult.wifi:
        return ConnectivityStatus.Wifi;
      case ConnectivityResult.none:
        return ConnectivityStatus.Offiline;

      default:
        return ConnectivityStatus.Offiline;
    }
  }

  @override
  void start() {
    super.start();

   
  }

  @override
  void stop() {
    super.stop();

  
  }
}
