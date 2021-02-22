import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/otp_view/otp_view_model.dart';
import 'package:stacked/stacked.dart';

class OtpView extends StatelessWidget {
  final String phone;
  final String username;
  final String fcmToken;
  final String type;
  const OtpView({Key key, @required this.phone, this.username, this.fcmToken , @required this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<OtpViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
          body: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomLeft,
                      colors: [red, orange],
                    ),
                  ),
                ),
                
              ],
            ),
        );
      },
      viewModelBuilder: () => OtpViewModel(phone: phone, type: type, fcmToken: fcmToken, username: username),
    );
  }
}
