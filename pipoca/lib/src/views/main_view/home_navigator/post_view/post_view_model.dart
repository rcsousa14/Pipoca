import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:stacked/stacked.dart';

class PostViewModel extends BaseViewModel {
  final PageController controller;

  PostViewModel({@required this.controller});

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

  Future addPost() async {
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

  goBack() {
    _text = '';
    notifyListeners();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    
    return controller.jumpToPage(0);
  }
}
