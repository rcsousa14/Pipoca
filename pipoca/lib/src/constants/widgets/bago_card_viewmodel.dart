import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/social_share_service.dart';
import 'package:stacked/stacked.dart';


class BagoCardViewModel extends BaseViewModel {
 


  //final NavigationService _navigationService = locator<NavigationService>();
  final CapturePngService _captureService = locator<CapturePngService>();
  final UrlLancherService _lancherService = locator<UrlLancherService>();

  bool _hasLink = false;
  String _url = '';
  String _newText = '';
  String _newUrl = '';
  String get newText => _newText;
  bool get hasLink => _hasLink;
  String get url => _url;
  String get newUrl => _newUrl;

  RegExp _link = RegExp(
      r"https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,}");
  Future linkCheck({String text}) async {
    bool check = _link.hasMatch(text);
    if (check) {
      _hasLink = true;

      var links = _link.allMatches(text);
      if (links.length >= 0) {
        var link = _link.firstMatch(text);
        _url = text.substring(link.start, link.end);

        RegExp urlLink = RegExp(r"^(http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)");
        var u = urlLink.firstMatch(_url);
       String _new = _url.substring( u.end, _url.length);

      if(_new.indexOf('/') != null){
        _newUrl = _new.substring(0, _new.indexOf('/'));
      } else {
        _newUrl = _new; 
      }
      

        // if (_new.contains('www')) {
        //   String u = _url.substring(_new.indexOf("."), _new.length);
        //   _newUrl = u;
        // if (u.indexOf('/') != null) {
        //   _newUrl = u.substring(0, u.indexOf('/'));
        //   notifyListeners();
        // }

        //else {
        //     if (_new.lastIndexOf('/') != null) {
        //   _newUrl = _new.substring(0, _url.indexOf('/'));
        // }
        //   }
        // }

        //https://stackoverflow.com/questions/59763793/flutter-remove-string-after-certain-character
        _newText = text.replaceAll(_link, "").trim();

        notifyListeners();
      }
      notifyListeners();
    } else {
      _newText = text;
      notifyListeners();
    }
  }

  void upVote() {
    //TODO: post on db
    // post in the db
  }

  void downVote() {
    // post in the db
  }

  Future share(key) async {
    return await _captureService.capturePng(key);
  }

  Future social(uri) async {
    return await _lancherService.social(uri);
  }

//TODO: navigation to the next page
  // Future<dynamic> selected({int ofBagoIndex}) {
  //   return _navigationService.navigateTo('/post/:id',
  //       arguments: PostsViewArguments(
  //         bagoIndex: ofBagoIndex,
  //       ),
  //       id: 1);
  // }
}
