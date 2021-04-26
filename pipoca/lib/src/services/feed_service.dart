import 'dart:async';
import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/repositories/feed/feed_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class FeedService extends IstoppableService with ReactiveServiceMixin {
  final _api = locator<FeedRepository>();

  // ignore: close_sinks
  late BehaviorSubject<FeedInfo> _infoController;
  Sink<FeedInfo> get feedInfo => _infoController.sink;
  // ignore: close_sinks
  BehaviorSubject<bool> _newdata = BehaviorSubject.seeded(false);
  Sink<bool> get newSink => _newdata.sink;
  Stream<bool> get newStream => _newdata.stream;

  //List<Data> posts = [];

  // this will get the feed

  // ignore: close_sinks
  late BehaviorSubject<ApiResponse<Feed>> _feedController;

  Sink<ApiResponse<Feed>> get feedSink => _feedController.sink;
  Stream<ApiResponse<Feed>> get feedStream => _feedController.stream;

  // ignore: cancel_subscriptions
  StreamSubscription? _subscription;

  FeedService() {
    _feedController = BehaviorSubject<ApiResponse<Feed>>();
    _infoController = BehaviorSubject<FeedInfo>();
    _subscription = _infoController.stream.listen((FeedInfo info) async {
      fetchFeed(info: info);
    });
  }

  Future fetchFeed({required FeedInfo info, bool? isNew}) async {
    bool newBool = isNew != null ? isNew : false;
    newSink.add(newBool);
    try {
      Feed data = await _api.getFeedData(
        lat: info.coordinates!.latitude,
        lng: info.coordinates!.longitude,
        page: info.page,
        filter: info.filter!,
      );
      
      print(data);

      newSink.add(false);
      feedSink.add(ApiResponse.completed(data));
    } catch (e) {
      newSink.add(false);

      feedSink.add(ApiResponse.error(e.toString()));
    }
  }

  logoutFeed() {
    feedSink.add(ApiResponse.loading('loading...'));
  }

  Future<ApiResponse<Generic>> postFeed({required CreatePost post}) async {
    ApiResponse.loading('posting...');

    try {
      Generic data = await _api.postFeedData(post);

      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<Generic>> pointPost({required PostPoint point}) async {
    ApiResponse.loading('loading');
    try {
      Generic data = await _api.postPointData(point);
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  @override
  void start() {
    super.start();
    _subscription!.resume();
  }

  @override
  void stop() {
    super.stop();
    _subscription!.pause();
  }
}
