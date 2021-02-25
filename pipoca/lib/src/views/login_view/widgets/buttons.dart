import 'package:flutter/material.dart';

class BusyBtn extends StatelessWidget {
  final Function tap;
  final String text;
  final bool busy;
  final Color color;
  const BusyBtn({Key key, this.tap, this.busy = false, this.text, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
     margin: EdgeInsets.only(top: 8, left: 20, right: 20),
      child: RaisedButton(
        color: color,
        elevation: 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
        ),
        onPressed: tap,
        child: !busy
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    text,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}