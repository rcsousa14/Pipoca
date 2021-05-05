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
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/repositories/feed/comment_repository.dart';
import 'package:pipoca/src/repositories/feed/feed_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class FeedService extends IstoppableService with ReactiveServiceMixin {
  final _api = locator<FeedRepository>();
  final _newapi = locator<CommentRepository>();

  // ignore: close_sinks
  late BehaviorSubject<FeedInfo> _infoController;
  Sink<FeedInfo> get feedInfo => _infoController.sink;
  // ignore: close_sinks
  BehaviorSubject<bool> _newdata = BehaviorSubject.seeded(false);
  Sink<bool> get newSink => _newdata.sink;
  Stream<bool> get newStream => _newdata.stream;

  List<Data> _posts = [];
  List<Data> get posts => _posts;

  // this will get the feed

  // ignore: close_sinks
  late BehaviorSubject<ApiResponse<Feed>> _feedController;

  Sink<ApiResponse<Feed>> get feedSink => _feedController.sink;
  Stream<ApiResponse<Feed>> get feedStream => _feedController.stream;

  // ignore: close_sinks
  late BehaviorSubject<ApiResponse<SinglePost>> _postController;
  Sink<ApiResponse<SinglePost>> get postSink => _postController.sink;
  Stream<ApiResponse<SinglePost>> get postStream => _postController.stream;

  // ignore: cancel_subscriptions
  StreamSubscription? _subscription;

  FeedService() {
    _feedController = BehaviorSubject<ApiResponse<Feed>>();
    _infoController = BehaviorSubject<FeedInfo>();
    _postController = BehaviorSubject<ApiResponse<SinglePost>>();
    _subscription = _infoController.stream.listen((FeedInfo info) async {
      fetchFeed(info: info, isRefresh: true);
    });
  }

  Future fetchFeed(
      {required FeedInfo info, bool? isNew, required bool isRefresh}) async {
    bool newBool = isNew != null ? isNew : false;
    newSink.add(newBool);
    try {
      Feed data = await _api.getFeedData(
        lat: info.coordinates!.latitude,
        lng: info.coordinates!.longitude,
        page: info.page,
        filter: info.filter!,
      );

      if (isRefresh == true) {
        _posts = data.bagos!.data;
        _posts.sort((b, a) {
          return a.info.createdAt.compareTo(b.info.createdAt);
        });
      } else {
        data.bagos!.data.forEach((data) {
          if (_posts.any((post) => post.info.id == data.info.id) == false) {
            _posts.add(data);
          }
        });
        _posts.sort((b, a) {
          return a.info.createdAt.compareTo(b.info.createdAt);
        });
      }

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

  Future singlePost({required Coordinates coords, required int postId}) async {
    try {
      SinglePost data =
          await _newapi.getPostData(coords: coords, postId: postId);
      print(data);
      postSink.add(ApiResponse.completed(data));
    } catch (e) {
      postSink.add(ApiResponse.error(e.toString()));
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

  void delete(int id) {
    print(_posts.length);
    _posts.removeWhere((element) => element.info.id == id);
    print(_posts.length);
  }

  Future<ApiResponse<Generic>> deletPost({required int id}) async {
    ApiResponse.loading('loading');
    try {
      Generic data = await _api.deletePostData(id: id);
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
