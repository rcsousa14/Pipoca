import 'package:flutter/material.dart';
import 'package:pipoca/src/assets/pipoca_icons_icons.dart';
import 'package:pipoca/src/constants/routes/navigation.dart';

enum NavChoice { home, discovery, notfy, user }

extension NavChoiceExtension on NavChoice {
  BottomNavigationBarItem navChoiceItem() {
    BottomNavigationBarItem item;

    switch (this) {
      case NavChoice.home:
        item = BottomNavigationBarItem(
            icon: Icon(PipocaIcons.maps), label: this.navTitle());
        break;
      case NavChoice.discovery:
        item = BottomNavigationBarItem(
            icon: Icon(PipocaIcons.earth), label: this.navTitle());
        break;
      case NavChoice.notfy:
        item = BottomNavigationBarItem(
            icon: Stack(
                  children: <Widget>[
                    Icon(PipocaIcons.bell),
                    Positioned(
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(1),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: BoxConstraints(
                          minWidth: 12,
                          minHeight: 12,
                        ),
                        child: Center(
                          child: Text(
                            '1',
                            style: new TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    )
                  ],
                ), label: this.navTitle());
        break;
      case NavChoice.user:
        item = BottomNavigationBarItem(
            icon: Icon( PipocaIcons.gear), label: this.navTitle());
        break;
    }
    return item;
  }
   String navTitle() {
    String selectedText;

    switch (this) {
      case NavChoice.home:
        selectedText = 'Red';
        break;
      case NavChoice.discovery:
        selectedText = 'Green';
        break;
      case NavChoice.notfy:
        selectedText = 'Blue';
        break;
      case NavChoice.user:
        selectedText = 'Yellow';
        break;
     
    }

    return selectedText;
  }
  String initialPageRoute() {
    String selectedText;

    switch (this) {
      case NavChoice.home:
        selectedText = homeRoute;
        break;
      case NavChoice.discovery:
        selectedText = discoveryRoute;
        break;
      case NavChoice.notfy:
        selectedText = notifyRoute;
        break;
      case NavChoice.user:
        selectedText = userRoute;
        break;
    
    }

    return selectedText;
  }

   int nestedKeyValue() {
    int value;

    switch (this) {
      case NavChoice.home:
        value = 0;
        break;
      case NavChoice.discovery:
        value = 1;
        break;
      case NavChoice.notfy:
        value = 2;
        break;
      case NavChoice.user:
        value = 3;
        break;

    }

    return value;
  }
  PageStorageKey? pageStorageKey() {
    return _pageStorageKeys[this];
  }
   static Map<NavChoice, PageStorageKey> _pageStorageKeys = {
    NavChoice.home: PageStorageKey(NavChoice.home.navTitle()),
    NavChoice.discovery: PageStorageKey(NavChoice.discovery.navTitle()),
    NavChoice.notfy: PageStorageKey(NavChoice.notfy.navTitle()),
    NavChoice.user: PageStorageKey(NavChoice.user.navTitle()),
  
  };
}

 
