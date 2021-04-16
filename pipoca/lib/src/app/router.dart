import 'package:flutter/cupertino.dart';
import 'package:pipoca/src/constants/routes/navigation.dart';
import 'package:pipoca/src/views/auth_view/auth_view.dart';
import 'package:stacked/stacked.dart';

class Router {
  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
      case initialRoute:
        return PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, anotherAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          pageBuilder: (context, animation, secondaryAnimation) => AuthView(),
        );

      default:
        return PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, anotherAnimation, child) =>
              FadeTransition(opacity: animation, child: child),
          pageBuilder: (context, animation, secondaryAnimation) => AuthView(),
        );
    }
  }
}
