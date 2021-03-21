import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';

class HomeAppBar extends StatelessWidget {
  final String image;
  final Function drawer;
  final Function filter;
  final bool isFilter; 
  const HomeAppBar({Key key, this.image, this.drawer, this.filter, this.isFilter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsIconTheme: IconThemeData(color: isFilter? red: Colors.black),
      elevation: 0.8,
      backgroundColor: Colors.white,
      brightness: Brightness.dark, //Brightness.light
      centerTitle: true,
      leading: GestureDetector(
        onTap: drawer,
        child: Container(
          margin: EdgeInsets.all(7),
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
        style: GoogleFonts.poppins(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.grey[900]),
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
                PipocaBasics.popcorn,
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
          backgroundColor: red,
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
