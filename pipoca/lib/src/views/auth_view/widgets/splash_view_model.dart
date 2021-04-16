import 'dart:io';

import 'package:pipoca/src/constants/api_helpers/response.dart';
import 'package:pipoca/src/models/auth_token_model.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/services/shared_local_storage_service.dart';
import 'package:pipoca/src/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/services/authentication_service.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends FutureViewModel<ApiResponse<AuthenticationResponse>> {
  final _userService = locator<UserService>();
  final _authenticationService = locator<AuthenticationService>();
  final _dialogService = locator<DialogService>();
 

  bool _isConnected = false;
  bool get isConnected => _isConnected;
  String get token => '';

  Future checkInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        _isConnected = true;
        print('isConnected: $_isConnected');
        notifyListeners();
      }
    } on SocketException catch (_) {
      DialogResponse? res = await _dialogService.showDialog(
          title: 'Internet',
          description: 'Sem conexão com a Internet🌐',
          buttonTitle: 'Tentar Novamente');
      if (res!.confirmed) {
        await checkInternet();
      }
    }
  }

  Future<ApiResponse<Usuario>> fetch() async {
    
    var result = await _userService.fetchUser();
    return result;
  }

  

  @override
  Future<ApiResponse<AuthenticationResponse>> futureToRun()=> _authenticationService.resetToken();
}
