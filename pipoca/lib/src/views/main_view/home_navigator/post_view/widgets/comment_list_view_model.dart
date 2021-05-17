import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/post_comments_model.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/services/comment_service.dart';
import 'package:stacked/stacked.dart';

class CommentListViewModel extends StreamViewModel<ApiResponse<Comentario>> {
  final _commentService = locator<CommentService>();

List<Data> get posts => _commentService.posts;


  @override
 
  Stream<ApiResponse<Comentario>> get stream => _commentService.commentStream;

  handleItemCreated(int index, Comentario comentario) {}

}