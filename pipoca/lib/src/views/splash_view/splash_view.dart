import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/splash_view/splash_view_model.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SplashViewModel>.nonReactive(
       onModelReady: (model) => model.handleStartUpLogic(),
        builder: (context, model, child) {
      
     
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
                    margin: const EdgeInsets.only(
                        left: 165, right: 165, bottom: 30),
                    child: Image.asset('images/white.png'))
              ],
            ),
          );
        },
        viewModelBuilder: () => SplashViewModel());
  }
}
