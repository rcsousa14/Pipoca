import 'package:flutter/foundation.dart';
import 'package:stacked/stacked.dart';

class OtpViewModel extends BaseViewModel {
 
  final String phone;
  final String username;
  final String fcmToken;
  final String type;
   OtpViewModel({ @required this.phone, @required this.type, this.username, this.fcmToken });
}
