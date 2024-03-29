import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';
import 'package:pipoca/src/constants/themes/colors.dart';

class HomeAppBar extends StatelessWidget {
  final String? image;
  final Function drawer;
  final Function filter;
  final bool isFilter;
  const HomeAppBar(
      {Key? key,
      this.image,
      required this.drawer,
      required this.filter,
      required this.isFilter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actionsIconTheme: IconThemeData(color: isFilter ? red : Colors.black),
      elevation: 0.8,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      centerTitle: true,
      leading: GestureDetector(
          onTap: () => drawer(),
          child: image != null
              ? Container(
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(image!),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Container(
                  margin: EdgeInsets.all(7),
                  decoration: BoxDecoration(
                    color: Colors.grey[350],
                    shape: BoxShape.circle,
                  ),
                )),
      title: Text(
        'Pipoca',
        style: GoogleFonts.poppins(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.grey[900]),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () => filter(),
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

class PostAppBar extends StatelessWidget {
  final Function back;
  final Function report;
  final bool isCreator;
  const PostAppBar({
    Key? key,
    required this.back,
    required this.report,
    required this.isCreator
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
    //  actionsIconTheme: IconThemeData(color: isCreator ? red : Colors.black),
      elevation: 0.8,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      centerTitle: true,
      leading: GestureDetector(
          onTap: () => back(),
          child: Icon(Icons.arrow_back_ios, color: Colors.grey.shade600,)),
              
      title: Text(
        'Bago',
        style: GoogleFonts.poppins(
            fontSize: 23, fontWeight: FontWeight.bold, color: Colors.grey[900]),
      ),
      actions: <Widget>[
        GestureDetector(
          onTap: () => report(),
          child: Container(
            height: 30,
            width: 30,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(shape: BoxShape.circle),
            child: Center(
              child: Icon(
                isCreator ?  Icons.delete_rounded : Icons.emoji_flags_rounded,
                size: 28,
                color: isCreator ? red : Colors.grey.shade600,

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
  const HomeFloatingAction({Key? key, required this.action}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      child: FittedBox(
        child: FloatingActionButton(
          backgroundColor: red,
          elevation: 1,
          onPressed: () => action(),
          child: Icon(
            PipocaBasics.quill,
          ),
        ),
      ),
    );
  }
}
