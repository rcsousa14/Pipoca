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
    return RaisedButton(
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
                      color: Colors.grey[900], fontWeight: FontWeight.w500),
                ),
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.grey[900]),
                  ),
                ),
              ),
            ),
    );
  }
}

class BusyBtnLogin extends StatelessWidget {
  final Function tap;
  final Widget icon;
  final String text;
  final bool busy;
  final Color color;
  const BusyBtnLogin(
      {Key key, this.tap, this.icon, this.busy = false, this.text, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      color: color,
      elevation: 0.8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
      onPressed: tap,
      child: !busy
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  icon,
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
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
    );
  }
}