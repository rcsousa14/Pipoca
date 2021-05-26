import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/repositories/feed/feed_repository.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class FeedService extends IstoppableService with ReactiveServiceMixin {
  final _api = locator<FeedRepository>();
  final _location = locator<LocationService>();
  final _authService = locator<AuthenticationService>();

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

  // ignore: close_sinks
  BehaviorSubject<ApiResponse<SinglePost>> _single =
      BehaviorSubject<ApiResponse<SinglePost>>();
  Sink<ApiResponse<SinglePost>> get singleSink => _single.sink;
  Stream<ApiResponse<SinglePost>> get singleStream => _single.stream;

  RxList<Data> _data = RxList<Data>();
  List<Data> get posts => _data;

  FeedService() {
    listenToReactiveValues([_data]);

    _infoController = BehaviorSubject<FeedInfo>();
    _infoController.stream.listen((FeedInfo info) {
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
        coords: info.coordinates,
        page: info.page,
        filter: info.filter,
      );

      feedSink.add(ApiResponse.completed(data));
      print(data);
      if (isRefresh == true) {
        _data.clear();
        _data.addAll(data.bagos!.data);
        if (info.filter == 'date') {
          _data.sort((b, a) {
            return a.info!.createdAt.compareTo(b.info!.createdAt);
          });
        } else {
          _data.sort((b, a) {
            return a.info!.votesTotal!.compareTo(b.info!.votesTotal!);
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
            return a.info!.votesTotal!.compareTo(b.info!.votesTotal!);
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
    try {
      SinglePost data =
          await _api.getPostData(coords: info.coordinates, postId: info.id);
      _data[_data.indexWhere(
          (element) => element.info!.id == data.data!.info!.id)] = data.data!;
          
      singleSink.add(ApiResponse.completed(data));
      return ApiResponse.completed(data);
    } catch (e) {
      singleSink.add(ApiResponse.error(e.toString()));
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
          return a.info!.votesTotal!.compareTo(b.info!.votesTotal!);
        });
      }
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  void back() {
    _single.add(ApiResponse.completed(SinglePost()));
  }

  void delete(int id, bool isSingle) {
    _data.removeWhere((element) => element.info!.id == id);
    if (isSingle == true) {
      _single.add(ApiResponse.completed(SinglePost()));
    }
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

    feedSink.add(ApiResponse.loading('loading'));
    Future.delayed(Duration(milliseconds: 350));
    fetchFeed(
        info: FeedInfo(
            page: 1,
            filter: _authService.filter == false ? 'date' : 'pipocar',
            coordinates: _location.currentLocation),
        isRefresh: true);
  }

  @override
  void stop() {
    super.stop();
    singleSink.add(ApiResponse.stop('stopped'));
    feedSink.add(ApiResponse.stop('stopped'));
  }
}
