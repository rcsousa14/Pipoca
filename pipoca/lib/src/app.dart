import 'package:battery/battery.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pipoca/src/app/lifecycle_manager.dart';
import 'package:pipoca/src/app_view_model.dart';
import 'package:pipoca/src/constants/widgets/connectivity_status.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/battery_service.dart';
import 'package:pipoca/src/services/connectivity_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'app/locator.dart';
import 'app/router.router.dart';

class MyApp extends StatelessWidget {
 

  @override
  Widget build(BuildContext context) {
  
    return ViewModelBuilder<AppViewModel>.reactive(
    
      builder: (context, model, child) {
        return LifeCycleManager(
          child: MultiProvider(
            providers: [
              StreamProvider<ConnectivityStatus>(
                initialData: ConnectivityStatus.Offiline,
                create: (_) => locator<ConnectivityService>().getStreamData,
              ),
              StreamProvider<BatteryState>(
                initialData: BatteryState.full,
                create: (_) =>
                    locator<BatteryService>().batteryController.stream,
              ),
             
              StreamProvider<Coordinates>.value(
                initialData: Coordinates(latitude: -8.838333, longitude: 13.234444),
                value: locator<LocationService>().getStreamData,
              ),
            ],
            child: MaterialApp(
              title: 'Pipoca',
              locale: Locale('pt', 'AO'),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                textTheme: GoogleFonts.robotoTextTheme(
                  Theme.of(context).textTheme,
                ),
                fontFamily: 'roboto',
                primarySwatch: Colors.red,
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
             navigatorKey: StackedService.navigatorKey,
             initialRoute:  Routes.authView,
           onGenerateRoute: StackedRouter().onGenerateRoute,
             
            ),
          ),
        );
      },
      viewModelBuilder: () => AppViewModel(),
    );
  }
}

