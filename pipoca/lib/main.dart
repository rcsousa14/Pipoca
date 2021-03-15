import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/app.dart';
import 'package:pipoca/src/app/locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  setupLocator();
  runApp(MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}
