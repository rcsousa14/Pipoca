import 'package:flutter/material.dart';
import 'package:pipoca/src/views/auth_view/auth_view_model.dart';
import 'package:pipoca/src/views/auth_view/widgets/splash_view.dart';
import 'package:pipoca/src/views/login_view/login_view.dart';
import 'package:stacked/stacked.dart';

class AuthView extends StatelessWidget {
  const AuthView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<AuthViewModel>.reactive(
        onModelReady: (model) => model.getToken(),
        builder: (context, model, child) {
          return !model.loggedIn
              ? LoginView()
              : SplashView(isLogged: model.loggedIn);
          
        },
        viewModelBuilder: () => AuthViewModel());
  }
}
