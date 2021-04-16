import 'package:flutter/material.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view.dart';
import 'package:pipoca/src/views/main_view/main_view_model.dart';
import 'package:pipoca/src/views/main_view/widgets/main_drawer_view.dart';
import 'package:stacked/stacked.dart';

class MainView extends StatelessWidget {
  
  
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
     final GlobalKey<ScaffoldState> scafoldkey = new GlobalKey<ScaffoldState>();
    return ViewModelBuilder<MainViewModel>.reactive(
      disposeViewModel: false,
      onModelReady: (model)=> model.locationCheck(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) {
        
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            key: scafoldkey,
            drawer: MainDrawerView(),
            body: IndexedStack(
              index: model.currentIndex,
              children: [
               // HomeView( scaffoldKey: scafoldkey),
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
