// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../models/user_feed_model.dart';
import '../views/auth_view/auth_view.dart';
import '../views/login_view/login_view.dart';
import '../views/main_view/home_navigator/post_view/post_view.dart';
import '../views/main_view/main_view.dart';

class Routes {
  static const String authView = '/';
  static const String loginView = '/login-view';
  static const String mainView = '/main-view';
  static const String postView = '/post-view';
  static const all = <String>{
    authView,
    loginView,
    mainView,
    postView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.authView, page: AuthView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.mainView, page: MainView),
    RouteDef(Routes.postView, page: PostView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    AuthView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AuthView(),
        settings: data,
      );
    },
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(message: args.message),
        settings: data,
      );
    },
    MainView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => MainView(),
        settings: data,
      );
    },
    PostView: (data) {
      var args = data.getArgs<PostViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PostView(
          data: args.data,
          filter: args.filter,
          page: args.page,
          key: args.key,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginView arguments holder class
class LoginViewArguments {
  final String message;
  LoginViewArguments({this.message = ''});
}

/// PostView arguments holder class
class PostViewArguments {
  final Data data;
  final bool filter;
  final int page;
  final Key? key;
  PostViewArguments(
      {required this.data, required this.filter, required this.page, this.key});
}
