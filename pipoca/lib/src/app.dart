import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pipoca/src/app/router.gr.dart' as myRouter;
import 'package:pipoca/src/app_view_model.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:flutter/material.dart' hide Router;

import 'app/locator.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AppViewModel>.reactive(
      builder: (context, model, child) {
        return StreamProvider<GeoPoint>.value(
          value: locator<LocationService>().locationStream,
          initialData: GeoPoint( -8.83682,  13.23432),
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
            navigatorKey: model.key,
            initialRoute: myRouter.Routes.splashView,
            onGenerateRoute: myRouter.Router().onGenerateRoute,
          ),
        );
      },
      viewModelBuilder: () => AppViewModel(),
    );
  }
}
