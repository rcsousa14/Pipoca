import 'package:flutter/material.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/themes/colors.dart';
import 'package:pipoca/src/views/main_view/main_view_model.dart';
import 'package:stacked/stacked.dart';

class MainView extends StatelessWidget {
  const MainView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
   
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    return ViewModelBuilder<MainViewModel>.reactive(
      disposeViewModel: false,
      initialiseSpecialViewModelsOnce: true,
      builder: (context, model, child) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            body: IndexedStack(
              index: model.currentIndex,
              children: [
                Container(
                  color: Colors.orange,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(model.token),
                      TextButton(onPressed: ()=> model.logout(), child: Text('logout'))
                    ],
                  ),
                ),
                Container(
                  color: Colors.red,
                ),
                Container(
                  color: Colors.yellow,
                ),
                Container(
                  color: Colors.green,
                )
              ],
            ),
            bottomNavigationBar: Container(
              height: 52,
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: Colors.grey[350], width: 0.3))),
              child: BottomNavigationBar(
                elevation: 0.8,
                currentIndex: model.currentIndex,
                items: model.availableItems,
                onTap: model.setIndex,
                backgroundColor: Colors.white,
                selectedIconTheme: const IconThemeData(size: 21, color: red),
                unselectedIconTheme:
                    const IconThemeData(size: 21, color: Colors.black),
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
              ),
            ),
          ),
        );
      },
      viewModelBuilder: () => locator<MainViewModel>(),
    );
  }
}
