import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/post_comments_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/repositories/feed/sub_repository.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';

@lazySingleton
class SubService extends IstoppableService with ReactiveServiceMixin {
  final _api = locator<SubRepository>();
  final _location = locator<LocationService>();
  final _authService = locator<AuthenticationService>();

  // ignore: close_sinks
  BehaviorSubject<CommentInfo> _infoController = BehaviorSubject<CommentInfo>();
  Sink<CommentInfo> get commentInfo => _infoController.sink;

// ignore: close_sinks
  BehaviorSubject<ApiResponse<SubComentario>> _subComment =
      BehaviorSubject<ApiResponse<SubComentario>>.seeded(
          ApiResponse.loading('loading...'));

  Sink<ApiResponse<SubComentario>> get subSink => _subComment.sink;
  Stream<ApiResponse<SubComentario>> get subStream => _subComment.stream;
  RxList<Data> _data = RxList<Data>();
  List<Data> get posts => _data;

  SubService() {
    listenToReactiveValues([_data]);
    _infoController.stream.listen((CommentInfo info) {
      fetchSubs(info: info, isRefresh: true);
    });
  }
  // FETCH ALL SUBS FROM COMMENT
  Future<ApiResponse<SubComentario>> fetchSubs(
      {required CommentInfo info,
      bool? isSwitch,
      required bool isRefresh}) async {
    if (isSwitch == true) {
      subSink.add(ApiResponse.loading('loading...'));
    }
    try {
      SubComentario data = await _api.getSubsData(
        coords: info.coordinates,
        commentId: info.id,
        page: info.page,
      );
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
      print(data);
      subSink.add(ApiResponse.completed(data));
      return ApiResponse.completed(data);
    } catch (e) {
      subSink.add(ApiResponse.error(e.toString()));
      return ApiResponse.error(e.toString());
    }
  }

  //POST SUB COMMENT
  Future<ApiResponse<Generic>> postComment(
      {required CreateSubComment post, required int commentId}) async {
    ApiResponse.loading('posting...');
    try {
      Generic data = await _api.postSubData(post: post, commentId: commentId);
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
 //SINGLE SUB 
   Future<ApiResponse<SinglePost>> singlePost({required PostInfo info}) async {
    try {
      SinglePost data = await _api.getSubData(coords: info.coordinates, subId: info.id);

     
      return ApiResponse.completed(data);
    } catch (e) {
     
      return ApiResponse.error(e.toString());
    }
  }
  // SUB COMMENT VOTE
  Future<ApiResponse<Generic>> pointComment({
    required PostPoint point,
  }) async {
    ApiResponse.loading('loading');
    try {
      Generic data = await _api.subPointData(point);

      _data.sort((b, a) {
        return a.info!.votesTotal!.compareTo(b.info!.votesTotal!);
      });

      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  //SUB COMMENT DELETE
  Future<ApiResponse<Generic>> deletPost({required int id}) async {
    ApiResponse.loading('loading');
    try {
      Generic data = await _api.deleteSubData(id: id);
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }

  //TODO: stop the caller
  @override
  void start() {
    super.start();

    
  }

  @override
  void stop() {
    super.stop();
    
  }
}
