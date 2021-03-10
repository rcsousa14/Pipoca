import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/constants/widgets/connectivity_status.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class ConnectivityService extends IstoppableService {
  BehaviorSubject<ConnectivityStatus> connectionStatusController =
      BehaviorSubject<ConnectivityStatus>();
  ConnectivityStatus get status => connectionStatusController.value;
  StreamSubscription _streamSubscription;
  Stream<ConnectivityStatus> get getStreamData =>
      connectionStatusController.stream;

  ConnectivityService() {
    _streamSubscription = Connectivity()
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

    _streamSubscription?.cancel();
  }
}