import 'package:flutter/material.dart';
import 'dart:async';

class FeedCaller extends StatefulWidget {
  final Function? caller;
  final Function? itemCreated;
  final Widget child;

  FeedCaller(
      {Key? key,
      this.caller,
      required this.child,
      this.itemCreated,
      })
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
      _timer = Timer.periodic(Duration(seconds: 30), (timer) {
        widget.caller!();
      });
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

class PostCaller extends StatefulWidget {
   final Function? itemCaller;
  final Widget child;
  PostCaller({Key? key, required this.child, this.itemCaller}) : super(key: key);

  @override
  _PostCallerState createState() => _PostCallerState();
}

class _PostCallerState extends State<PostCaller> {
  Timer? _single;

  @override
  void initState() {
   if (widget.itemCaller != null) {
          _single = Timer.periodic(
              Duration(seconds: 1), (timer) => widget.itemCaller!());
        }
    super.initState();
  }
   @override
  void dispose() {

    _single?.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
