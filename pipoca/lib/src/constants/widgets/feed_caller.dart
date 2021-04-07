import 'package:flutter/material.dart';
import 'dart:async';

class FeedCaller extends StatefulWidget {
  final Function caller;
  final Widget child;

  FeedCaller({Key key, @required this.caller, this.child}) : super(key: key);

  @override
  _FeedCallerState createState() => _FeedCallerState();
}

class _FeedCallerState extends State<FeedCaller> {
  Timer _timer;
  @override
  void initState() {
    super.initState();

    if (widget.caller != null) {
      widget.caller();
 
       _timer = Timer.periodic(Duration(minutes: 3), (timer) => widget.caller());
      
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
