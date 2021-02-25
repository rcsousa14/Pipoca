import 'package:flutter/foundation.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/auth_user_model.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:stacked/stacked.dart';
import 'package:url_launcher/url_launcher.dart';

class OtpViewModel extends BaseViewModel {
  final String phone;
  final String username;
  final String fcmToken;
  final String type;
  OtpViewModel(
      {@required this.phone,
      @required this.type,
      this.username,
      this.fcmToken});

  final _authenticationService = locator<AuthenticationService>();

  void launchURL() async {
    var url = Uri(
        scheme: 'sms',
        path: '+244' + phone,
        queryParameters: {'subject': 'Example Subject & Symbols are allowed!'});
    if (await canLaunch(url.toString())) {
      await launch(url.toString());
    } else {
      throw 'Could not launch $url';
    }

    // _otp.sendOtp(phone, 'esta é a sua senha de uso único (OTP) para Pipoca:', minNumber, maxNumber, '+244');
  }

  Future appAcess() async {
    // if (phone != null && phone.isNotEmpty) {
    //   if (username != null && username.isNotEmpty) {
    //     var result = await _authenticationService.access(
    //         user: UserAuth(
    //             phoneNumber: phone, username: username, fcmToken: fcmToken),
    //         endpoint: 'signup');

    //   }
    // }
  }
}
