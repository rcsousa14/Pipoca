import 'package:flutter/widgets.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/repositories/feed/post_point_repository.dart';
import 'package:pipoca/src/services/caller.service.dart';
import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:pipoca/src/services/social_share_service.dart';
import 'package:stacked/stacked.dart';


class BagoCardViewModel extends BaseViewModel {
  final _feedService = locator<FeedService>();
  final _location = locator<LocationService>();
  final _callerService = locator<CallerService>();
  final CapturePngService _captureService = locator<CapturePngService>();
  final UrlLancherService _lancherService = locator<UrlLancherService>();
  final PostPointRepository _pointRepository = locator<PostPointRepository>();

  bool _isUp;
  bool _isDown;
  int _totalPoints;
  int get points => _totalPoints;
  bool get up => _isUp;
  bool get down => _isDown;

  void getVote(bool isVoted, int vote, int points) {
    _totalPoints = points;
    if (isVoted == true) {
      if (vote == -1) {
        _isUp = false;
        _isDown = true;
        notifyListeners();
      } else {
        _isUp = true;
        _isDown = false;
        notifyListeners();
      }
    }
    notifyListeners();
  }

  Future vote({
    @required int id,
    @required int vote,
    @required bool isVoted,
    bool filter,
    int page,
    int points,
  }) async {
    if (vote == -1) {
      if (points == 0 && isVoted == true ||
          points == 1 && isVoted == true ||
          points == 0 && isVoted == false) {
        _totalPoints = vote;
      } else {
        --_totalPoints;
      }

      _isUp = false;
      _isDown = true;
      notifyListeners();
    } else {
      if (points == 0 && isVoted == true ||
          points == -1 && isVoted == true ||
          points == 0 && isVoted == false) {
        _totalPoints = vote;
        notifyListeners();
      } else {
        ++_totalPoints;
        notifyListeners();
      }

      _isUp = true;
      _isDown = false;
      notifyListeners();
    }
    await _pointRepository.postPoint(id.toString(), vote.toString());
    int level = await _callerService.batteryLevel();
    await _callerService.battery(
        level,
        _feedService.getFeed(
          page: page,
          lat: _location.currentLocation.latitude,
          lng: _location.currentLocation.longitude,
          filter: filter == false ? 'date' : 'pipocar',
        ));
    _totalPoints = points;
    notifyListeners();
  }

  Future share(key) async {
    return await _captureService.capturePng(key);
  }

  Future social(uri) async {
    return await _lancherService.social(uri);
  }

//TODO: navigation to the next page
  // Future<dynamic> selected({int ofBagoIndex}) {
  //   return _navigationService.navigateTo('/post/:id',
  //       arguments: PostsViewArguments(
  //         bagoIndex: ofBagoIndex,
  //       ),
  //       id: 1);
  // }
}
