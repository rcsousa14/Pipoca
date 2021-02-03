import 'package:flutter/material.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/routes/navigation.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeNavigator extends StatefulWidget {
  HomeNavigator({Key key}) : super(key: key);

  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  final _navigatorService = locator<NavigationService>();
  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _navigatorService
          .nestedNavigationKey(NavChoice.home.nestedKeyValue()),
      onGenerateRoute: (RouteSettings settings) {
        return PageRouteBuilder(
            settings: settings,
            transitionDuration: const Duration(milliseconds: 300),
            maintainState: true,
            pageBuilder: (BuildContext context, Animation<double> animation,
                Animation<double> secondaryAnimation) {
              switch (settings.name) {
                case homeRoute:
                  return HomeView();

                case postRoute:
                  final typedArgs = settings.arguments as PostViewArguments;

                  return PostView(
                    choice: typedArgs.choice,
                  );
                case videoRoute:
                  

                default:
                  return HomeView();
              }
            });
      },
    );
  }
}
