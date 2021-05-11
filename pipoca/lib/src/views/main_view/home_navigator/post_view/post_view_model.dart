import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/models/user_location_model.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:pipoca/src/services/location_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PostViewModel extends BaseViewModel {
  final int id;
  PostViewModel(this.id);
  final _navigationService = locator<NavigationService>();
  final _location = locator<LocationService>();

  final _feedService = locator<FeedService>();

  
  
}
