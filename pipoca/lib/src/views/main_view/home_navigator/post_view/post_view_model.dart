import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PostViewModel extends StreamViewModel<ApiResponse<SinglePost>> {
  final int id;
  PostViewModel(this.id);
  final _navigationService = locator<NavigationService>();
  
  final _feedService = locator<FeedService>();
  goBack() {
    return _navigationService.back();
  }

  @override
  
  Stream<ApiResponse<SinglePost>> get stream => _feedService.postStream;
}
