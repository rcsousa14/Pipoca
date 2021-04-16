import 'package:flutter/material.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/services/battery_service.dart';
import 'package:pipoca/src/services/connectivity_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';

import 'locator.dart';

class LifeCycleManager extends StatefulWidget {
  final Widget child;
  LifeCycleManager({ Key? key,  required this.child}) : super(key: key);

  @override
  _LifeCycleManagerState createState() => _LifeCycleManagerState();
}

class _LifeCycleManagerState extends State<LifeCycleManager>
    with WidgetsBindingObserver {
  List<IstoppableService> services = [
    locator<LocationService>(),
    locator<ConnectivityService>(),
    locator<BatteryService>(),
    locator<FeedService>(),
  ];
  final feedService = locator<FeedService>();
  final location = locator<LocationService>();
  final storage = locator<SharedLocalStorageService>();
  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    services.forEach((service)  {
      if (state == AppLifecycleState.resumed) {
      
         
        service.start();
      }
      if (state == AppLifecycleState.paused ||
          state == AppLifecycleState.inactive) {
        service.stop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.child,
    );
  }
}
