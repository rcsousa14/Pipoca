import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/interfaces/stoppable_interface.dart';
import 'package:pipoca/src/models/user_model.dart';
import 'package:pipoca/src/repositories/user/user_repository.dart';
import 'package:rxdart/rxdart.dart';

@lazySingleton
class UserManager extends IstoppableService {
  final _userRepo = locator<UserApi>();
  final BehaviorSubject<Usuario> userController = BehaviorSubject<Usuario>();
  
  Stream<Usuario> get userData async* {
    
      yield await _userRepo.getUser();
    
  }
 UserManager(){
   //TODO: error handling
   userData.listen((event)=> userController.add(event));
 }

}