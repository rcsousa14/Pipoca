import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/splash_view/splash_view_model.dart';
import 'package:stacked/stacked.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     
    
    return ViewModelBuilder<SplashViewModel>.nonReactive(
     
      onModelReady: (model)=> model.locationCheck(),
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
                Container(
                padding: const EdgeInsets.all(160),
                
                child: SvgPicture.asset('images/pipoca.svg'),
              ),
             Align(
               alignment: Alignment.center,
               child: Container(padding: const EdgeInsets.only(top: 180),
               child: CircularProgressIndicator(
                 strokeWidth: 3.5,
                 valueColor:  AlwaysStoppedAnimation<Color>(Colors.white),
               ),),
             )
              ],
             
            ),
          );
        },
        viewModelBuilder: () => SplashViewModel());
  }
}
