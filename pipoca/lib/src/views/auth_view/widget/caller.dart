import 'package:flutter/material.dart';

class InitCaller extends StatefulWidget {
  final Widget child;
  final Function init;
  InitCaller({Key? key, required this.child, required this.init})
      : super(key: key);

  @override
  _InitCallerState createState() => _InitCallerState();
}

class _InitCallerState extends State<InitCaller> {
  @override
  void initState() {
    widget.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
