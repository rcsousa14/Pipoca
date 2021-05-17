import 'package:flutter/material.dart';
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
            key: ValueKey<int>(model.currentIndex),
            index: model.currentIndex,
            children: [
              HomeView(),
              CreatePostView(),
            ],
          );
        },
        viewModelBuilder: () => locator<HomeNavigatorViewModel>());
  }
}
