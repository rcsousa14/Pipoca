import 'package:flutter/foundation.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/models/youtube_model.dart';
import 'package:pipoca/src/services/capture_png_service.dart';
import 'package:pipoca/src/services/social_share_service.dart';
import 'package:pipoca/src/services/youtube_service.dart';
import 'package:stacked/stacked.dart';


class BagoCardViewModel extends BaseViewModel {
  final String text;
  final int  page;
 
  
  
  BagoCardViewModel({ @required this.text,  @required this.page });
  //final NavigationService _navigationService = locator<NavigationService>();
  final CapturePngService _captureService = locator<CapturePngService>();
  final UrlLancherService _lancherService = locator<UrlLancherService>();
  final YoutubeService _youtubeService = locator<YoutubeService>();
  bool _hasLink = false;
  String _url = '';
  String _newText = '';
  String get newText => _newText;
  bool get hasLink => _hasLink;
  String get url => _url;
  Youtube _youtube;
  Youtube get youtube => _youtube;
  RegExp _link = RegExp(
      r"https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|www\.[a-zA-Z0-9][a-zA-Z0-9-]+[a-zA-Z0-9]\.[^\s]{2,}|https?:\/\/(?:www\.|(?!www))[a-zA-Z0-9]+\.[^\s]{2,}|www\.[a-zA-Z0-9]+\.[^\s]{2,}");
  Future linkCheck() async {
    bool check = _link.hasMatch(text);
    if (check) {
      _hasLink = true;
      var link = _link.firstMatch(text);
      _url = text.substring(link.start, link.end);
      if (_url.contains('youtube') || _url.contains('youtu.be')) {
        Youtube response = await _youtubeService.getYTInfo(url: _url);
        _youtube = response;
       
        _newText = text.replaceAll(_link, "").trim();
        notifyListeners();
      } else {
        _newText = text.replaceAll(_link, "").trim();
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
