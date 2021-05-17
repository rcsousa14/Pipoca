import 'package:flutter/material.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_navigator.dart';
import 'package:pipoca/src/views/main_view/main_view_model.dart';
import 'package:pipoca/src/views/main_view/widgets/drawer/main_drawer_view.dart';
import 'package:stacked/stacked.dart';

class MainView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scafoldkey = new GlobalKey<ScaffoldState>();
    return ViewModelBuilder<MainViewModel>.reactive(
      disposeViewModel: false,
      onModelReady: (model) => model.locationCheck(),
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            key: scafoldkey,
            drawer: MainDrawerView(),
            body: IndexedStack(
              index: model.currentIndex,
              children: [
                // HomeView(),
                HomeNavigator(),
                Container(
                  color: Colors.green,
                ),
                Container(
                  color: Colors.orange,
                ),

                Container(
                  color: Colors.yellow,
                ),
                Container(
                  color: Colors.green,
                )
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
              elevation: 4,
              currentIndex: model.currentIndex,
              items: model.availableItems,
              onTap: model.setIndex,
              backgroundColor: Colors.white,
              selectedIconTheme: const IconThemeData(color: red),
              unselectedIconTheme: const IconThemeData(color: Colors.black),
              showSelectedLabels: false,
              showUnselectedLabels: false,
              type: BottomNavigationBarType.fixed,
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
    );
  }
}
