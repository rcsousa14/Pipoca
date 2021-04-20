import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/auth_view/auth_view_model.dart';

import 'package:stacked/stacked.dart';

class AuthView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        onModelReady: (model) async {
          await Future.delayed(Duration(seconds: 3));
          if (model.loggedIn) {
            await model.resetToken();
          } else {
            await model.goToLogin();
          }
        },
        builder: (context, model, child) {
          return splash(true);
        },
        viewModelBuilder: () => AuthViewModel());
  }
}


Widget splash(bool loading) {
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
        Container(
            margin: const EdgeInsets.only(left: 165, right: 165, bottom: 30),
            child: Image.asset('images/white.png')),
        if (loading == true) ...[
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                margin: const EdgeInsets.symmetric(vertical: 20),
                height: 35,
                width: 35,
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                )),
          )
        ]
      ],
    ),
  );
}
