import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/app.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:flutter/services.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));

  setupLocator();

  await Firebase.initializeApp();

  runApp(MyApp());
}
