import 'dart:async';

import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:stacked/stacked.dart';

class BagoViewModel extends StreamViewModel<bool> {
  final _feedService = locator<FeedService>();


  bool _matches = true;
  bool get matches => _matches;
  double _progress = 0;
  double get value => _progress;

  void startTimer() {
    Timer.periodic(Duration(milliseconds: 300), (timer) {
      if (_progress == 1) {
        timer.cancel();
      } else {
        _progress += 0.05;
      }
      notifyListeners();
    });
  }

  @override

  Stream<bool> get stream => _feedService.newStream;

  
}
