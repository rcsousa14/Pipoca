import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/widgets/connectivity_status.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/battery_service.dart';
import 'package:pipoca/src/views/intro_view/intro_view.dart';
import 'package:provider/provider.dart';

class NetworkSensitive extends StatelessWidget {
  final Widget child;
  const NetworkSensitive({Key key, @required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ConnectivityStatus>(context);
    Provider.of<BatteryState>(context);
    var currentLocation = Provider.of<Coordinates>(context);
    if (currentLocation == null) {
      return IntroView();
    }
    return child;
  }
}
