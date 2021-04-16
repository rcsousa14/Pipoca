import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';


class FullScreen extends StatefulWidget {
  final ImageProvider<Object> image;
  final int index, points, page, vote, comments;
  final bool isVoted, filter;
  FullScreen(
      {Key? key,
      required this.image,
      required this.index,
      required this.points,
      required this.page,
      required this.isVoted,
      required this.filter,
      required this.vote,
       required this.comments})
      : super(key: key);

  @override
  _FullScreenState createState() => _FullScreenState();
}

class _FullScreenState extends State<FullScreen> {
 
  @override
  void initState() {
    
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  

  

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Stack(fit: StackFit.expand, children: [
            Container(
              alignment: Alignment.center,
              constraints: BoxConstraints(
                  minHeight: height * 0.5,
                  minWidth: 500,
                  maxHeight: height * 0.75),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      alignment: Alignment.center,
                      scale: 2,
                      image: widget.image,
                      fit: BoxFit.contain)),
            ),
            Container(
              width: width,
              alignment: Alignment.topCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                      onPressed: () => Navigator.pop(context)),
                  IconButton(
                      icon: Icon(
                        PipocaBasics.menu,
                        color: Colors.white,
                        size: 16,
                      ),
                      onPressed: () => print('hi'))
                ],
              ),
            ),
            
          ]),
        ));
  }
}
