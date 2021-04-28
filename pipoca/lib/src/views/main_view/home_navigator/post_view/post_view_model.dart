import 'package:pipoca/src/app/locator.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PostViewModel extends BaseViewModel {
  final int id;
  PostViewModel(this.id);
  final _navigationService = locator<NavigationService>();
  
  goBack() {
    return _navigationService.back();
  }
}
