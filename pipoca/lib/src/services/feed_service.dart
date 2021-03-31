import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/models/link_info_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/repositories/feed/feed_repository.dart';
import 'package:pipoca/src/repositories/feed/link_repository.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class FeedService extends IstoppableService {
  final _api = locator<FeedRepository>();
  final _link = locator<LinkRepository>();
  final _authenticationService = locator<AuthenticationService>();
  final _localStorage = locator<SharedLocalStorageService>();

  String _error;
  String get error => _error;

  BehaviorSubject<FeedInfo> _infoController = BehaviorSubject<FeedInfo>();
  Sink<FeedInfo> get feedInfo => _infoController.sink;

  // this will get the feed

  final BehaviorSubject<Feed> _feedController = BehaviorSubject<Feed>();
  Stream<Feed> get feedStream => _feedController.stream;


  StreamSubscription _streamSubscription;

  FeedService() {
    _streamSubscription = _infoController.stream.listen((FeedInfo info) async {
      print('yh aqio');
      await getFeed(
        lat: info.coordinates.latitude,
        lng: info.coordinates.longitude,
        page: info.page,
        filter: info.filter,
      );

      _feedController.onCancel = () {
        _feedController.close();
      };
     
    });
  }

  Future<Feed> getFeed(
      {double lat, double lng, int page, String filter}) async {
    Feed feed = await _api.getFeed(lat, lng, page, filter);
    if (feed == null) {
      int id = await _localStorage.recieve('id');
      var result = await _authenticationService.refreshToken(
          currentToken: _authenticationService.currentToken, id: id);
      if (result is bool) {
        if (result) {
          Feed feed = await _api.getFeed(lat, lng, page, filter);
          _feedController.sink.add(feed);

          return feed;
        }
      }
      _error = result;
      throw result;
    }
    
    _feedController.sink.add(feed);

    return feed;
  }

  @override
  void start() {
    super.start();

    _streamSubscription?.resume();
  }

  @override
  void stop() {
    super.stop();
    _streamSubscription?.pause();
  }
}
