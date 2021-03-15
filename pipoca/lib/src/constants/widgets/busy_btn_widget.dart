import 'package:flutter/material.dart';

class BusyBtn extends StatelessWidget {
  final Function tap;
  final String text;
  final bool busy;
  final Color btnColor;
  final Color txtColor;
  const BusyBtn(
      {Key key,
      this.tap,
      this.busy = false,
      this.txtColor,
      this.text,
      this.btnColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: btnColor,
        elevation: 0.8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      onPressed: tap,
      child: !busy
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                      color: txtColor, fontWeight: FontWeight.w500),
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
                    valueColor: AlwaysStoppedAnimation<Color>(txtColor),
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
  final Color btnColor;
   final Color txtColor;
  const BusyBtnLogin(
      {Key key, this.tap, @required this.icon, this.txtColor, this.busy = false, this.text, @required this.btnColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
       style: ElevatedButton.styleFrom(
        primary: btnColor,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: !busy ? tap : null,
      child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  icon,
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    text,
                    style: TextStyle(
                        color: txtColor != null ? txtColor : Colors.white, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
        
    );
  }
}
