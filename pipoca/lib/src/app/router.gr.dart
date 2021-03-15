// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../views/forgot_view/forgot_view.dart';
import '../views/intro_view/intro_view.dart';
import '../views/login_view/login_view.dart';
import '../views/main_view/main_view.dart';
import '../views/splash_view/splash_view.dart';

class Routes {
  static const String splashView = '/';
  static const String introView = '/intro-view';
  static const String mainView = '/main-view';
  static const String loginView = '/login-view';
  static const String forgotView = '/forgot-view';
  static const all = <String>{
    splashView,
    introView,
    mainView,
    loginView,
    forgotView,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.splashView, page: SplashView),
    RouteDef(Routes.introView, page: IntroView),
    RouteDef(Routes.mainView, page: MainView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.forgotView, page: ForgotView),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    SplashView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const SplashView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    IntroView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const IntroView(),
        settings: data,
      );
    },
    MainView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const MainView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    LoginView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const LoginView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
    ForgotView: (data) {
      return PageRouteBuilder<dynamic>(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ForgotView(),
        settings: data,
        transitionsBuilder: TransitionsBuilders.fadeIn,
      );
    },
  };
}
