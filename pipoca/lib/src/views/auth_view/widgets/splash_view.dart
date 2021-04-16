import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/constants/widgets/network_sensitive.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/views/auth_view/widgets/splash_view_model.dart';
import 'package:pipoca/src/views/login_view/login_view.dart';
import 'package:pipoca/src/views/main_view/main_view.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  final bool isLogged;

  const SplashView({Key? key, required this.isLogged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.reactive(
        onModelReady: (model) {
          print(isLogged);
          if (isLogged == true) {
            model.checkInternet();
          }
        },
        builder: (context, model, child) {
          return model.isConnected == true && isLogged == true && model.dataReady
              ? Builder(builder: (context){
                  switch (model.data!.status) {
                        case Status.LOADING:
                          return splash(true);
                        case Status.COMPLETED:
                          return startupLogicData(model.fetch());
                        case Status.ERROR:
                          return LoginView(message: model.data!.message);

                        default:
                          return splash(false);
                      }
              })
              : splash(false);
        },
        viewModelBuilder: () => SplashViewModel());
  }
}




Widget startupLogicData(Future<ApiResponse<Usuario>> getUser) {
  return FutureBuilder<ApiResponse<Usuario>>(
    future: getUser,
    builder: (context, snapshot){
      if(snapshot.hasData){
        switch (snapshot.data!.status) {
        case Status.LOADING:
          return splash(true);
        case Status.COMPLETED:
          return NetworkSensitive(child: MainView());
        case Status.ERROR:
          return LoginView(message: snapshot.data!.message);

        default:
          return splash(true);
      }
      }
      return splash(true);
    },

  );
}

Widget splash(bool loading) {
  return Scaffold(
    appBar: PreferredSize(
      preferredSize: const Size.fromHeight(20),
      child: AppBar(
        backgroundColor: red,
        brightness: Brightness.dark,
        elevation: 0,
      ),
    ),
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
