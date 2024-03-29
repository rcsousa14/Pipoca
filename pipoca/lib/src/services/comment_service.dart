import 'package:injectable/injectable.dart';
import 'package:observable_ish/observable_ish.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/create_post_model.dart';
import 'package:pipoca/src/models/post_comments_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/repositories/feed/comment_repository.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked/stacked.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';

@lazySingleton
class CommentService extends IstoppableService with ReactiveServiceMixin {
  final _api = locator<CommentRepository>();
  final _location = locator<LocationService>();
  final _authService = locator<AuthenticationService>();

  // this is for the change of the filter for the feed
  // ignore: close_sinks
 BehaviorSubject<CommentInfo> _infoController =
      BehaviorSubject<CommentInfo>();
  Sink<CommentInfo> get commentInfo => _infoController.sink;

// ignore: close_sinks
  BehaviorSubject<ApiResponse<Comentario>> _comment =
      BehaviorSubject<ApiResponse<Comentario>>.seeded(
          ApiResponse.loading('loading...'));
  Sink<ApiResponse<Comentario>> get commentSink => _comment.sink;
  Stream<ApiResponse<Comentario>> get commentStream => _comment.stream;

  RxList<Data> _data = RxList<Data>();
  List<Data> get posts => _data;

  CommentService() {
    listenToReactiveValues([_data]);
    _infoController.stream.listen((CommentInfo info) {
      fetchComments(info: info, isSwitch: true, isRefresh: true);
    });
  }
 // FETCH ALL COMMENTS FROM POST
  Future<ApiResponse<Comentario>> fetchComments(
      {required CommentInfo info,
      bool? isSwitch,
      required bool isRefresh}) async {
    if (isSwitch == true) {
      commentSink.add(ApiResponse.loading('loading...'));
    }
    try {
      Comentario data = await _api.getCommentsData(
          coords: info.coordinates,
          postId: info.id,
          page: info.page,
          filter: info.filter!);
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
      commentSink.add(ApiResponse.completed(data));
      return ApiResponse.completed(data);
    } catch (e) {
      commentSink.add(ApiResponse.error(e.toString()));
      return ApiResponse.error(e.toString());
    }
  }

  void back() {
    _data = RxList<Data>();
  }
 // POST COMMENT 
  Future<ApiResponse<Generic>> postComment(
      {required CreatePost post, required int postId}) async {
    ApiResponse.loading('posting...');
    try {
      Generic data = await _api.postCommentData(post: post, postId: postId);
      return ApiResponse.completed(data);
    } catch (e) {
      return ApiResponse.error(e.toString());
    }
  }
   //SINGLE SUB 
   Future<ApiResponse<SinglePost>> singlePost({required PostInfo info}) async {
    try {
      SinglePost data = await _api.getCommentData(coords: info.coordinates, commentId: info.id);

     
      return ApiResponse.completed(data);
    } catch (e) {
     
      return ApiResponse.error(e.toString());
    }
  }

  // COMMENT VOTE 
  Future<ApiResponse<Generic>> pointComment(
      {required PostPoint point, required String filter}) async {
    ApiResponse.loading('loading');
    try {
      Generic data = await _api.commentPointData(point);
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
   //COMMENT DELETE
   Future<ApiResponse<Generic>> deletPost({required int id}) async {
    ApiResponse.loading('loading');
    try {
      Generic data = await _api.deleteCommentData(id: id);
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
