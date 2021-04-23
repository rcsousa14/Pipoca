import 'package:flutter/material.dart';
import 'dart:async';

class FeedCaller extends StatefulWidget {
  final Function? caller;
  final Function? itemCreated;
  final Widget child;

  FeedCaller({Key? key, this.caller, required this.child, this.itemCreated})
      : super(key: key);

  @override
  _FeedCallerState createState() => _FeedCallerState();
}

class _FeedCallerState extends State<FeedCaller> {
  Timer? _timer;
  @override
  void initState() {
    super.initState();
    if (widget.itemCreated != null) {
      widget.itemCreated!();
    }

    if (widget.caller != null) {
      widget.caller!();

      _timer =
          Timer.periodic(Duration(seconds: 16), (timer) => widget.caller!());
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
