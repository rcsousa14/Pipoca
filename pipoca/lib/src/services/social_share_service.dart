import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class UrlLancherService{
  social(String uri) async{
   try{
     if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      print("Nao foi possivel");
    }
   }catch(e){
     print(e);
   }
   
  } 
}