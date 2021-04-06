import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pipoca/src/constants/widgets/full_screen.dart';

import 'package:pipoca/src/views/main_view/home_navigator/home_view/home_view.dart';
import 'package:pipoca/src/views/main_view/home_navigator/post_view/post_view.dart';

class HomeNavigator extends StatefulWidget {
  final int currentPage;
  final GlobalKey<ScaffoldState> scaffoldKey;
  HomeNavigator({Key key, this.currentPage, @required this.scaffoldKey, GlobalKey<ScaffoldState> scafoldkey})
      : super(key: key);

  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}

class _HomeNavigatorState extends State<HomeNavigator> {
  PageController pageController;

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
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
        HomeView(controller: pageController, scaffoldKey: widget.scaffoldKey),
        PostView(controller: pageController),
        

      ],
    ));
  }
}
