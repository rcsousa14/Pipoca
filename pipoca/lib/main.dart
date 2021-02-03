import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/app.dart';
import 'package:pipoca/src/app/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setupLocator();
  runApp(MyApp());
}
