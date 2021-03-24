import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/widgets/bottom_nav_widgets/bottom_nav_element.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class PostViewModel extends BaseViewModel {
  final double lat;
  final double lng;
  PostViewModel({this.lat, this.lng});
  final NavigationService _navigationService = locator<NavigationService>();
  
  // final SnackbarService _snackbarService = locator<SnackbarService>();
  // final DialogService _dialogService = locator<DialogService>();
  // final AuthenticationService _authenticationService =
  //     locator<AuthenticationService>();
 
  String _text = '';
  String get text => _text;

  // RegExp _tag = RegExp(r"\B(\#[a-zA-Z]+\b)(?!;)");
  // RegExp _link = RegExp(
  //     r"https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,}");
  void updateString(String value) {
    _text = value;

    notifyListeners();
  }

  void deleteString() {
    _text = '';
    notifyListeners();
  }

  Future addPost(NavChoice choice) async {
    setBusy(true);
    
      

      // if (result is String) {
      //   await _dialogService.showDialog(
      //       title: 'Não foi possível criar Bago', description: result);
      // } else {
      //   _snackbarService.showSnackbar(message: 'seu Bago foi enviado');
      //   await goBack(choice);
      // }
    

    setBusy(false);
  }

  Future<dynamic> goBack(NavChoice choice) {
    return _navigationService.navigateTo(choice.initialPageRoute(),
        id: choice.nestedKeyValue());
  }
}
