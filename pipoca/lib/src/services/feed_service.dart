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

  late BehaviorSubject<FeedInfo> _infoController;
  Sink<FeedInfo> get feedInfo => _infoController.sink;

  // this will get the feed

  late BehaviorSubject<ApiResponse<Feed>> _feedController;

  Sink<ApiResponse<Feed>> get feedSink => _feedController.sink;
  Stream<ApiResponse<Feed>> get feedStream => _feedController.stream;
  RxValue<CreatePost> _newPost = RxValue<CreatePost>(CreatePost(content: ''));

  // new post rxValue
  CreatePost get newPost => _newPost.value;

  FeedService() {
    listenToReactiveValues([_newPost]);
    _feedController = BehaviorSubject<ApiResponse<Feed>>();
    _infoController = BehaviorSubject<FeedInfo>();
    _infoController.stream.listen((FeedInfo info) async {
      print('I have changed the info:: $info');
      fetchFeed(info);
    });
  }

  fetchFeed(FeedInfo info) async {
    feedSink.add(ApiResponse.loading('loading ..'));

    try {
      Feed data = await _api.getFeedData(
        lat: info.coordinates!.latitude,
        lng: info.coordinates!.longitude,
        page: info.page,
        filter: info.filter!,
      );
      print(data);
      _newPost.value = CreatePost(content: '');
      feedSink.add(ApiResponse.completed(data));
    } catch (e) {
      feedSink.add(ApiResponse.error(e.toString()));
    }
  }

  Future<ApiResponse<Generic>> postFeed({required CreatePost post}) async {
    ApiResponse.loading('posting...');
    _newPost.value = post;
    try {
      Generic data = await _api.postFeedData(post);
      _newPost.value = post;
     return ApiResponse.completed(data);
    } catch (e) {
      _newPost.value = CreatePost(content: '');
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
  }

  @override
  void stop() {
    super.stop();

    _feedController.close();
    _infoController.close();
  }
}
