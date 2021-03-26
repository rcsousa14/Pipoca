import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/routes/navigation.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeNavigator extends StatefulWidget {
  final int currentPage;
  HomeNavigator({Key key, this.currentPage}) : super(key: key);

  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  PageController pageController;

  @override
  void initState() {
    pageController = PageController(initialPage: widget.currentPage ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
      physics: NeverScrollableScrollPhysics(),
      controller: pageController,
     
      children: [
        HomeView(controller: pageController),
        PostView(controller: pageController),
        Container(color: Colors.blue),
      ],
    )
    );
    // return Navigator(
    //   key: StackedService.nestedNavigationKey(NavChoice.home.nestedKeyValue()),
    //   onGenerateRoute: (RouteSettings settings) {
    //     return PageRouteBuilder(
    //         settings: settings,
    //         transitionDuration: const Duration(milliseconds: 300),
    //        // maintainState: true,
    //         pageBuilder: (BuildContext context, Animation<double> animation,
    //             Animation<double> secondaryAnimation) {
    //           switch (settings.name) {
    //             case '/':
    //             case homeRoute:

    //               return HomeView();

    //             case postRoute:
    //               final typedArgs = settings.arguments as PostViewArguments;

    //               return PostView(
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
