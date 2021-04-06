import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pipoca/src/assets/pipoca_basics_icons.dart';

class FullScreen extends StatefulWidget {
  final ImageProvider<Object> image;
  FullScreen({Key key, @required this.image}) : super(key: key);

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
            Container(
                width: width,
              
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 50,
                  color: Colors.black.withOpacity(0.7),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () => print('hi'),
                            child: Container(
                              child: Icon(
                                PipocaBasics.up_arrow,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                           SizedBox(
                            width: 5,
                          ),
                           Text('0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                           SizedBox(
                            width: 5,
                          ),
                          InkWell(
                            highlightColor: Colors.red,
                            onTap: () => print('hi'),
                            child: Container(
                              child: Icon(
                                PipocaBasics.down_arrow,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: <Widget>[
                      //     InkWell(
                      //       onTap: () => print('hi'),
                      //       child: Container(
                      //         child: Icon(
                      //           PipocaBasics.up_arrow,
                      //           size: 20,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     Center(
                      //       child: Text('0',
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: 13,
                      //               fontWeight: FontWeight.w600)),
                      //     ),
                      //     SizedBox(
                      //       width: 5,
                      //     ),
                      //     InkWell(
                      //       highlightColor: Colors.red,
                      //       onTap: () => print('hi'),
                      //       child: Container(
                      //         child: Icon(
                      //           PipocaBasics.down_arrow,
                      //           size: 20,
                      //           color: Colors.white,
                      //         ),
                      //       ),
                      //     )
                      //   ],
                      // ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('0',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600)),
                          SizedBox(
                            width: 5,
                          ),
                          Container(
                            child: Icon(
                              PipocaBasics.chat,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => print('hi'),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              PipocaBasics.export,
                              size: 19,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Text('PARTILHAR',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ]),
        ));
  }
}
