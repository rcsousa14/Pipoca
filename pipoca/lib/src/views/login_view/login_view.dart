import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/login_view/login_view_model.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StatelessWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LoginViewModel>.reactive(
      builder: (context, model, child) {
        final width = MediaQuery.of(context).size.width;
        final height = MediaQuery.of(context).size.height;
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
                padding: const EdgeInsets.all(160),
                child: SvgPicture.asset('images/pipoca.svg'),
              ),
              Container(
                width: width,
                height: height,
                margin: const EdgeInsets.symmetric(vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SignInButton(Buttons.Google, text: 'Continua com Google',
                        onPressed: () {
                      model.loginWithGoogle();
                      if (model.isBusy) {
                        loading(context, width);
                      }
                    }),
                    SignInButton(Buttons.Facebook,
                        text: 'Continua com Facebook', onPressed: () {
                      model.fbLogin();
                      if (model.isBusy) {
                        loading(context, width);
                      }
                    }),
                    FlatButton(onPressed: ()=> model.logout(), child: Text('logout'))
                  ],
                ),
              )
            ],
          ),
        );
      },
      viewModelBuilder: () => LoginViewModel(),
    );
  }
}

Future<void> loading(context, width) {
  return showDialog(
      context: context,
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width: width * .4,
                      child: Center(child: CircularProgressIndicator())),
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      "LOADING...",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          )));
}
