

import 'package:injectable/injectable.dart';
import 'package:pipoca/src/interfaces/local_storage_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';


@lazySingleton
class SharedLocalStorageService implements ILocalStorage {

  

  

  @override
  Future clear() async {
    var shared = await SharedPreferences.getInstance();
    return shared.clear();
  }

  @override
  Future recieve(String key) async {
    var shared = await SharedPreferences.getInstance();
    return shared.get(key);
  }

  @override
  Future delete(String key) async {
    var shared = await SharedPreferences.getInstance();
    return shared.remove(key);
  }

  @override
  Future put(String key, dynamic value) async {
      var shared = await SharedPreferences.getInstance();
    if (value is bool) {
      shared.setBool(key, value);
    } else if (value is String) {
      shared.setString(key, value);
    } else if (value is int) {
      shared.setInt(key, value);
    } else if (value is double) {
      shared.setDouble(key, value);
    } else if(value is List<String>){
      shared.setStringList(key, value);
    }
  
    
  }
}
