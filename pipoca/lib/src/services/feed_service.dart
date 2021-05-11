import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/repositories/feed/feed_repository.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class FeedService extends IstoppableService with ReactiveServiceMixin {
  final _api = locator<FeedRepository>();

  // this is for the change of the filter for the feed
  // ignore: close_sinks
  late BehaviorSubject<FeedInfo> _infoController;
  Sink<FeedInfo> get feedInfo => _infoController.sink;

  // this is for the loading indicator for the new post
  // ignore: close_sinks
  BehaviorSubject<bool> _newPost = BehaviorSubject<bool>.seeded(false);
  Sink<bool> get newPostSink => _newPost.sink;
  Stream<bool> get newPostStream => _newPost.stream;

  //Mainly will be using this for the feed and new post

// ignore: close_sinks
  BehaviorSubject<ApiResponse<Feed>> _feed =
      BehaviorSubject<ApiResponse<Feed>>.seeded(
          ApiResponse.loading('loading...'));
  Sink<ApiResponse<Feed>> get feedSink => _feed.sink;
  Stream<ApiResponse<Feed>> get feedStream => _feed.stream;

  RxValue<Data> _single = RxValue<Data>(Data());
  Data get single => _single.value;

  RxList<Data> _data = RxList<Data>();
  List<Data> get posts => _data;

  // ignore: cancel_subscriptions
  late StreamSubscription _feedSub;

  FeedService() {
    listenToReactiveValues([_data, _single]);

    _infoController = BehaviorSubject<FeedInfo>();
    _feedSub = _infoController.stream.listen((FeedInfo info) {
  
      fetchFeed(info: info, isSwitch: true, isRefresh: true);
    });
  }

  Future<ApiResponse<Feed>> fetchFeed(
      {required FeedInfo info, bool? isSwitch, required bool isRefresh}) async {
    if (isSwitch == true) {
      feedSink.add(ApiResponse.loading('loading...'));
    }

    try {
      Feed data = await _api.getFeedData(
        lat: info.coordinates!.latitude,
        lng: info.coordinates!.longitude,
        page: info.page,
        filter: info.filter!,
      );

      feedSink.add(ApiResponse.completed(data));
      print(data);
      if (isRefresh == true ) {
        _data.clear();
        _data.addAll(data.bagos!.data);
        if (info.filter == 'date') {
          _data.sort((b, a) {
            return a.info!.createdAt.compareTo(b.info!.createdAt);
          });
        } else {
          _data.sort((b, a) {
            return a.info!.votesTotal.compareTo(b.info!.votesTotal);
          });
        }
      } else {
        data.bagos!.data.forEach((data) {
          if (_data.any((post) => post.info!.id == data.info!.id) == false) {
            _data.add(data);
          }
        });
        if (info.filter == 'date') {
          _data.sort((b, a) {
            return a.info!.createdAt.compareTo(b.info!.createdAt);
          });
        } else {
          _data.sort((b, a) {
            return a.info!.votesTotal.compareTo(b.info!.votesTotal);
          });
        }
      }

      newPostSink.add(false);
      return ApiResponse.completed(data);
    } catch (e) {
      newPostSink.add(false);
      feedSink.add(ApiResponse.error(e.toString()));
      return ApiResponse.error(e.toString());
    }
  }

  logoutFeed() {
    feedSink.add(ApiResponse.loading('loading...'));
  }

  Future<ApiResponse<Generic>> postFeed({required CreatePost post}) async {
    ApiResponse.loading('posting...');
    newPostSink.add(true);
    try {
      Generic data = await _api.postFeedData(post);

      return ApiResponse.completed(data);
    } catch (e) {
      newPostSink.add(false);
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<SinglePost>> singlePost({required PostInfo info}) async {
    ApiResponse.loading('posting...');
    try {
      SinglePost data =
          await _api.getPostData(coords: info.coordinates, postId: info.id);

      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  Future<ApiResponse<Generic>> pointPost(
      {required PostPoint point, required String filter}) async {
    ApiResponse.loading('loading');
    try {
      Generic data = await _api.postPointData(point);
      if (filter == 'date') {
        _data.sort((b, a) {
          return a.info!.createdAt.compareTo(b.info!.createdAt);
        });
      } else {
        _data.sort((b, a) {
          return a.info!.votesTotal.compareTo(b.info!.votesTotal);
        });
      }
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  void delete(int id) {
    _data.removeWhere((element) => element.info!.id == id);
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
    _feedSub.resume();
  }

  @override
  void stop() {
    super.stop();
    _feedSub.pause();
  }
}
