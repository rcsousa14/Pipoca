import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:pipoca/src/app/locator.dart';
import 'package:pipoca/src/constants/api/header.dart';
import 'package:pipoca/src/constants/api/url.dart';
import 'package:pipoca/src/models/link_info_model.dart';


@lazySingleton
class LinkRepository {

  final client = locator<ApiHeaders>().client;

  Future<LinkInfo> getLink(String link) async {
    try {
      var url = Uri.encodeFull('$heroku_url/link-info?url=$link');
      var response = await client.get(url);
      var parsed = json.decode(response.body);
      LinkInfo linkInfo = LinkInfo.fromJson(parsed);
      return linkInfo;
    } catch (e) {
      throw e;
    }
  }
}
