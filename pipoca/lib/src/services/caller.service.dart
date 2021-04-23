import 'package:battery/battery.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/widgets/helpers/connectivity_status.dart';
import 'package:pipoca/src/services/battery_service.dart';
import 'package:pipoca/src/services/connectivity_service.dart';

@lazySingleton
class CallerService {
  final _battery = locator<BatteryService>();
  final _conn = locator<ConnectivityService>();

  Future connection(int level, BatteryState state, Future caller) async {
    
      switch (_conn.status) {
        case ConnectivityStatus.Cellular:
          if (state == BatteryState.discharging) {
            if (level <= 50) {
              await Future.delayed(Duration(seconds: 20));
             
              return caller;
            }
          }

          await Future.delayed(Duration(seconds: 15));
      
          return caller;
        case ConnectivityStatus.Wifi:
          if (state == BatteryState.discharging) {
            if (level <= 50) {
              await Future.delayed(Duration(seconds: 10));
             
              return caller;
            }
          }

          await Future.delayed(Duration(seconds: 8));
     
          return caller;
        case ConnectivityStatus.Offiline:
          return caller;
      }
    
  }

  Future battery(int level, Future caller) async {
    await Future.delayed(Duration(milliseconds: 500));
    switch (_battery.batteryState) {
      case BatteryState.charging:
      case BatteryState.discharging:
      case BatteryState.full:
        connection(level, _battery.batteryState, caller);
    }
  }

  Future<int> batteryLevel() async {
    int level = await _battery.broadcastBatteryLevel;
    return level;
  }
}
