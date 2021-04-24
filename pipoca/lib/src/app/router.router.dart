// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../views/auth_view/auth_view.dart';
import '../views/login_view/login_view.dart';
import '../views/main_view/home_navigator/create_post_view/create_post_view.dart';
import '../views/main_view/home_navigator/post_view/post_view.dart';
import '../views/main_view/main_view.dart';

class Routes {
  static const String authView = '/';
  static const String loginView = '/login-view';
  static const String mainView = '/main-view';
  static const String createPostView = '/create-post-view';
  static const String postView = '/post-view';
  static const all = <String>{
    authView,
    loginView,
    mainView,
    createPostView,
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
    RouteDef(Routes.createPostView, page: CreatePostView),
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
    CreatePostView: (data) {
      var args = data.getArgs<CreatePostViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreatePostView(
          key: args.key,
          filter: args.filter,
          index: args.index,
        ),
        settings: data,
      );
    },
    PostView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const PostView(),
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

/// CreatePostView arguments holder class
class CreatePostViewArguments {
  final Key? key;
  final bool filter;
  final int index;
  CreatePostViewArguments(
      {this.key, required this.filter, required this.index});
}
