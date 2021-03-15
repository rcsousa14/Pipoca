import 'package:flutter/material.dart';


class Logo extends StatelessWidget {
  const Logo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.35),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                    'images/red.png',
                    width: 55,
                    height: 55,
                  ),
                Text(
                  'Pipoca',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 45),
                ),
              ],
            ),
          ],
        ));
  }
}
