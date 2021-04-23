import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/user_feed_model.dart';
import 'package:pipoca/src/services/feed_service.dart';
import 'package:stacked/stacked.dart';

class BagoViewModel extends ReactiveViewModel {
  final _feedService = locator<FeedService>();

  CheckData get checkNew => _feedService.checkNew;
  bool _matches = true;
  bool get matches => _matches;

  checkDate(CheckData data) {
    if (data.content.isNotEmpty) {
      if (checkNew.content != data.content &&
              checkNew.creator != data.creator &&
              checkNew.createdAt != data.createdAt ||
          checkNew.creator == data.creator &&
              checkNew.content == data.content &&
              DateTime.parse(data.createdAt)
                  .isBefore(DateTime.parse(checkNew.createdAt))) {
        _matches = false;
        notifyListeners();
      } else {
        _matches = true;
        notifyListeners();
      }
    }
  }

  List<ReactiveServiceMixin> get reactiveServices => [_feedService];
}
