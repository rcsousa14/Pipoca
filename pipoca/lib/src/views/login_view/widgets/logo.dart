import 'package:flutter/material.dart';
import 'package:pipoca/src/constants/themes/colors.dart';

class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     var height = MediaQuery.of(context).size.height;
    return Column(
    children: [
      Container(
          height: height * 0.5,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomLeft,
              colors: [red, orange],
            ),
          ),
          child: Container(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 160),
                child: Image.asset('images/white.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.5),
                child: Text(
                  'Pipoca',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              )
            ],
          ))),
      Container(
        height: height * 0.5,
        color: Colors.white,
      )
    ],
  );
  }
}
