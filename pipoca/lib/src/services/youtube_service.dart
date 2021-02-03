import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:injectable/injectable.dart';
import 'package:pipoca/src/models/youtube_model.dart';

@lazySingleton
class YoutubeService {
  final client = http.Client();
  setHeaders() =>
      {'Content-type': 'application/json', 'Accept': 'application/json'};
  Future<Youtube> getYTInfo({String url}) async {
    try {
      var api = Uri.encodeFull('https://noembed.com/embed?url=$url');
      var response = await client.get(api, headers: setHeaders());
      var parsed = json.decode(response.body);
      Youtube youtube = Youtube.fromJson(parsed);
      return youtube; 
    } catch (e) {
      return e;
    }
  }
}
