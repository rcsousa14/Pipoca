import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/views/main_view/home_navigator/create_post_view/create_post_view.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator_view_model.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view.dart';

import 'package:stacked/stacked.dart';

class HomeNavigator extends StatelessWidget {
  HomeNavigator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
   
    return ViewModelBuilder<HomeNavigatorViewModel>.reactive(
        onModelReady: (model) async => await model.pushFeed(),
        fireOnModelReadyOnce: true,
        disposeViewModel: false,
        builder: (context, model, child) {
          return IndexedStack(
            index: model.currentIndex,
            children: [
              HomeView(),
              CreatePostView(),
              Container(
                color: Colors.yellow,
              ),
              Container(
                color: Colors.green,
              )
            ],
          );
        },
        viewModelBuilder: () => locator<HomeNavigatorViewModel>());
    // Navigator(
    //   key: _nav.currentNestedKey,
    //   onGenerateRoute: (RouteSettings settings) {
    //     return PageRouteBuilder(
    //         settings: settings,
    //         transitionDuration: const Duration(milliseconds: 300),
    //         maintainState: true,
    //         pageBuilder: (BuildContext context, Animation<double> animation,
    //             Animation<double> secondaryAnimation) {
    //           switch (settings.name) {
    //             case homeRoute:

    //               return HomeView();
    //             case postRoute:
    //               final typedArgs = settings.arguments as PostViewArguments;
    //               return PostView(
    //                 key: typedArgs.key,
    //                 choice: typedArgs.choice,
    //                 bago: typedArgs.bago,
    //                 isCreator: typedArgs.isCreator,
    //                 page: typedArgs.page,
    //                 filter: typedArgs.filter,
    //               );
    //             case createRoute:
    //               final typedArgs =
    //                   settings.arguments as CreatePostViewArguments;
    //               return CreatePostView(
    //                 filter: typedArgs.filter,
    //                 page: typedArgs.page,
    //                 choice: typedArgs.choice,
    //               );
    //             default:

    //               return HomeView();
    //           }
    //         });
    //   },
    // );
  }
}
