import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class PushNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future initialise() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
  }

  // void _navigate(Map<String, dynamic> message) {
  //   var notificationData = message['data'];
  //   var view = notificationData['view'];

  // }

  // void _replace(Map<String, dynamic> message) {
  //   var notificationData = message['data'];
  //   var view = notificationData['view'];

  //   if (view != null) {

  //   }
  // }

  Future<String> token() async {
    return await _firebaseMessaging.getToken();
  }
}
