import 'package:flutter/material.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';

class HomeAppBar extends StatelessWidget {
  final String image;
  final Function drawer;
  final Function filter;
  const HomeAppBar({Key key, this.image, this.drawer, this.filter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsIconTheme: IconThemeData(color: red),
      elevation: 0.8,
      backgroundColor: Colors.white,
      centerTitle: true,
      leading: GestureDetector(
        onTap: drawer,
        child: Container(
          margin: EdgeInsets.all(8.5),
          decoration: BoxDecoration(
            color: Colors.grey[350],
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        'Pipoca',
        style: TextStyle(
            fontSize: 23, fontWeight: FontWeight.w500, color: Colors.grey[900]),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: filter,
          child: Container(
            height: 30,
            width: 30,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: Icon(
                PipocaBasics.popcorn_1,
                size: 28,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HomeFloatingAction extends StatelessWidget {
  final Function action; 
  const HomeFloatingAction({Key key, this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      child: FittedBox(
        child: FloatingActionButton(
          elevation: 1,
          onPressed: action,
          child: Icon(
            PipocaBasics.quill,
          ),
        ),
      ),
    );
  }
}
