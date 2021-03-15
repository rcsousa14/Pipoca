import 'package:auto_route/auto_route.dart';
import 'package:auto_route/auto_route_annotations.dart';
import 'package:pipoca/src/views/forgot_view/forgot_view.dart';
import 'package:pipoca/src/views/intro_view/intro_view.dart';
import 'package:pipoca/src/views/login_view/login_view.dart';
import 'package:pipoca/src/views/main_view/main_view.dart';

import 'package:pipoca/src/views/splash_view/splash_view.dart';


@MaterialAutoRouter(routes:<AutoRoute>[
   CustomRoute(
    page: SplashView,
    transitionsBuilder: TransitionsBuilders.fadeIn,
    initial: true,
  ),
  CustomRoute(
    page: IntroView,
   path: '/intro-view',
  
  ),
   CustomRoute(
    page: MainView,
    transitionsBuilder: TransitionsBuilders.fadeIn,
    path: '/main-view',
  ),
   CustomRoute(
    page: LoginView,
    transitionsBuilder: TransitionsBuilders.fadeIn,
    path: '/login-view',
  ),
  CustomRoute(
    page: ForgotView,
    transitionsBuilder: TransitionsBuilders.fadeIn,
    path: '/forgot-view',
  ),
 
])
class $Router {}