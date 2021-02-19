import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/app/router.gr.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SplashViewModel extends BaseViewModel {
  
  /* LOCATOR */
  final _navigationService = locator<NavigationService>();


  /* LOCATION CHECK CANNOT USE THE APP WITHOUT IT*/
  Future<dynamic> locationCheck() async {
    Future.delayed(const Duration(seconds: 3), () async {
    
      
       
          return _navigationService.replaceWith(Routes.loginView);
 
    
    });
  }

  
}
